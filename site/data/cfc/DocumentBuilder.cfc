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
		Creates an array containing metadata objects. These are alphabetically order by last 
		name of the componenent names. The names of the contributing components are given in 
		the componentList argument and descriptions (references to) the metadata objects are 
		taken from the library structure.
		
		@componentList List of component names.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
		@see cfc.MetadataFactory
			cfc.cfcData.CFC
	*/
	public array function componentArray(required string componentList, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var componentName_str = "";
		var components_str = sortByLastName(arguments.componentList);
		var libraryRef_struct = arguments.library;

		for (i = 1; i <= listLen(components_str); i++)
		{
			componentName_str = listGetAt(components_str, i);
			if (structKeyExists(libraryRef_struct, componentName_str))
			{
				if (isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcData.CFC"))
				{
					if (not libraryRef_struct[componentName_str].getPrivate())
					{
						arrayAppend(return_arr, libraryRef_struct[componentName_str]);
					}
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
			if (not allProperties_struct[propertyName_str].metadata.getPrivate())
			{
				property_struct = structCopy(allProperties_struct[propertyName_str]);
				structInsert(property_struct, "name", propertyName_str);
				arrayAppend(return_arr, property_struct);
			}
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
		var ancestor_str = "";
		var implementsRef_str = "";
		var componentName_str = arguments.component;
		var libraryRef_struct = arguments.library;
		var extendsRef_str = libraryRef_struct[componentName_str].getExtends();
		var functionsRef_arr = libraryRef_struct[componentName_str].getFunctions();
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
				ancestor_str = listGetAt(extendsRef_str, i);
				if (structKeyExists(libraryRef_struct, ancestor_str))
				{
					_collectMethods(ancestor_str, libraryRef_struct, allMethodsRef_struct);
				}
			}
		}

		if (isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcData.CFComponent"))
		{
			implementsRef_str = libraryRef_struct[componentName_str].getImplements();
			if (not isNull(implementsRef_str))
			{
				for (i = 1; i <= listLen(implementsRef_str); i++)
				{
					ancestor_str = listGetAt(implementsRef_str, i);
					if (structKeyExists(libraryRef_struct, ancestor_str))
					{
						_collectMethods(ancestor_str, libraryRef_struct, allMethodsRef_struct);
					}
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
			if (not allMethods_struct[methodName_str].metadata.getPrivate())
			{
				method_struct = structCopy(allMethods_struct[methodName_str]);
				structInsert(method_struct, "name", methodName_str);
				arrayAppend(return_arr, method_struct);
			}
		}
		return return_arr;
	}
	
	/**
		Creates documentation pages for all interfaces and components in a package.
		
		@packageName Name of the package for which to generate documentation.
		@documentRoot Directory path into which all documentation is put. Contains the index.html file.
		@packages Structure that contains lists of interface and component names for all packages. Created by {@link} cfc.MetadataFactory#browseDirectory().
		@library Structure that contains metadata objects for all components in the library.
	*/
	public void function writePackageDocumentation(required string packageName, required string documentRoot, required struct packages, required struct library)
	{
		var i = 0;
		var model = structNew();
		var localVar = structNew();
		var page_str = "";
		var componentName_str = "";
		var packagePath_str = "";
		var packageName_str = arguments.packageName;
		var packageRef_struct = arguments.packages[packageName_str];
		var libraryRef_struct = arguments.library;
		
		// initialize a number of variables in the model scope
		structInsert(model, "interfaces_arr", arrayNew(1));
		structInsert(model, "components_arr", arrayNew(1));
		structInsert(model, "cfMetadata_obj", "");
		structInsert(model, "properties_arr", "");
		structInsert(model, "methods_arr", "");

		structInsert(model, "packageName_str", packageName_str);
		structInsert(model, "libraryRef_struct", libraryRef_struct);
		structInsert(model, "rendering_obj", createObject("component", "cfc.TemplateRendering"));
		model.rendering_obj.setLibrary(libraryRef_struct);

		// determine the correct path to the package documentation directory
		packagePath_str = reReplace(arguments.documentRoot, "[/\\]+", "/", "all");
		if (right(packagePath_str, 1) neq "/")
		{
			packagePath_str &= "/";
		}
		if (packageName_str neq "_topLevel")
		{
			packagePath_str &= replace(packageName_str, ".", "/", "all");
			packagePath_str &= "/";
		}
		// make sure the directory exists
		if (not directoryExists(packagePath_str))
		{
			directoryCreate(packagePath_str);
		}

		// generate interface pages
		if (structKeyExists(packageRef_struct, "interface"))
		{
			model.interfaces_arr = componentArray(packageRef_struct.interface, libraryRef_struct);
			for (i = 1; i <= listLen(packageRef_struct.interface); i++)
			{
				componentName_str = listGetAt(packageRef_struct.interface, i);
				model.cfMetadata_obj = libraryRef_struct[componentName_str];
				if (not model.cfMetadata_obj.getPrivate())
				{
					model.properties_arr = arrayNew(1);
					model.methods_arr = methodArray(componentName_str, libraryRef_struct);
					savecontent variable="page_str"
					{
						include "/templates/componentDetail.cfm";
					}
					fileName_str = packagePath_str;
					fileName_str &= listLast(componentName_str, ".");
					fileName_str &= ".html";
					fileWrite(fileName_str, page_str);
				}
			}
		}
		
		// generate component pages
		if (structKeyExists(packageRef_struct, "component"))
		{
			model.components_arr = componentArray(packageRef_struct.component, libraryRef_struct);
			for (i = 1; i <= listLen(packageRef_struct.component); i++)
			{
				componentName_str = listGetAt(packageRef_struct.component, i);
				model.cfMetadata_obj = libraryRef_struct[componentName_str];
				if (not model.cfMetadata_obj.getPrivate())
				{
					model.properties_arr = propertyArray(componentName_str, libraryRef_struct);
					model.methods_arr = methodArray(componentName_str, libraryRef_struct);
					savecontent variable="page_str"
					{
						include "/templates/componentDetail.cfm";
					}
					fileName_str = packagePath_str;
					fileName_str &= listLast(componentName_str, ".");
					fileName_str &= ".html";
					fileWrite(fileName_str, page_str);
				}
			}
		}
		
		if (model.packageName_str eq "_topLevel")
		{
			model.packageName_str = "";
		}

		// generate component list
		savecontent variable="page_str"
		{
			include "/templates/componentList.cfm";
		}
		fileName_str = packagePath_str;
		fileName_str &= "class-list.html";
		fileWrite(fileName_str, page_str);

		// generate package-detail page
		savecontent variable="page_str"
		{
			include "/templates/packageDetail.cfm";
		}
		fileName_str = packagePath_str;
		fileName_str &= "package-detail.html";
		fileWrite(fileName_str, page_str);
	}

	/**
		@documentRoot Directory path into which all documentation is put. Contains the index.html file.
		@packages Structure that contains lists of interface and component names for all packages. Created by {@link} cfc.MetadataFactory#browseDirectory().
		@library Structure that contains metadata objects for all components in the library.
	*/
	public void function generateDocumentation(required string documentRoot, required struct packages, required struct library)
	{
		var i = 0;
		var model = structNew();
		var localVar = structNew();
		var page_str = "";
		var packageName_str = "";
		var apiDocSource_str = "";
		var documentRoot_str = arguments.documentRoot;
		var packages_struct = arguments.packages;
		var packageList_str = structKeyList(packages_struct);
		var libraryRef_struct = arguments.library;
		
		// initialize a number of variables in the model scope
		structInsert(model, "packages_struct", packages_struct);
		structInsert(model, "libraryRef_struct", libraryRef_struct);
		structInsert(model, "rendering_obj", createObject("component", "cfc.TemplateRendering"));
		model.rendering_obj.setLibrary(libraryRef_struct);
		
		structInsert(model, "components_arr", componentArray(structKeyList(libraryRef_struct), libraryRef_struct));

		// set the correct source directory for the basic files
		apiDocSource_str = reReplace(getBaseTemplatePath(), "[/\\]+", "/", "all");
		apiDocSource_str = listDeleteAt(apiDocSource_str, listLen(apiDocSource_str, "/"), "/");
		apiDocSource_str &= "/apiDoc/";
		
		// check that the document root has the correct format
		documentRoot_str = reReplace(documentRoot_str, "[/\\]+", "/", "all");
		if (right(documentRoot_str, 1) neq "/")
		{
			documentRoot_str &= "/";
		}
		
		// copy basic files
		_copyBasicFiles(apiDocSource_str, documentRoot_str);
		
		// write all package documentation
		for (i = 1; i <= listLen(packageList_str); i++)
		{
			packageName_str = listGetAt(packageList_str, i);
			writePackageDocumentation(packageName_str, documentRoot_str, packages_struct, libraryRef_struct);
		}

		// write lists and summaries for all classes and packages
		savecontent variable="page_str"
		{
			include "/templates/componentListAll.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "all-classes.html";
		fileWrite(fileName_str, page_str);

		savecontent variable="page_str"
		{
			include "/templates/componentSummary.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "class-summary.html";
		fileWrite(fileName_str, page_str);

		savecontent variable="page_str"
		{
			include "/templates/packageList.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "package-list.html";
		fileWrite(fileName_str, page_str);

		savecontent variable="page_str"
		{
			include "/templates/packageSummary.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "package-summary.html";
		fileWrite(fileName_str, page_str);
	}
	
	/**
		Copies all files in the source folder to a destination folder.
	*/
	private void function _copyBasicFiles(required sourcePath, required destinationPath)
	{
		var i = 0;
		var dirList_qry = "";
		var newSource_str = "";
		var newDestination_str = "";
		var source_str = arguments.sourcePath;
		var destination_str = arguments.destinationPath;
	
		if (not directoryExists(destination_str))
		{
			directoryCreate(destination_str);
		}

		dirList_qry = directoryList(source_str, false, "query");
		for (i = 1; i <= dirList_qry.recordCount; i++)
		{
			if (left(dirList_qry.name[i], 1) neq ".")
			{
				if (dirList_qry.type[i] eq "Dir")
				{
					newSource_str = source_str;
					newSource_str &= dirList_qry.name[i];
					newSource_str &= "/";
					newDestination_str = destination_str;
					newDestination_str &= dirList_qry.name[i];
					newDestination_str &= "/";
					
					_copyBasicFiles(newSource_str, newDestination_str);
				}
				else
				{
					newSource_str = source_str;
					newSource_str &= dirList_qry.name[i];
					FileCopy(newSource_str, destination_str);
				}
			}
		}
	}
}
</cfscript>