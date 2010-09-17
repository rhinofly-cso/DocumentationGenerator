<cfscript>
/**
	Contains the methods to create metadata objects and assign its values.
	
	@author Eelco Eggen
	@date 18 August 2010
*/
component displayname="cfc.MetadataFactory" extends="fly.Object" output="false"
{
	/**
		Creates and returns an argument metadata object from a struct.
		
		@argumentMetadata Metadata struct for a single argument from a function metadata struct.
	*/
	public cfc.cfcData.CFArgument function createArgumentObject(required struct argumentMetadata)
	{
		var return_obj = createObject("component", "cfc.cfcData.CFArgument").init();
		var argumentRef_struct = arguments.argumentMetadata;

		// the "required", "type", and "hint" properties have default values
		return_obj.setRequired(false);
		return_obj.setType("any");
		return_obj.setHint("");
		
		// name		
		return_obj.setName(argumentRef_struct.name);
		
		// type
		if (structKeyExists(argumentRef_struct, "type"))
		{
			return_obj.setType(argumentRef_struct.type);
		}
		
		// default
		if (structKeyExists(argumentRef_struct, "default"))
		{
			return_obj.setDefault(argumentRef_struct.default);
		}
		
		// required
		if (structKeyExists(argumentRef_struct, "required"))
		{
			return_obj.setRequired(argumentRef_struct.required);
		}
		
		// hint
		if (structKeyExists(argumentRef_struct, "hint"))
		{
			return_obj.setHint(argumentRef_struct.hint);
		}
		
		return return_obj;		
	}
	
	/**
		@private
		Creates and assigns argument metadata objects to a function metadata object.
	*/
	private void function _resolveParameters(required struct functionMetadata, required any functionObject)
	{
		var i = 0;
		var argument_obj = "";
		var argumentObjs_arr = arrayNew(1);
		var functionRef_struct = arguments.functionMetadata;
		var parametersRef_arr = functionRef_struct.parameters;
		var functionRef_obj = arguments.functionObject;
		
		for (i = 1; i <= arrayLen(parametersRef_arr); i++)
		{
			argument_obj = createArgumentObject(parametersRef_arr[i]);
			arrayAppend(argumentObjs_arr, argument_obj);
		}
		
		functionRef_obj.setParameters(argumentObjs_arr);
	}

	/**
		Creates and returns a function metadata object from a struct.
		
		@functionMetadata Metadata struct for a single function from getMetadata.
	*/
	public cfc.cfcData.CFFunction function createFunctionObject(required struct functionMetadata)
	{
		var return_obj = createObject("component", "cfc.cfcData.CFFunction").init();
		var functionRef_struct = arguments.functionMetadata;
		
		// the "access", "returnType", "returnHint", "inheritDoc", and "private" properties have default values
		return_obj.setAccess("public");
		return_obj.setReturnType("any");
		return_obj.setReturnHint("");
		return_obj.setInheritDoc(false);
		return_obj.setPrivate(false);
		// additionally, the "hint" property is set to "" by default in _resolveHint()
		
		// name		
		return_obj.setName(functionRef_struct.name);
		
		// access		
		if (structKeyExists(functionRef_struct, "access"))
		{
			return_obj.setAccess(functionRef_struct.access);
		}
		
		// returnType
		if (structKeyExists(functionRef_struct, "returnType"))
		{
			return_obj.setReturnType(functionRef_struct.returnType);
		}
		
		// returnHint		
		if (structKeyExists(functionRef_struct, "return"))
		{
			return_obj.setReturnHint(functionRef_struct.return);
		}
		
		// inheritDoc
		if (structKeyExists(functionRef_struct, "inheritDoc"))
		{
			return_obj.setInheritDoc(functionRef_struct.inheritDoc);
		}
		
		// author - possible, but not preferred
		if (structKeyExists(functionRef_struct, "author"))
		{
			return_obj.setAuthor(functionRef_struct.author);
		}
		
		// date - possible, but not preferred
		if (structKeyExists(functionRef_struct, "date"))
		{
			return_obj.setDate(functionRef_struct.date);
		}
		
		// private
		if (structKeyExists(functionRef_struct, "private"))
		{
			return_obj.setPrivate(functionRef_struct.private);
		}
		
		if (structKeyExists(functionRef_struct, "parameters"))
		{
			_resolveParameters(functionRef_struct, return_obj);
		}
		else
		{
			return_obj.setParameters(arrayNew(1));
		}
		
		return return_obj;
	}
	
	/**
		@private
		Determines whether the hint contained @throws and/or @see tags that were removed by
		the parsing of CFScript code. If so, these are retrieved from the .cfc file and
		processed. Alternatively, for tag-based CF code, the tags in the hint are all parsed.
		
		@path File path of the cfc that contains the code for the given metadata object.
	*/
	private void function _resolveHint(required struct metadata, required any returnObject, required string path)
	{
		var hint_str = "";
		var search_str = "";
		var file_str = "";
		var comment_str = "";
		var reverse_str = "";
		var defWords_str = "";
		var token_str = "";
		var tag_str = "";
		var defStart_num = 0;
		var endFromLast_num = 0;
		var beginFromLast_num = 0;
		var i = 0;
		var exceptionMetadata_obj = "";
		var commentFound_bool = false;
		var functionHint_bool = false;
		var throwsTagFollow_bool = false;
		var seeTagFollow_bool = false;
		var hintTag_bool = false;
		var parsedHint_str = "";
		var metadataRef_struct = arguments.metadata;
		var returnRef_obj = arguments.returnObject;

		// obtain the initial value of the hint
		if (structKeyExists(metadataRef_struct, "hint"))
		{
			hint_str &= metadataRef_struct.hint;
		}
		if (structKeyExists(metadataRef_struct, "description"))
		{
			hint_str &= metadataRef_struct.description;
		}

		if (structKeyExists(metadataRef_struct, "throws") or structKeyExists(metadataRef_struct, "see"))
		{
			// determine type and matching search string
			if (isInstanceOf(returnRef_obj, "cfc.cfcData.CFProperty"))
			{
				// look for the word "property" and its name, on one or more lines 
				// before encountering a semicolon 
				search_str = "\bproperty\b[^;]*\b";
				search_str &= returnRef_obj.getName();
				search_str &= "[^\w\.=]";
			}
			else
			{
				if (isInstanceOf(returnRef_obj, "cfc.cfcData.CFFunction"))
				{
					// look for the word "function" and its name, on one or more lines
					// before encountering a curly bracket
					search_str = "\bfunction\b[^\(]*\b";
					search_str &= returnRef_obj.getName();
					search_str &= "\b";
					functionHint_bool = true;
				}
				else
				{
					if (isInstanceOf(returnRef_obj, "cfc.cfcData.CFComponent"))
					{
						// look for the word "component" followed by a curly bracket
						// either on the same line or at the start of the next
						search_str = "\bcomponent\b[^\n\r]*[\s]*\{";
					}
					else
					{
						if (isInstanceOf(returnRef_obj, "cfc.cfcData.CFInterface"))
						{
							// look for the word "interface" followed by a curly bracket
							// either on the same line or at the start of the next
							search_str = "\binterface\b[^\n\r]*[\s]*\{";
						}
						else
						{
							throw(message="Could not process hint for type #getMetadata(returnRef_obj).name#.");
						}
					}
	
				}
			}
			
			// we have a hint to parse from CFScript code, which must be isolated by applying the search string
			file_str = FileRead(arguments.path);
			defStart_num = 1;

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
						endFromLast_num = find("/*", reverse_str);
				}

				// next, extract the words in between the comment and the definition
				// these must not contain curly brackets or semicolons
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
				beginFromLast_num = find("**/", reverse_str);
				comment_str = right(comment_str, beginFromLast_num - 1);
				comment_str = left(comment_str, beginFromLast_num - endFromLast_num - 2);

				// parsing the hint one line after another
				i = 1;
				while (true)
				{
					token_str = getToken(comment_str, i, chr(10));
					// getToken only returns an empty string if index i is larger than the number of tokens
					if (len(token_str) eq 0)
					{
						break;
					}
					else
					{
						// get hint line
						token_str = trim(token_str);
						if (left(token_str, 1) eq "*")
						{
							token_str = trim(removeChars(token_str, 1, 1));
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
							if (functionHint_bool)
							{
								if (find("@throws", token_str) eq 1)
								{
									token_str = trim(removechars(token_str, 1, 7));
									exceptionMetadata_obj = createObject("component", "cfc.cfcData.CFMetadata");
									exceptionMetadata_obj.setName(getToken(token_str, 1));
									exceptionMetadata_obj.setHint(trim(removechars(token_str, 1, len(getToken(token_str, 1)))));
									returnRef_obj.addThrows(exceptionMetadata_obj);
									throwsTagFollow_bool = true;
								}
							}
							if (find("@see", token_str) eq 1)
							{
								returnRef_obj.addRelated(trim(removechars(token_str, 1, 4)));
								seeTagFollow_bool = true;
							}
							if (tag_str eq "@hint")
							{
								parsedHint_str = trim(removechars(token_str, 1, 7));
								hintTag_bool = true;
							}
							if (tag_str eq "@internal")
							{
								hintTag_bool = true;
							}
						}
						else
						{
							if (not hintTag_bool)
							{
								parsedHint_str &= token_str;
								parsedHint_str &= " ";
							}
						}
						i += 1;
					}
				}
			}
		}
		else
		{
			// tag-based hint parsing
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
					token_str = trim(token_str);
					if (left(token_str, 1) eq "*")
					{
						token_str = trim(removeChars(token_str, 1, 1));
					}
					
					// parse hint line
					if (find("@", token_str) eq 1)
					{
						tag_str = getToken(token_str, 1);
						if (tag_str eq "@author")
						{
							returnRef_obj.setAuthor(trim(removechars(token_str, 1, 7)));
						}
						if (tag_str eq "@date")
						{
							returnRef_obj.setDate(trim(removechars(token_str, 1, 5)));
						}
						if (tag_str eq "@hint")
						{
							parsedHint_str = trim(removechars(token_str, 1, 7));
							hintTag_bool = true;
						}
						if (tag_str eq "@internal")
						{
							hintTag_bool = true;
						}
						if (tag_str eq "@private")
						{
							returnRef_obj.setPrivate(true);
						}
						if (tag_str eq "@see")
						{
							returnRef_obj.addRelated(trim(removechars(token_str, 1, 4)));
						}
						if (functionHint_bool)
						{
							if (tag_str eq "@return")
							{
								returnRef_obj.setReturnHint(trim(removechars(token_str, 1, 7)));
							}
							if (find("@throws", token_str) eq 1)
							{
								token_str = trim(removechars(token_str, 1, 7));
								exceptionMetadata_obj = createObject("component", "cfc.cfcData.CFMetadata");
								exceptionMetadata_obj.setName(getToken(token_str, 1));
								exceptionMetadata_obj.setHint(trim(removechars(token_str, 1, len(getToken(token_str, 1)))));
								returnRef_obj.addThrows(exceptionMetadata_obj);
								throwsTagFollow_bool = true;
							}
							if (tag_str eq "@inheritDoc")
							{
								returnRef_obj.setInheritDoc(true);
							}
						}
					}
					else
					{
						if (not hintTag_bool)
						{
							parsedHint_str &= token_str;
							parsedHint_str &= " ";
						}
					}
					i += 1;
				}
			}
		}

		// assignment of the remaining hint
		returnRef_obj.setHint(trim(parsedHint_str));
	}

	/**
		@private
		Determines the methods of the component and sets the appropriate parameters.
	*/
	private void function _resolveFunctions(required struct metadata, required any returnObject)
	{
		var functionsRef_arr = "";
		var functionObjs_arr = arrayNew(1);
		var function_obj = "";
		var i = 0;
		var metadataRef_struct = arguments.metadata;
		var returnRef_obj = arguments.returnObject;
		
		if (structKeyExists(metadataRef_struct, "functions"))
		{
			functionsRef_arr = metadataRef_struct.functions;
			for (i = 1; i <= arrayLen(functionsRef_arr); i++)
			{
				function_obj = createFunctionObject(functionsRef_arr[i]);
				_resolveHint(functionsRef_arr[i], function_obj, metadataRef_struct.path);

				arrayAppend(functionObjs_arr, function_obj);
			}
			
			returnRef_obj.setFunctions(functionObjs_arr);
		}
	}
	
	/**
		Creates and returns a property metadata object from a struct.
		
		@propertyMetadata Metadata struct for a single property from getMetadata.
	*/
	public cfc.cfcData.CFProperty function createPropertyObject(required struct propertyMetadata)
	{
		var return_obj = createObject("component", "cfc.cfcData.CFProperty").init();
		var propertyRef_struct = arguments.propertyMetadata;
		
		// the "type", "serializable", and "private" properties have default values
		return_obj.setType("any");
		return_obj.setSerializable(true);
		return_obj.setPrivate(false);
		// additionally, the "hint" property is set to "" by default in _resolveHint()
		
		// name		
		return_obj.setName(propertyRef_struct.name);
		
		// type
		if (structKeyExists(propertyRef_struct, "type"))
		{
			return_obj.setType(propertyRef_struct.type);
		}
		
		// serializable		
		if (structKeyExists(propertyRef_struct, "serializable"))
		{
			return_obj.setSerializable(propertyRef_struct.serializable);
		}
		
		// author - possible, but not preferred
		if (structKeyExists(propertyRef_struct, "author"))
		{
			return_obj.setAuthor(propertyRef_struct.author);
		}
		
		// date - possible, but not preferred
		if (structKeyExists(propertyRef_struct, "date"))
		{
			return_obj.setDate(propertyRef_struct.date);
		}
		
		// private
		if (structKeyExists(propertyRef_struct, "private"))
		{
			return_obj.setPrivate(propertyRef_struct.private);
		}
		
		return return_obj;
	}
	
	/**
		@private
		Determines the properties of the component and sets the appropriate parameters.
	*/
	private void function _resolveProperties(required struct metadata, required any returnObject)
	{
		var propertiesRef_arr = "";
		var propertyObjs_arr = arrayNew(1);
		var property_obj = "";
		var i = 0;
		var metadataRef_struct = arguments.metadata;
		var returnRef_obj = arguments.returnObject;
		
		if (structKeyExists(metadataRef_struct, "properties"))
		{
			propertiesRef_arr = metadataRef_struct.properties;
			for (i = 1; i <= arrayLen(propertiesRef_arr); i++)
			{
				property_obj = createPropertyObject(propertiesRef_arr[i]);
				_resolveHint(propertiesRef_arr[i], property_obj, metadataRef_struct.path);

				arrayAppend(propertyObjs_arr, property_obj);
			}
			
			returnRef_obj.setProperties(propertyObjs_arr);
		}
	}

	/**
		@private
		Determines the inheritance of a component and sets the appropriate parameters. 
		If no reference object is made yet for a certain component up in the hierarchy, the 
		information is stored temporarily in the libraryRef_struct["_extendedByQueue"] struct.
	*/
	private void function _resolveInheritance(required struct metadata, required struct library, required any returnObject)
	{
		var extends_str = "";
		var extendedComponent_str = "";
		var extendedBy_str = "";
		var implements_str = "";
		var implementedComponent_str = "";
		var implementedBy_str = "";
		var i = 0;
		var metadataRef_struct = arguments.metadata;
		var libraryRef_struct = arguments.library;
		var name_str = metadataRef_struct.name;
		var returnRef_obj = arguments.returnObject;

		if (structKeyExists(metadataRef_struct, "extends"))
		{
			// set the inheritance for this component
			if (metadataRef_struct.type == "component")
			{
				extends_str = metadataRef_struct.extends.name;
			}
			else
			{
				extends_str = structKeyList(metadataRef_struct.extends);
			}
			for (i = 1; i <= listLen(extends_str); i++)
			{
				if (listGetAt(extends_str, i) eq "WEB-INF.cftags.component" or listGetAt(extends_str, i) eq "WEB-INF.cftags.interface")
				{
					extends_str = listDeleteAt(extends_str, i);
					break;
				}
			}
			if (len(extends_str) > 0)
			{
				returnRef_obj.setExtends(extends_str);
			}
	
			// set the inheritance info for ancestors of this component
			// when no metadata object is present for the ancestor, we add its name to the 
			// queue
			for (i = 1; i <= listLen(extends_str); i++)
			{
				extendedComponent_str = listGetAt(extends_str, i);
	
				if (structKeyExists(libraryRef_struct, extendedComponent_str))
				{
					libraryRef_struct[extendedComponent_str].addExtendedBy(name_str);
				}
				else
				{
					if (structKeyExists(libraryRef_struct["_extendedByQueue"], extendedComponent_str))
					{
						extendedBy_str = libraryRef_struct["_extendedByQueue"][extendedComponent_str];
						libraryRef_struct["_extendedByQueue"][extendedComponent_str] = listAppend(extendedBy_str, name_str);
					}
					else
					{
						structInsert(libraryRef_struct["_extendedByQueue"], extendedComponent_str, name_str);
					}
				}
			}
		}
		// do the same for interface implementation
		if (structKeyExists(metadataRef_struct, "implements"))
		{
			// set the inheritance for this component
			implements_str = structKeyList(metadataRef_struct.implements);
			returnRef_obj.setImplements(implements_str);
	
			// set the inheritance info for interfaces that this component implements
			// when no metadata object is present for the interface, we add its name to the 
			// queue
			for (i = 1; i <= listLen(implements_str); i++)
			{
				implementedComponent_str = listGetAt(implements_str, i);
	
				if (structKeyExists(libraryRef_struct, implementedComponent_str))
				{
					libraryRef_struct[implementedComponent_str].addImplementedBy(name_str);
				}
				else
				{
					if (structKeyExists(libraryRef_struct["_implementedByQueue"], implementedComponent_str))
					{
						implementedBy_str = libraryRef_struct["_implementedByQueue"][implementedComponent_str];
						libraryRef_struct["_implementedByQueue"][implementedComponent_str] = listAppend(implementedBy_str, name_str);
					}
					else
					{
						structInsert(libraryRef_struct["_implementedByQueue"], implementedComponent_str, name_str);
					}
				}
			}
		}			
		// and finally check for previously existing inheritance information
		// if a component was earlier found to extend or implement this component, its name is 
		// taken from the queue and set as an ancestor of implementor, respectively
		if (structKeyExists(libraryRef_struct["_extendedByQueue"], name_str))
		{
			returnRef_obj.setExtendedBy(libraryRef_struct["_extendedByQueue"][name_str]);
			structDelete(libraryRef_struct["_extendedByQueue"], name_str);
		}
		if (structKeyExists(libraryRef_struct["_implementedByQueue"], name_str))
		{
			returnRef_obj.setImplementedBy(libraryRef_struct["_implementedByQueue"][name_str]);
			structDelete(libraryRef_struct["_implementedByQueue"], name_str);
		}
	}
	
	/**
		Determines the data type, creates the appropriate object, and returns it.
		
		@metadata Metadata struct of the component, or interface.
		@library Reference to a struct in which the component objects and inheritance information will be stored.
	*/
	public cfc.cfcData.CFC function createMetadataObject(required struct metadata, required struct library)
	{
		var metadataRef_struct = arguments.metadata;
		var libraryRef_struct = arguments.library;
		var name_str = metadataRef_struct.name;
		var return_obj = "";
		
		// we make sure that the extendedBy queue and implementedBy queue structs exist
		// these are necessary for generating correct inheritance information
		// as each component is evaluated, its name is added to the list of known subclasses
		// or implementors
		if (not structKeyExists(libraryRef_struct, "_extendedByQueue"))
		{
			structInsert(libraryRef_struct, "_extendedByQueue", structNew());
		}
		if (not structKeyExists(libraryRef_struct, "_implementedByQueue"))
		{
			structInsert(libraryRef_struct, "_implementedByQueue", structNew());
		}
		
		// determine the type and create the appropriate object
		if (metadataRef_struct.type eq "component")
		{
			return_obj = createObject("component", "cfc.cfcData.CFComponent").init();
			
			// the "serializable" property has a default value for components
			return_obj.setSerializable(true);
		}
		else
		{
			if (metadataRef_struct.type eq "interface")
			{
				return_obj = createObject("component", "cfc.cfcData.CFInterface").init();
			}
			else
			{
				throw (message="Error: unknown CFC type #metadataRef_struct.type#.")
			}
		}
		
		// the "private" property has a default value for both components and interfaces
		return_obj.setPrivate(false);
		// additionally, the "hint" property is set to "" by default in _resolveHint()
		
		// name		
		return_obj.setName(name_str);
		
		// serializable
		if (structKeyExists(metadataRef_struct, "serializable"))
		{
			return_obj.setSerializable(metadataRef_struct.serializable);
		}

		// author
		if (structKeyExists(metadataRef_struct, "author"))
		{
			return_obj.setAuthor(metadataRef_struct.author);
		}

		// date
		if (structKeyExists(metadataRef_struct, "date"))
		{
			return_obj.setDate(metadataRef_struct.date);
		}

		// private
		if (structKeyExists(metadataRef_struct, "private"))
		{
			return_obj.setPrivate(metadataRef_struct.private);
		}

		_resolveHint(metadataRef_struct, return_obj, metadataRef_struct.path);
		_resolveInheritance(metadataRef_struct, libraryRef_struct, return_obj);
		_resolveProperties(metadataRef_struct, return_obj);
		_resolveFunctions(metadataRef_struct, return_obj);
		
		return return_obj;
	}
	
	/**
		Read directory and all subdirectories for .cfc files. Then append all metadata found 
		for their contents to the library struct in the form of metadata objects and to the 
		packages structs in the form of package content. In both cases, key strings are 
		component names.
		
		@path Directory to be read.
		@customTagPath Root directory of the library.
		@library Library struct into which this function inserts component metadata objects.
		@packages Structure into which this function inserts package content structs.
	*/
	public void function browseDirectory(required string path, required string customTagPath, required struct library, required struct packages)
	{
		var i = 0;
		var files_qry = "";
		var dirs_qry = "";
		var componentName_str = "";
		var directoryPath_str = "";
		var packageName_str = "";
		var packageKey_str = "";
		var metadata_struct = "";
		var metadata_obj = "";
		var path_str = arguments.path;
		var customTagPath_str = arguments.customTagPath;
		var libraryRef_struct = arguments.library;
		var packagesRef_struct = arguments.packages;
		
		// set the package name
		packageName_str = removeChars(path_str, 1, len(customTagPath_str));
		packageName_str = reReplace(packageName_str, "[/\\]+", ".", "all");
		if (left(packageName_str, 1) eq ".")
		{
			packageName_str = removeChars(packageName_str, 1, 1);
		}
		if (right(packageName_str, 1) eq ".")
		{
			packageName_str = removeChars(packageName_str, len(packageName_str), 1);
		}

		// set the package key string for use in the library and packages structs
		if (len(packageName_str) eq 0)
		{
			packageKey_str = "_topLevel";
		}
		else
		{
			packageKey_str = packageName_str;
		}

		// retrieve the filenames of all components
		files_qry = directoryList(path_str, false, "query", "*.cfc");
		if (files_qry.recordCount > 0)
		{
			structInsert(packagesRef_struct, packageKey_str, structNew());
		}
		// for each component found
		for (i = 1; i <= files_qry.recordCount; i++)
		{
			// set the component name
			componentName_str = packageName_str;
			if (len(packageName_str) > 0)
			{
				componentName_str &= ".";
			}
			componentName_str &= listGetAt(files_qry.name[i], 1, ".");
			
			// get its metadata
			try
			{
				metadata_struct = getComponentMetadata(componentName_str);
			}
			catch (any excptn)
			{
				throw(message="Could not obtain component metadata for #componentName_str#.");
			}
			// create the metadata object and insert it into the library struct
			metadata_obj = createMetadataObject(metadata_struct, libraryRef_struct);
			structInsert(libraryRef_struct, componentName_str, metadata_obj);

			// add component name to the list of components/interfaces in the packages struct
			if (structKeyExists(packagesRef_struct[packageKey_str], metadata_struct.type))
			{
				componentName_str = listAppend(packagesRef_struct[packageKey_str][metadata_struct.type], componentName_str);
				packagesRef_struct[packageKey_str][metadata_struct.type] = componentName_str;
			}
			else
			{
				structInsert(packagesRef_struct[packageKey_str], metadata_struct.type, componentName_str);
			}
		}
		
		// do the same for all subdirectories
		dirs_qry = directoryList(path_str, false, "query");
		for (i = 1; i <= dirs_qry.recordCount; i++)
		{
			// we exclude folder determined by filter conditions set in Application.cfc
			if (dirs_qry.type[i] eq "Dir" and not reFind(application.reExcludedFolders, dirs_qry.name[i]))
			{
				directoryPath_str = path_str;
				// the forward slash is always supposed to work
				directoryPath_str &= "/";
				directoryPath_str &= dirs_qry.name[i];
				browseDirectory(directoryPath_str, customTagPath_str, libraryRef_struct, packagesRef_struct);
			}
		}		
	}
}
</cfscript>