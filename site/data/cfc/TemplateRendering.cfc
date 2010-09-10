<cfscript>
/**
	Contains the methods to render information on documentation pages.
	
	@author Eelco Eggen
	@date 10 September 2010
	
	@see cfc.MetadataFactory
*/
component displayname="cfc.TemplateRendering" extends="fly.Object" output="false"
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
		var libraryRef_struct = this.getLibrary;
		
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
}
</cfscript>