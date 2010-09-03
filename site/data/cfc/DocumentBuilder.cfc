<cfscript>
/**
	Contains the methods to create documentation pages from a struct of metadata objects.
	
	@author Eelco Eggen
	@date 2 September 2010
	
	@see cfc.MetadataFactory
*/
component displayname="cfc.DocumentBuilder" extends="fly.Object" output="false"
{
	/**
		Sorts a list of components by the name behind the last dot of the full component name.
		
		@componentList List of component names.
	*/
	public string function sortByLastName(required string componentList)
	{
		var i = 0;
		var j = 0;
		var componentName_str = "";
		var reverseName_str = "";
//		var reverseList_str = "";
		var word_str = "";
		var components_str = arguments.componentList;

		// loop through all component names
		for (i = 1; i <= listLen(components_str); i++)
		{
			componentName_str = listGetAt(components_str, i);
			
			// reverse the order of expressions between (and around) the dots
			reverseName_str = "";
			for (j = 1; j <= listLen(componentName_str, "."); j++)
			{
				word_str = listGetAt(componentName_str, j, ".");
				reverseName_str = listPrepend(reverseName_str, word_str, ".");
			}
			components_str = listSetAt(components_str, i, reverseName_str);
		}

		// sort alphabetically
		components_str = listSort(components_str, "textnocase");

		// revert the names to their original form
		for (i = 1; i <= listLen(components_str); i++)
		{
			reverseName_str = listGetAt(components_str, i);
			componentName_str = "";
			for (j = 1; j <= listLen(reverseName_str, "."); j++)
			{
				word_str = listGetAt(reverseName_str, j, ".");
				componentName_str = listPrepend(componentName_str, word_str, ".");
			}
			components_str = listSetAt(components_str, i, componentName_str);
		}
		
		return components_str;
	}
	
	/**
		Creates an array of structures containing name and description keys. The names are 
		component names from the list given in the componentList argument and descriptions are 
		taken from the library structure. This structure must contain component metadata 
		objects.
		
		@componentList List of component names.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
		@see cfc.CFCMetadata
	*/
	public array function descriptionArrayFromList(required string componentList, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var componentName_str = "";
		var component_struct = "";
		var components_str = arguments.componentList;
		var libraryRef_struct = arguments.library;
		
		for (i = 1; i <= listLen(components_str); i++)
		{
			componentName_str = listGetAt(components_str, i);
			if (isInstanceOf(libraryRef_struct[componentName_str], "cfc.CFCMetadata"))
			{
				component_struct = structNew();
				structInsert(component_struct, "name", componentName_str);
				structInsert(component_struct, "description", libraryRef_struct[componentName_str].getShortHint());
				arrayAppend(return_arr, component_struct);
			}
		}
		return return_arr;
	}
	
	/**
		Converts a piece of string to a hyperlink, or text, depending wether such a link would 
		lead somewhere.
		
		@link String to be converted to a hyperlink.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
		@rootPath If not present in the webroot, all links to local pages are prepended by this root path.
		@componentLastName Displays the link as the name behind the last dot of the full component name.
		@fromPackageRoot Treats the current package directory as the webroot and strips links to components of the package path.
	*/
	public string function convertToLink(required string link, required struct library, string rootPath_str="", boolean componentLastName="false", boolean fromPackageRoot="false")
	{
		var componentName_str = "";
		var componentLink_str = "";
		var link_str = arguments.link;
		var libraryRef_struct = arguments.library;
		
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
				componentLink_str = "<a href=""";
				componentLink_str &= arguments.rootPath_str;
				if (fromPackageRoot)
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
				if (componentLastName and isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcMetadata.CFInterface"))
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
					return componentName_str;
				}
			}
		}
	}
}
</cfscript>