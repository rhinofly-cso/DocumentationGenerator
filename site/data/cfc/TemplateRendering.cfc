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
		Includes the function renderLink() from the html templates. This function determines 
		the html layout of hyperlinks.
	*/
	include "/templates/includes/fnc_renderLink.cfm";

	/**
		Sets values of the component variable scope, for performing quick searches.
		
		@see cfc.cfcData.CFMetadata
		@library Structure containing component metadata objects for all components in the library.
	*/
	public cfc.TemplateRendering function init(required struct library)
	{
		var i = 0;

		variables._libraryRef_struct = arguments.library;
		variables._libraryList_str = structKeyList(variables._libraryRef_struct);

		// make a list of the last names of all components for performing quick searches
		variables._lastNameList_str = "";
		for (i = 1; i <= listLen(variables._libraryList_str); i++)
		{
			variables._lastNameList_str = listAppend(variables._lastNameList_str, listLast(listGetAt(variables._libraryList_str, i), "."));
		}
		
		return this;
	}

	/**
		Checks whether the full component name can be determined uniquely from its last name 
		and returns it.
	*/
	public string function fullName(required string componentName)
	{
		var componentName_str = arguments.componentName;
		
		if (listValueCount(variables._lastNameList_str, componentName_str) eq 1)
		{
			componentName_str = listGetAt(variables._libraryList_str, listFind(variables._lastNameList_str, componentName_str));
		}
		
		return componentName_str;
	}

	/**
		Converts a component name to a url, if such a thing can be constructed. Otherwise, it 
		returns an empty string.

		@componentName Component name to be converted to a url.
		@rootPath If not present in the webroot, all links to local pages are prepended by this root path.
		@fromPackageRoot Treats the current package directory as the webroot and strips links to components of the package path.
	*/
	public string function toHRef(required string componentName, string rootPath="", boolean fromPackageRoot="false")
	{
		var componentLink_str = "";
		var componentName_str = arguments.componentName;
		var linkFromPackageRoot_bool = arguments.fromPackageRoot;
		
		// check whether the component name can be determined uniquely from its last name
		componentName_str = fullName(componentName_str);
		
		if (structKeyExists(variables._libraryRef_struct, componentName_str) and !variables._libraryRef_struct[componentName_str].getPrivate())
		{
			// if the component is part of the Top Level package content, links are always considered to originate from the package root
			if (listLen(componentName_str, ".") eq 1)
			{
				linkFromPackageRoot_bool = true;
			}

			componentLink_str = arguments.rootPath;
			if (linkFromPackageRoot_bool)
			{
				componentLink_str &= listLast(componentName_str, ".");
			}
			else
			{
				componentLink_str &= replace(componentName_str, ".", "/", "all");
			}
			componentLink_str &= ".html";
			return componentLink_str;
		}
		else
		{
			return "";
		}
	}

	/**
		Converts a component name to the url of the package class list corresponding to the 
		component, if such a thing can be constructed. Otherwise, it returns an empty string.

		@componentName Component name to be converted to a hyperlink.
		@rootPath If not present in the webroot, all links to local pages are prepended by this root path.
		@fromPackageRoot Treats the current package directory as the webroot and strips links to components of the package path.
	*/
	public string function toFrameLink(required string componentName, string rootPath="", boolean fromPackageRoot="false")
	{
		var frameLink_str = "";
		var componentName_str = arguments.componentName;
		var linkFromPackageRoot_bool = arguments.fromPackageRoot;

		// check whether the component name can be determined uniquely from its last name
		componentName_str = fullName(componentName_str);

		if (structKeyExists(variables._libraryRef_struct, componentName_str) and !variables._libraryRef_struct[componentName_str].getPrivate())
		{
			// if the component is part of the Top Level package content, links are always considered to originate from the package root
			if (listLen(componentName_str, ".") eq 1)
			{
				linkFromPackageRoot_bool = true;
			}

			frameLink_str = arguments.rootPath;
			if (not linkFromPackageRoot_bool)
			{
				frameLink_str &= replace(listDeleteAt(componentName_str, listLen(componentName_str, "."), "."), ".", "/", "all");
				frameLink_str &= "/";
			}
			frameLink_str &= "class-list.html";
			return frameLink_str;
		}
		else
		{
			return "";
		}
	}
	
	/**
		Checks if the component name belongs to an interface. If so, returns true, otherwise, 
		returns false
		@componentName Component name to be checked.
	*/
	public boolean function isInterface(required string componentName)
	{
		// check whether the component name can be determined uniquely from its last name
		var componentName_str = fullName(arguments.componentName);

		return isInstanceOf(variables._libraryRef_struct[componentName_str], "cfc.cfcData.CFInterface");
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
		var hint_str = "";
		var token_str = "";
		var punctuationMarks_str = "";
		var tagLength_num = 0;
		var parsedHint_str = "";
		var metadataRef_obj = arguments.metadataObject;
		
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

		while (true)
		{
			// remove spaces and get token
			hint_str = lTrim(hint_str);
			token_str = getToken(hint_str, 1);
			// if there is one, continue and remove it from the hint
			if (len(token_str) eq 0)
			{
				break;
			}
			hint_str = removeChars(hint_str, 1, len(token_str));

			// remove @link tag and convert following token to hyperlink
			if (token_str eq "{@link}")
			{
				hint_str = lTrim(hint_str);
				token_str = getToken(hint_str, 1);
				if (len(token_str) eq 0)
				{
					break;
				}
				hint_str = removeChars(hint_str, 1, len(token_str));

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

				token_str = renderLink(token_str, this, arguments.rootPath);
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
			// if there are any characters left in the hint, we append the first one (a space character) to the parsed hint
			if (len(hint_str) > 0)
			{
				parsedHint_str &= left(hint_str, 1);
			}
		}
		return parsedHint_str;
	}
}