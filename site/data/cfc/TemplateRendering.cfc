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
		Converts a piece of string to a hyperlink, or text, depending whether such a link would 
		lead somewhere.
		
		@link String to be converted to a hyperlink.
		@rootPath If not present in the webroot, all links to local pages are prepended by this root path.
		@componentLastName Displays the link as the name behind the last dot of the full component name.
		@returnHRefOnly Returns null/void in case no hyperlink could be created.
		@fromPackageRoot Treats the current package directory as the webroot and strips links to components of the package path.
	*/
	public string function convertToLink(required string link, string rootPath="", boolean componentLastName="false", boolean returnHRefOnly="false", boolean fromPackageRoot="false")
	{
		var componentLink_str = "";
		var componentName_str = "";
		var componentPageExists_bool = false;
		var link_str = arguments.link;
		var libraryRef_struct = this.getLibrary();
		
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
				componentLink_str &= """";
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
						return componentName_str;
					}
				}
			}
		}
	}

	/**
		Returns the hyperlink belonging to the package-detail page.
		
		@packageName Name of the package to which the hyperlink refers.
	*/
	public string function packageLink(required string packageName)
	{
		var packagePath_str = "";
		var return_str = "";
		var packageName_str = arguments.packageName;
		
		if (packageName_str eq "_topLevel")
		{
			packageName_str = "";
		}
		else
		{
			packagePath_str = replace(packageName_str, ".", "/", "all");
			packagePath_str &= "/";
		}

		return_str = "<a href=""";
		return_str &= packagePath_str;
		return_str &= "package-detail.html"" onclick=""javascript:loadClassListFrame('";
		return_str &= packagePath_str;
		return_str &= "class-list.html');"">";
		if (len(packageName_str) > 0)
		{
			return_str &= packageName_str;
		}
		else
		{
			return_str &= "Top Level";
		}
		return_str &= "</a>";
		
		return return_str;
	}
	
	/**
		Collects the hint from the metadata object and replaces all &#123;@link&#125; tags, 
		together with their subsequent links, with hyperlinks. For example,	{@link} 
		cfc.TemplateRendering is a link to the current page.
		
		@metadataObject Metadata object from which to take the hint.
		@rootPath Path to the webroot.
		@type Obtains this type of hint: full (default), short, return, or throws.
	*/
	public string function renderHint(required any metadataObject, string rootPath="", string type="full")
	{
		var i = 0;
		var started_bool = false;
		var token_str = "";
		var punctuationMark_str = "";
		var parsedHint_str = "";
		var metadataRef_obj = arguments.metadataObject;
		var hint_str = metadataRef_obj.getHint();
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
			else
			{
				if (arguments.type eq "throws")
				{
					// in this case the metadata object actually is a struct
					hint_str = metadataRef_obj.description;
				}
				else
				{
					hint_str = metadataRef_obj.getHint();
				}
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
					punctuationMark_str = right(token_str, 1);
					if (findOneOf("!?)}]>:;.,", punctuationMark_str))
					{
						token_str = removeChars(token_str, len(token_str), 1);
						token_str = convertToLink(token_str, arguments.rootPath);
						token_str &= punctuationMark_str;
					}
					else
					{
						token_str = convertToLink(token_str, arguments.rootPath);
					}
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