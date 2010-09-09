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
		@see cfc.cfcData.CFC
	*/
	public array function descriptionArray(required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var componentName_str = "";
		var component_struct = "";
		var libraryRef_struct = arguments.library;
		var components_str = structKeyList(libraryRef_struct);

		components_str = sortByLastName(components_str);
		
		for (i = 1; i <= listLen(components_str); i++)
		{
			componentName_str = listGetAt(components_str, i);
			if (isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcData.CFC"))
			{
				if (not libraryRef_struct[componentName_str].getPrivate())
				{
					component_struct = structNew();
					structInsert(component_struct, "name", componentName_str);
					structInsert(component_struct, "description", libraryRef_struct[componentName_str].getShortHint());
					arrayAppend(return_arr, component_struct);
				}
			}
		}
		return return_arr;
	}
	
	/**
		@private
		Inserts new property metadata objects into the allProperties struct for the properties 
		of component and its ancestors.
	*/
	private void function _collectProperties(required string component, required struct library, required struct allProperties)
	{
		var i = 0;
		var propertyName_str = "";
		var property_struct = "";
		var componentName_str = arguments.component;
		var libraryRef_struct = arguments.library;
		var propertiesRef_arr = libraryRef_struct[componentName_str].getProperties();
		var extendsRef_str = libraryRef_struct[componentName_str].getExtends();
		var allPropertiesRef_struct = arguments.allProperties;
		
		if (not isNull(propertiesRef_arr))
		{
			for (i = 1; i <= arrayLen(propertiesRef_arr); i++)
			{
				propertyName_str = propertiesRef_arr[i].getName();
	
				// if a property is inherited from one of the parents it is added, otherwise it is ignored
				if (not structKeyExists(allPropertiesRef_struct, propertyName_str))
				{
					property_struct = structNew();
					structInsert(property_struct, "metadata", propertiesRef_arr[i]);
					structInsert(property_struct, "definedBy", componentName_str);
					structInsert(allPropertiesRef_struct, propertyName_str, property_struct);
				}
			}
		}
		
		if (not isNull(extendsRef_str))
		{
			for (i = 1; i <= listLen(extendsRef_str); i++)
			{
				componentName_str = listGetAt(extendsRef_str, i);
				if (structKeyExists(libraryRef_struct, componentName_str))
				{
					_collectProperties(componentName_str, libraryRef_struct, allPropertiesRef_struct);
				}
			}
		}
	}
	
	/**
		Creates an array of structures for properties containing name, metadata, and definedBy 
		keys. The names are property names from the array given in the component metadata 
		object in the library struct and all of its ancestors. The accompanying metadata key 
		points to a CFProperty object containing the nessecary documentation information, 
		and definedBy gives the name of the defining component.
		
		@component Name of the component for which all property information is to be retrieved.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
	*/
	public array function propertyArray(required string component, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var propertyList_str = "";
		var propertyName_str = "";
		var property_struct = "";
		var allProperties_struct = structNew();
		var componentName_str = arguments.component;
		var libraryRef_struct = arguments.library;
		
		_collectProperties(componentName_str, libraryRef_struct, allProperties_struct);
		
		propertyList_str = structKeyList(allProperties_struct);
		propertyList_str = listSort(propertyList_str, "textnocase");
		
		for (i = 1; i <= listLen(propertyList_str); i++)
		{
			propertyName_str = listGetAt(propertyList_str, i);
			property_struct = structCopy(allProperties_struct[propertyName_str]);
			structInsert(property_struct, "name", propertyName_str);
			arrayAppend(return_arr, property_struct);
		}
		return return_arr;
	}
	
	/**
		@private
		Inserts new function metadata objects into the allMethods struct for the methods of 
		component and its ancestors.
	*/
	private void function _collectMethods(required string component, required struct library, required struct allMethods)
	{
		var i = 0;
		var methodName_str = "";
		var method_struct = "";
		var componentName_str = arguments.component;
		var libraryRef_struct = arguments.library;
		var functionsRef_arr = libraryRef_struct[componentName_str].getFunctions();
		var extendsRef_str = libraryRef_struct[componentName_str].getExtends();
		var implementsRef_str = libraryRef_struct[componentName_str].getImplements();
		var allMethodsRef_struct = arguments.allMethods;
		
		if (not isNull(functionsRef_arr))
		{
			for (i = 1; i <= arrayLen(functionsRef_arr); i++)
			{
				methodName_str = functionsRef_arr[i].getName();
	
				// if the method is present in one of the implementors or parents that method is designated as an override
				if (structKeyExists(allMethodsRef_struct, methodName_str))
				{
					allMethodsRef_struct[methodName_str].override = true;
					// if the @inheritDoc tag was used, the reference to the metadata object is replaced
					if (allMethodsRef_struct[methodName_str].metadata.getInheritDoc())
					{
						allMethodsRef_struct[methodName_str].metadata = functionsRef_arr[i];
					}
				}
				// otherwise, a new entry is constructed
				else
				{
					method_struct = structNew();
					structInsert(method_struct, "metadata", functionsRef_arr[i]);
					structInsert(method_struct, "definedBy", componentName_str);
					structInsert(method_struct, "override", false);
					structInsert(allMethodsRef_struct, methodName_str, method_struct);
				}
			}
		}
		
		if (not isNull(extendsRef_str))
		{
			for (i = 1; i <= listLen(extendsRef_str); i++)
			{
				componentName_str = listGetAt(extendsRef_str, i);
				if (structKeyExists(libraryRef_struct, componentName_str))
				{
					_collectMethods(componentName_str, libraryRef_struct, allMethodsRef_struct);
				}
			}
		}

		if (not isNull(implementsRef_str))
		{
			for (i = 1; i <= listLen(implementsRef_str); i++)
			{
				componentName_str = listGetAt(implementsRef_str, i);
				if (structKeyExists(libraryRef_struct, componentName_str))
				{
					_collectMethods(componentName_str, libraryRef_struct, allMethodsRef_struct);
				}
			}
		}
	}
	
	/**
		Creates an array of structures for methods containing name, metadata, definedBy, and 
		override keys. The names are method names from the array given in the component 
		metadata object in the library struct and all of its ancestors. The accompanying 
		metadata key points to a CFFunction object containing the nessecary documentation 
		information, definedBy gives the name of the defining component, and override contains 
		a boolean that indicates whether the method definition is an override of a previous 
		definition.
		
		@component Name of the component for which all method information is to be retrieved.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
	*/
	public array function methodArray(required string component, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var methodList_str = "";
		var methodName_str = "";
		var method_struct = "";
		var allMethods_struct = structNew();
		var componentName_str = arguments.component;
		var libraryRef_struct = arguments.library;
		
		_collectMethods(componentName_str, libraryRef_struct, allMethods_struct);
		
		methodList_str = structKeyList(allMethods_struct);
		methodList_str = listSort(methodList_str, "textnocase");
		
		for (i = 1; i <= listLen(methodList_str); i++)
		{
			methodName_str = listGetAt(methodList_str, i);
			method_struct = structCopy(allMethods_struct[methodName_str]);
			structInsert(method_struct, "name", methodName_str);
			arrayAppend(return_arr, method_struct);
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
		var componentLink_str = "";
		var componentName_str = "";
		var componentPageExists_bool = false;
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
				if (not libraryRef_struct[componentName_str].getPrivate())
				{
					componentPageExists_bool = true;
				}
			}
			if (componentPageExists_bool)
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
					return componentName_str;
				}
			}
		}
	}
}
</cfscript>