/**
	Contains the methods to create documentation pages from a struct of metadata objects.
	
	@author Eelco Eggen
	@date 2 September 2010
	
	@see cfc.MetadataFactory
*/
component displayname="cfc.DocumentBuilder" extends="fly.Object" output="false"
{
	/**
		Creates documentation pages for all packages in the library.
		
		@documentRoot Directory path into which all documentation is put. Contains the index.html file.
		@packages Structure that contains lists of interface and component names for all packages. Created by {@link} cfc.MetadataFactory#browseDirectory().
		@library Structure that contains metadata objects for all components in the library.
	*/
	public void function generateDocumentation(required string documentRoot, required struct packages, required struct library)
	{
		trace(text="generateDocumentation start");		
		var i = 0;
		var model = structNew();
		var localVar = structNew();
		var page_str = "";
		var packageKey_str = "";
		var apiDocSource_str = "";
		var documentRoot_str = arguments.documentRoot;
		var packages_struct = arguments.packages;
		var libraryRef_struct = arguments.library;
		trace(text="arguments");		
		var packages_arr = structKeyArray(packages_struct);
		trace(text=" package key array");		
		
		// initialize a number of variables in the model scope
		structInsert(model, "components", componentArray(structKeyArray(libraryRef_struct), libraryRef_struct));
		structInsert(model, "packages", packages_struct);
		structInsert(model, "libraryRef", libraryRef_struct);
		trace(text="model");		

		// set the correct source directory for the basic files
		apiDocSource_str = reReplace(getBaseTemplatePath(), "[/\\]+", "/", "all");
		apiDocSource_str = listDeleteAt(apiDocSource_str, listLen(apiDocSource_str, "/"), "/");
		apiDocSource_str &= "/apiDoc/";
		trace(text=" apiSourceDoc");		
		
		// check that the path to the document root has the correct format
		documentRoot_str = reReplace(documentRoot_str, "[/\\]+", "/", "all");
		if (right(documentRoot_str, 1) neq "/")
		{
			documentRoot_str &= "/";
		}
		trace(text=" documentRoot");		
		
		// write all package documentation
		for (i = 1; i <= arrayLen(packages_arr); i++)
		{
			packageKey_str = packages_arr[i];
			writePackageDocumentation(packageKey_str, documentRoot_str, packages_struct, libraryRef_struct);
		}
		trace(text=" packageDocumentation");		

		// copy basic files
		_copyBasicFiles(apiDocSource_str, documentRoot_str);
		trace(text=" copyBasicFiles");		
		
		// write lists and summaries for all classes and packages
		savecontent variable="page_str"
		{
			include "/templates/componentListAll.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "all-classes.html";
		fileWrite(fileName_str, page_str);
		trace(text=" componentList");		

		savecontent variable="page_str"
		{
			include "/templates/componentSummary.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "class-summary.html";
		fileWrite(fileName_str, page_str);
		trace(text=" componentSummary");		

		savecontent variable="page_str"
		{
			include "/templates/packageList.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "package-list.html";
		fileWrite(fileName_str, page_str);
		trace(text=" packageList");		

		savecontent variable="page_str"
		{
			include "/templates/packageSummary.cfm";
		}
		fileName_str = documentRoot_str;
		fileName_str &= "package-summary.html";
		fileWrite(fileName_str, page_str);
		trace(text=" packageSummary");		
		
		trace(text="generateDocumentation end");
	}
	
	/**
		Creates documentation pages for all interfaces and components in a package.
		
		@packageKey Name of the package (key) for which to generate documentation.
		@documentRoot Directory path into which all documentation is put. Contains the index.html file.
		@packages Structure that contains lists of interface and component names for all packages. Created by {@link} cfc.MetadataFactory#browseDirectory().
		@library Structure that contains metadata objects for all components in the library.
	*/
	public void function writePackageDocumentation(required string packageKey, required string documentRoot, required struct packages, required struct library)
	{
		var i = 0;
		var model = structNew();
		var localVar = structNew();
		var page_str = "";
		var componentName_str = "";
		var packagePath_str = "";
		var packageKey_str = arguments.packageKey;
		var packageRef_struct = arguments.packages[packageKey_str];
		var libraryRef_struct = arguments.library;
		
		// initialize a number of variables in the model scope, which is used in the templates
		structInsert(model, "interfaces", arrayNew(1));
		structInsert(model, "components", arrayNew(1));
		structInsert(model, "cfMetadata", "");
		structInsert(model, "properties", "");
		structInsert(model, "methods", "");
		structInsert(model, "packageKey", packageKey_str);
		structInsert(model, "libraryRef", libraryRef_struct);

		// set the correct path to the package documentation directory
		packagePath_str = reReplace(arguments.documentRoot, "[/\\]+", "/", "all");
		if (right(packagePath_str, 1) neq "/")
		{
			packagePath_str &= "/";
		}
		// check if the package is Top Level
		if (packageKey_str neq "_topLevel")
		{
			packagePath_str &= replace(packageKey_str, ".", "/", "all");
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
			model.interfaces = componentArray(packageRef_struct.interface, libraryRef_struct);
			for (i = 1; i <= arrayLen(packageRef_struct.interface); i++)
			{
				componentName_str = packageRef_struct.interface[i];
				model.cfMetadata = libraryRef_struct[componentName_str];
				if (not model.cfMetadata.getPrivate())
				{
					model.properties = arrayNew(1);
					model.methods = methodArray(componentName_str, libraryRef_struct);
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
			model.components = componentArray(packageRef_struct.component, libraryRef_struct);
			for (i = 1; i <= arrayLen(packageRef_struct.component); i++)
			{
				componentName_str = packageRef_struct.component[i];
				model.cfMetadata = libraryRef_struct[componentName_str];
				if (not model.cfMetadata.getPrivate())
				{
					model.properties = propertyArray(componentName_str, libraryRef_struct);
					model.methods = methodArray(componentName_str, libraryRef_struct);
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

	/**
		Creates an array containing metadata objects. These are alphabetically order by last 
		name of the componenent names. The names of the contributing components are given in 
		the componentList argument and the (references to) the metadata objects are taken from 
		the library structure.
		
		@componentList List of component names.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
		@see cfc.MetadataFactory
			cfc.cfcData.CFC
	*/
	public array function componentArray(required array componentArray, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var componentName_str = "";
		var components_arr = sortByLastName(arguments.componentArray);
		var libraryRef_struct = arguments.library;
		var component_obj = javacast("null", 0);

		for (i = 1; i <= arrayLen(components_arr); i++)
		{
			componentName_str = components_arr[i];
			if (structKeyExists(libraryRef_struct, componentName_str))
			{
				component_obj = libraryRef_struct[componentName_str];
				if (isInstanceOf(component_obj, "cfc.cfcData.CFC") and not component_obj.getPrivate())
				{
					arrayAppend(return_arr, component_obj);
				}
			}
		}
		return return_arr;
	}
	
	/**
		Sorts a list of components by the name behind the last dot of the full component name.
		
		@componentList List of component names.
		@return Alphabetized list of component names.
	*/
	public array function sortByLastName(required array componentArray)
	{
		var i = 0;
		var j = 0;
		var componentName_str = "";
		var reverseName_str = "";
		var word_str = "";
		var components_arr = arguments.componentArray;
		var componentNames_struct = {};

		// loop through all component names
		for (i = 1; i <= arrayLen(components_arr); i++)
		{
			componentName_str = components_arr[i];
			
			// reverse the order of expressions separated by the dots
			reverseName_str = "";
			for (j = 1; j <= listLen(componentName_str, "."); j++)
			{
				word_str = listGetAt(componentName_str, j, ".");
				reverseName_str = listPrepend(reverseName_str, word_str, ".");
			}
			componentNames_struct[reverseName_str] = componentName_str;
			components_arr[i] = reverseName_str;
		}

		// sort alphabetically
		arraySort(components_arr, "textnocase");

		// revert the names to their original form
		for (i = 1; i <= arrayLen(components_arr); i++)
		{
			reverseName_str = components_arr[i];
			components_arr[i] = componentNames_struct[reverseName_str];
		}
		
		return components_arr;
	}
	
	/**
		Creates an array of structures for properties containing name, metadata, and definedBy 
		keys. The names are property names from the array given in the component metadata 
		object in the library struct and all of its ancestors. The accompanying metadata key 
		points to a {@link} cfc.cfcData.CFProperty object containing the nessecary 
		documentation information, definedBy gives the name of the defining component, and 
		override contains a boolean that indicates whether the property definition is an 
		override of a previous definition.
		
		@component Name of the component for which all property information is to be retrieved.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
	*/
	public array function propertyArray(required string componentName, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var propertyList_str = "";
		var propertyName_str = "";
		var property_struct = "";
		var allProperties_struct = structNew();
		var componentName_str = arguments.componentName;
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
		Inserts property metadata objects into the allProperties struct for the properties of 
		the component and its ancestors.
	*/
	private void function _collectProperties(required string componentName, required struct library, required struct allProperties)
	{
		var i = 0;
		var propertyName_str = "";
		var property_struct = "";
		var componentName_str = arguments.componentName;
		var libraryRef_struct = arguments.library;
		var propertiesRef_arr = libraryRef_struct[componentName_str].getProperties();
		var extendsRef_arr = libraryRef_struct[componentName_str].getExtends();
		var allPropertiesRef_struct = arguments.allProperties;
		
		if (not isNull(propertiesRef_arr))
		{
			for (i = 1; i <= arrayLen(propertiesRef_arr); i++)
			{
				propertyName_str = propertiesRef_arr[i].getName();
	
				// if the property is already defined in a subclass or implementor, that property definition is designated as an override
				if (structKeyExists(allPropertiesRef_struct, propertyName_str))
				{
					allPropertiesRef_struct[propertyName_str].override = true;
				}
				// otherwise, a new entry is created
				else
				{
					property_struct = structNew();
					structInsert(property_struct, "metadata", propertiesRef_arr[i]);
					structInsert(property_struct, "definedBy", componentName_str);
					structInsert(property_struct, "override", false);
					structInsert(allPropertiesRef_struct, propertyName_str, property_struct);
				}
			}
		}

		// collect the properties of all ancestors
		if (not isNull(extendsRef_arr))
		{
			for (i = 1; i <= arrayLen(extendsRef_arr); i++)
			{
				componentName_str = extendsRef_arr[i];
				if (structKeyExists(libraryRef_struct, componentName_str))
				{
					_collectProperties(componentName_str, libraryRef_struct, allPropertiesRef_struct);
				}
			}
		}
	}
	
	/**
		Creates an array of structures for methods containing name, metadata, definedBy, and 
		override keys. The names are method names from the array given in the component 
		metadata object in the library struct and all of its ancestors. The accompanying 
		metadata key points to a {@link} cfc.cfcData.CFFunction object containing the 
		nessecary documentation information, definedBy gives the name of the defining 
		component, and override contains a boolean that indicates whether the method 
		definition is an override of a previous definition.
		
		@component Name of the component for which all method information is to be retrieved.
		@library Struct containing key-value pairs of component names and their corresponding metadata objects.
	*/
	public array function methodArray(required string componentName, required struct library)
	{
		var return_arr = arrayNew(1);
		var i = 0;
		var methodName_str = "";
		var method_struct = "";
		var allMethods_struct = structNew();
		var componentName_str = arguments.componentName;
		var libraryRef_struct = arguments.library;
		
		_collectMethods(componentName_str, libraryRef_struct, allMethods_struct);
		
		var methodList_arr = structKeyArray(allMethods_struct);
		arraySort(methodList_arr, "textnocase");
		
		for (i = 1; i <= arrayLen(methodList_arr); i++)
		{
			methodName_str = methodList_arr[i];
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
		@private
		Inserts function metadata objects into the allMethods struct for the methods of the 
		component and its ancestors.
	*/
	private void function _collectMethods(required string componentName, required struct library, required struct allMethods)
	{
		var i = 0;
		var methodName_str = "";
		var method_struct = "";
		var ancestor_str = "";
		var implementsRef_arr = [];
		var componentName_str = arguments.componentName;
		var libraryRef_struct = arguments.library;
		var extendsRef_arr = libraryRef_struct[componentName_str].getExtends();
		var functionsRef_arr = libraryRef_struct[componentName_str].getFunctions();
		var allMethodsRef_struct = arguments.allMethods;
		
		if (not isNull(functionsRef_arr))
		{
			for (i = 1; i <= arrayLen(functionsRef_arr); i++)
			{
				methodName_str = functionsRef_arr[i].getName();
	
				// if the method is already defined in a subclass or implementor, that method definition is designated as an override
				if (structKeyExists(allMethodsRef_struct, methodName_str))
				{
					allMethodsRef_struct[methodName_str].override = true;
					// if the @inheritDoc tag was used, the reference to the documentation information is replaced
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
		
		// collect the methods of all ancestors
		if (not isNull(extendsRef_arr))
		{
			for (i = 1; i <= arrayLen(extendsRef_arr); i++)
			{
				ancestor_str = extendsRef_arr[i];
				if (structKeyExists(libraryRef_struct, ancestor_str))
				{
					_collectMethods(ancestor_str, libraryRef_struct, allMethodsRef_struct);
				}
			}
		}

		if (isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcData.CFComponent"))
		{
			// collect the methods of all interfaces this component implements and their ancestors
			implementsRef_arr = libraryRef_struct[componentName_str].getImplements();
			if (not isNull(implementsRef_arr))
			{
				for (i = 1; i <= arrayLen(implementsRef_arr); i++)
				{
					ancestor_str = implementsRef_arr[i];
					if (structKeyExists(libraryRef_struct, ancestor_str))
					{
						_collectMethods(ancestor_str, libraryRef_struct, allMethodsRef_struct);
					}
				}
			}
		}
	}
}