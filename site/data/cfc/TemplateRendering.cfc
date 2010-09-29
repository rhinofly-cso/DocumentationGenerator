<cfscript>
/**
	Contains the methods to render information on documentation pages.
	
	@author Eelco Eggen
	@date 10 September 2010
	
	@see cfc.MetadataFactory
		cfc.DocumentBuilder
*/
component displayname="cfc.TemplateRendering" extends="fly.Object" accessors="true" output="false"
{
	/**
		Structure containing component metadata objects for all components in the library.
		
		@see cfc.cfcData.CFMetadata
	*/
	property struct library;
	
	/**
		List of the library struct keys, converted to last name by removing the package name.
	*/
	property string lastNameList;

	/**
		Converts a piece of string to a hyperlink, or text, depending whether such a link 
		would lead somewhere.
		
		@link String to be converted to a hyperlink.
		@rootPath If not present in the webroot, all links to local pages are prepended by this root path.
		@componentLastName Displays the link as the name behind the last dot of the full component name.
		@returnHRefOnly Returns null/void in case no hyperlink could be created.
		@fromPackageRoot Treats the current package directory as the webroot and strips links to components of the package path.
		@return HTML hyperlink or plain text.
	*/
	public string function convertToLink(required string link, string rootPath="", boolean componentLastName="false", boolean returnHRefOnly="false", boolean fromPackageRoot="false")
	{
		var componentLink_str = "";
		var componentName_str = "";
		var libraryList_str = "";
		var listCount_num = 0;
		var typeArray_bool = false;
		var componentPageExists_bool = false;
		var link_str = arguments.link;
		var libraryRef_struct = this.getLibrary();
		var lastNameList_str = this.getLastNameList();

		if (left(link_str, 7) eq "http://")
		{
			componentLink_str = "<a href=""";
			componentLink_str &= link_str;
			componentLink_str &= """>";
			componentLink_str &= link_str;
			componentLink_str &= "</a>";
			return componentLink_str;
		}
		else
		{
			componentName_str = listFirst(link_str, chr(35));
			if (right(componentName_str, 2) eq "[]")
			{
				componentName_str = removeChars(componentName_str, len(componentName_str) - 1, 2);
				typeArray_bool = true;
			}

			// check whether the component name can be determined uniquely from its last name
			if (listValueCount(lastNameList_str, componentName_str) eq 1)
			{
				libraryList_str = structKeyList(libraryRef_struct);
				componentName_str = listGetAt(libraryList_str, listFind(lastNameList_str, componentName_str));
			}
			
			if (structKeyExists(libraryRef_struct, componentName_str))
			{
				if (not libraryRef_struct[componentName_str].getPrivate())
				{
					componentPageExists_bool = true;
				}
			}
			if (componentPageExists_bool)
			{
				componentLink_str = "<a href=""";
				componentLink_str &= arguments.rootPath;
				if (arguments.fromPackageRoot)
				{
					componentLink_str &= listLast(componentName_str, ".");
				}
				else
				{
					componentLink_str &= replace(componentName_str, ".", "/", "all");
				}
				componentLink_str &= ".html";
				if (len(link_str) > len(componentName_str))
				{
					componentLink_str &= removechars(link_str, 1, len(componentName_str));
				}
				componentLink_str &= """ onclick=""javascript:loadClassListFrame('";
				if (not arguments.fromPackageRoot)
				{
					componentLink_str &= arguments.rootPath;
					componentLink_str &= replace(listDeleteAt(componentName_str, listLen(componentName_str, "."), "."), ".", "/", "all");
					componentLink_str &= "/";
				}
				componentLink_str &= "class-list.html');""";
				if (arguments.componentLastName)
				{
					componentLink_str &= " title=""";
					componentLink_str &= componentName_str;
					componentLink_str &= """>";
					componentLink_str &= listLast(componentName_str, ".");
				}
				else
				{
					componentLink_str &= ">";
					componentLink_str &= componentName_str;
				}
				componentLink_str &= "</a>";
				if (typeArray_bool)
				{
					componentLink_str &= "[]";
				}
				if (componentLastName and isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcData.CFInterface"))
				{
					componentLink_str = "<i>" & componentLink_str & "</i>";
				}
				return componentLink_str;
			}
			else
			{
				if (listFirst(componentName_str, ".") eq "java")
				{
					componentLink_str = "<a href=""";
					componentLink_str &= "http://download.oracle.com/javase/6/docs/api/";
					componentLink_str &= replace(componentName_str, ".", "/", "all");
					componentLink_str &= "/package-summary.html";
					if (len(link_str) > len(componentName_str))
					{
						componentLink_str &= removechars(link_str, 1, len(componentName_str));
					}
					componentLink_str &= """>";
					componentLink_str &= componentName_str;
					componentLink_str &= "</a>";
					if (typeArray_bool)
					{
						componentLink_str &= "[]";
					}
					return componentLink_str;
				}
				else
				{
					if (arguments.returnHRefOnly)
					{
						return ;
					}
					else
					{
						if (typeArray_bool)
						{
							componentName_str &= "[]";
						}
						return componentName_str;
					}
				}
			}
		}
	}

	/**
		Returns the hyperlink belonging to the package-detail page.
		
		@packageKey Name of the package to which the hyperlink refers.
	*/
	public string function packageLink(required string packageKey)
	{
		var displayName_str = "";
		var packagePath_str = "";
		var return_str = "";
		var packageKey_str = arguments.packageKey;
		
		if (packageKey_str eq "_topLevel")
		{
			displayName_str = "Top Level";
		}
		else
		{
			displayName_str = packageKey_str;
			packagePath_str = replace(packageKey_str, ".", "/", "all");
			packagePath_str &= "/";
		}

		return_str = "<a href=""";
		return_str &= packagePath_str;
		return_str &= "package-detail.html"" onclick=""javascript:loadClassListFrame('";
		return_str &= packagePath_str;
		return_str &= "class-list.html');"">";
		return_str &= displayName_str;
		return_str &= "</a>";
		
		return return_str;
	}
	
	/**
		Collects the hint from the metadata object and replaces all &#123;@link&#125; tags, 
		together with their subsequent links, with hyperlinks. For example,	{@link} 
		cfc.TemplateRendering is a link to the current page, rendered by this function.
		
		@metadataObject Metadata object from which to take the hint.
		@rootPath Path to the webroot.
		@type Obtain this type of hint: full (default), short, return, or throws.
	*/
	public string function renderHint(required any metadataObject, string rootPath="", string type="full")
	{
		var i = 0;
		var started_bool = false;
		var hint_str = "";
		var token_str = "";
		var punctuationMarks_str = "";
		var tagLength_num = 0;
		var parsedHint_str = "";
		var metadataRef_obj = arguments.metadataObject;
		var libraryRef_struct = this.getLibrary();
		
		if (arguments.type eq "short")
		{
			hint_str = metadataRef_obj.getShortHint();
		}
		else
		{
			if (arguments.type eq "return")
			{
				hint_str = metadataRef_obj.getReturnHint();
			}
			else // includes full (default) and throws
			{
				hint_str = metadataRef_obj.getHint();
			}
		}

		i = 1;
		while (true)
		{
			token_str = getToken(hint_str, i);
			if (len(token_str) eq 0)
			{
				break;
			}
			else
			{
				if (started_bool)
				{
					parsedHint_str &= " ";
				}
				else
				{
					started_bool = true;
				}

				if (token_str eq "{@link}")
				{
					i += 1;
					token_str = getToken(hint_str, i);
					// consider the fact that the link expression can be directly followed by one or more punctuation marks
					punctuationMarks_str = "";
					while (findOneOf("!?)}]>:;.,", right(token_str, 1)) or right(token_str, 3) eq "<br")
					{
						if (right(token_str, 1) eq ">")
						{
							// look for a line-break tag
							tagLength_num = len(token_str) - reFind("<br[\/]?>", token_str) + 1;
							if (tagLength_num > len(token_str))
							{
								tagLength_num = 1;
							}
							writeOutput("<p>Found token: ""#token_str#"".</p>");
							writeOutput("<p>Found punctuation: ""#right(token_str, tagLength_num)#"".</p>");
							punctuationMarks_str = right(token_str, tagLength_num) & punctuationMarks_str;
							token_str = removeChars(token_str, len(token_str) - tagLength_num + 1, tagLength_num);
						}
						else
						{
							// or a line-break tag containing a space
							if (right(token_str, 3) eq "<br")
							{
								punctuationMarks_str = "<br";
								token_str = removeChars(token_str, len(token_str) - 2, 3);
							}
							else
							{
								punctuationMarks_str = right(token_str, 1) & punctuationMarks_str;
								token_str = removeChars(token_str, len(token_str), 1);
							}
						}
					}
					token_str = convertToLink(token_str, arguments.rootPath);
					token_str &= punctuationMarks_str;
				}
				else
				{
					if (reFind("@link{.*}", token_str))
					{
						throw(message="Error: incorrect usage of the @link tag in the hint of #metadataRef_obj.getName()#.");
					}
				}
				parsedHint_str &= token_str;
				i += 1;
			}
		}
		return parsedHint_str;
	}
}
</cfscript>