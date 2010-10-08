/**
	Contains the methods to process tags in the hints of components, properties, and functions.
	
	@author Eelco Eggen
	@date 8 October 2010
*/
component displayname="cfc.hintResolver" extends="fly.Object" output="false"
{
	/**
		@private
		Determines whether the hint contained @throws and/or @see tags that were removed by
		the parsing of CFScript code. If so, these are retrieved from the .cfc file and
		correctly processed. Alternatively, for tag-based CF code, all tags present in the 
		hint are parsed.
		
		@path Path of the .cfc file that contains the code for the given metadata object.
	*/
	public void function resolveHint(required struct metadata, required any metadataObject, required string path)
	{
		var parsedHint_str = "";
		var metadataRef_struct = arguments.metadata;
		var metadataRef_obj = arguments.metadataObject;

		/*
			Check for the presence of throws or see attributes, if one of these exist we may 
			have incorrect hint metadata.
			This is due to the fact that ColdFusion does parse metadata/documentation tags to 
			the component metadata structure for CFScript, after which it removes them from 
			the hint metadata. However, this only works well with the single use of tags. When 
			used more than once, only the last instance is parsed.
			Conversely, for tag-based code, ColdFusion does nothing with the tags and they 
			remain present in the hint metadata.
		*/
		if (structKeyExists(metadataRef_struct, "throws") or structKeyExists(metadataRef_struct, "see"))
		{
			parsedHint_str = _resolveScriptHint(arguments.path, metadataRef_obj);
		}
		else
		{
			parsedHint_str = _resolveTagHint(metadataRef_struct, metadataRef_obj);
		}
	}
	
	/**
		@private
		Extracts the comment from the .cfc file and passes it to the parser.
	*/
	private void function _resolveScriptHint(required string path, required any metadataObject)
	{
		var search_str = "";
		var file_str = "";
		var comment_str = "";
		var reverse_str = "";
		var defWords_str = "";
		var defStart_num = 0;
		var endFromLast_num = 0;
		var beginFromLast_num = 0;
		var functionHint_bool = false;
		var commentFound_bool = false;
		var metadataRef_obj = arguments.metadataObject;

		// determine metadata object type and matching search string
		if (isInstanceOf(metadataRef_obj, "cfc.cfcData.CFProperty"))
		{
			// look for the word "property" and its name, on one or more lines 
			// before encountering a semicolon 
			search_str = "\bproperty\b[^;]*\b";
			search_str &= metadataRef_obj.getName();
			search_str &= "[^\w\.=]";
		}
		else
		{
			if (isInstanceOf(metadataRef_obj, "cfc.cfcData.CFFunction"))
			{
				// look for the word "function" and its name, on one or more lines
				// before encountering a curly bracket
				search_str = "\bfunction\b[^\(]*\b";
				search_str &= metadataRef_obj.getName();
				search_str &= "\b";
				functionHint_bool = true;
			}
			else
			{
				if (isInstanceOf(metadataRef_obj, "cfc.cfcData.CFComponent"))
				{
					// look for the word "component" followed by a curly bracket
					// either on the same line or at the start of the next
					search_str = "\bcomponent\b[^\n\r]*[\s]*\{";
				}
				else
				{
					if (isInstanceOf(metadataRef_obj, "cfc.cfcData.CFInterface"))
					{
						// look for the word "interface" followed by a curly bracket
						// either on the same line or at the start of the next
						search_str = "\binterface\b[^\n\r]*[\s]*\{";
					}
					else
					{
						throw(message="Could not process hint for type #getMetadata(metadataRef_obj).name#.");
					}
				}

			}
		}
		
		// we have a hint to parse from CFScript code, which must be isolated by applying the search string
		file_str = fileRead(arguments.path);

		do
		{
			// first, apply the search string and look for the nearest preceding comment
			defStart_num = reFind(search_str, file_str, defStart_num + 1);
			switch (defStart_num)
			{
				case 0:
					endFromLast_num = 0;
					break;
				case 1:
					endFromLast_num = 0;
					break;
				default:
					comment_str = trim(left(file_str, defStart_num - 1));
					reverse_str = reverse(comment_str);
					//find the end of the comment
					endFromLast_num = find("/*", reverse_str);
			}

			/*
				Next, extract the words in between the comment and the definition: 
				there must be none.
				Except for function definitions, where these words must not contain curly 
				brackets or semicolons.
			*/
			switch (endFromLast_num)
			{
				case 0:
					break;
				case 1:
					commentFound_bool = true;
					break;
				default:
					defWords_str = right(comment_str, endFromLast_num - 1);
					if (functionHint_bool and findOneOf("{};", defWords_str) eq 0)
					{
						commentFound_bool = true;
					}
			}
		} while (defStart_num > 0 and not commentFound_bool);
		
		if (commentFound_bool)
		{
			// find the beginning of the comment, and extract it
			beginFromLast_num = find("**/", reverse_str);
			comment_str = right(comment_str, beginFromLast_num - 1);
			comment_str = left(comment_str, beginFromLast_num - endFromLast_num - 2);
			
			_parseHint(comment_str, metadataRef_obj);
		}
	}
	
	/**
		@private
		Extracts the comment from the .cfc file and passes it to the parser.
	*/
	private void function _resolveTagHint(required struct metadata, required any metadataObject)
	{
		var hint_str = "";
		var metadataRef_obj = arguments.metadataObject;
		var metadataRef_struct = arguments.metadata;

		// obtain the initial value of the hint
		if (structKeyExists(metadataRef_struct, "hint"))
		{
			hint_str &= metadataRef_struct.hint;
		}
		if (structKeyExists(metadataRef_struct, "description"))
		{
			if (len(hint_str) > 0)
			{
				hint_str &= chr(10);
			}
			hint_str &= metadataRef_struct.description;
		}
		
		_parseHint(hint_str, metadataRef_obj);
	}
	
	/**
		@private
		Parses all tags in the hint string, assigns their values to the metadataObject, as well as the remaining hint.
	*/
	private string function _parseHint(required string hint, required any metadataObject)
	{
		var token_str = "";
		var tag_str = "";
		var i = 0;
		var functionHint_bool = false;
		var throwsTagFollow_bool = false;
		var seeTagFollow_bool = false;
		var hintTag_bool = false;
		var exceptionMetadata_obj = "";
		var parsedHint_str = "";
		var hint_str = arguments.hint;
		var metadataRef_obj = arguments.metadataObject;

		// determine if the metadata object represents function metadata
		// for the possible use of @return or @throws tags
		if (isInstanceOf(metadataRef_obj, "cfc.cfcData.CFFunction"))
		{
			functionHint_bool = true;
		}

		i = 1;
		while (true)
		{
			token_str = getToken(hint_str, i, chr(10));
			// getToken only returns an empty string if index i is larger than the number of tokens
			if (len(token_str) eq 0)
			{
				break;
			}
			else
			{
				// get hint line
				token_str = lTrim(token_str);
				if (left(token_str, 1) eq "*")
				{
					token_str = lTrim(removeChars(token_str, 1, 1));
				}
				
				// if we previously encountered @throws	or @see
				// we check for new tokens or additional input lines
				if (throwsTagFollow_bool)
				{
					if (left(token_str, 1) eq "@" or len(token_str) eq 0)
					{
						throwsTagFollow_bool = false;
					}
					else
					{
						token_str = "@throws " & token_str;
					}
				}
				if (seeTagFollow_bool)
				{
					if (left(token_str, 1) eq "@" or len(token_str) eq 0)
					{
						seeTagFollow_bool = false;
					}
					else
					{
						token_str = "@see " & token_str;
					}
				}

				// parse hint line
				if (find("@", token_str) eq 1)
				{
					tag_str = getToken(token_str, 1);
					if (tag_str eq "@author")
					{
						metadataRef_obj.setAuthor(trim(removechars(token_str, 1, 7)));
					}
					if (tag_str eq "@date")
					{
						metadataRef_obj.setDate(trim(removechars(token_str, 1, 5)));
					}
					if (tag_str eq "@hint")
					{
						parsedHint_str = trim(removechars(token_str, 1, 5));
						hintTag_bool = true;
					}
					if (tag_str eq "@internal")
					{
						hintTag_bool = true;
					}
					if (tag_str eq "@private")
					{
						metadataRef_obj.setPrivate(true);
					}
					if (tag_str eq "@see")
					{
						metadataRef_obj.addRelated(trim(removechars(token_str, 1, 4)));
						seeTagFollow_bool = true;
					}
					if (functionHint_bool)
					{
						if (tag_str eq "@return")
						{
							metadataRef_obj.setReturnHint(trim(removechars(token_str, 1, 7)));
						}
						if (tag_str eq "@throws")
						{
							token_str = trim(removechars(token_str, 1, 7));
							exceptionMetadata_obj = createObject("component", "cfc.cfcData.CFMetadata");
							exceptionMetadata_obj.setName(getToken(token_str, 1));
							exceptionMetadata_obj.setHint(trim(removechars(token_str, 1, len(getToken(token_str, 1)))));
							metadataRef_obj.addThrows(exceptionMetadata_obj);
							throwsTagFollow_bool = true;
						}
						if (tag_str eq "@inheritDoc")
						{
							metadataRef_obj.setInheritDoc(true);
						}
					}
				}
				else
				{
					if (not hintTag_bool)
					{
						parsedHint_str &= token_str;
						parsedHint_str &= chr(10);
					}
				}
				i += 1;
			}
		}

		// assignment of the remaining hint
		metadataRef_obj.setHint(trim(parsedHint_str));
	}
}