/**
	Contains the methods to populate a struct with metadata objects and assign their values.
	
	@author Eelco Eggen
	@date 18 August 2010
*/
component displayname="cfc.MetadataFactory" extends="fly.Object" output="false"
{
	// create an object for resolving any tags in the component, property, or function hints
	variables._hintResolver_obj = createObject("component", "cfc.hintResolver");
	
	/**
		Reads the directory and all subdirectories for .cfc files. Then appends all metadata 
		found for their contents to the library struct in the form of metadata objects and to 
		the packages structs in the form of a struct. In both cases, key strings are component 
		names.
		
		@path Directory to be read.
		@sourcePath Root directory of the library.
		@library Library struct into which this function inserts component metadata objects.
		@packages Structure into which this function inserts package content structs.
	*/
	public void function browseDirectory(required string path, required string sourcePath, required struct library, required struct packages)
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
		var sourcePath_str = arguments.sourcePath;
		var libraryRef_struct = arguments.library;
		var packagesRef_struct = arguments.packages;

		// set the package name
		packageName_str = removeChars(path_str, 1, len(sourcePath_str));
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
		// create an empty struct if there are components in the package
		if (files_qry.recordCount > 0 and !structKeyExists(packagesRef_struct, packageKey_str))
		{
			structInsert(packagesRef_struct, packageKey_str, structNew());
		}
		// for each component
		for (i = 1; i <= files_qry.recordCount; i++)
		{
			// set the component name
			componentName_str = packageName_str;
			if (len(packageName_str) > 0)
			{
				componentName_str &= ".";
			}
			componentName_str &= listGetAt(files_qry.name[i], 1, ".");
			
			// check if the component is to be skipped, this happes when it is declared in the settings.xml file
			if (not listFind(application.excludeComponents, componentName_str))
			{
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
		}
		
		// do the same for all subdirectories
		dirs_qry = directoryList(path_str, false, "query");
		for (i = 1; i <= dirs_qry.recordCount; i++)
		{
			// set the subdirectory path
			directoryPath_str = path_str;
			directoryPath_str &= "/";
			directoryPath_str &= dirs_qry.name[i];
			
			// we exclude folders determined by filter conditions set in settings.xml
			if (dirs_qry.type[i] eq "Dir" and not reFind(application.reExcludeFolders, dirs_qry.name[i]) and not listFind(application.excludePaths, directoryPath_str))
			{
				browseDirectory(directoryPath_str, sourcePath_str, libraryRef_struct, packagesRef_struct);
			}
		}		
	}

	/**
		Determines the data type, creates the appropriate object, and returns it.
		
		@metadata Metadata struct of the component, or interface.
		@library Reference to a struct in which the component objects and inheritance information will be stored.
	*/
	public cfc.cfcData.CFC function createMetadataObject(required struct metadata, required struct library)
	{
		var persistent_bool = false;
		var metadataRef_struct = arguments.metadata;
		var libraryRef_struct = arguments.library;
		var name_str = metadataRef_struct.name;
		var return_obj = "";
		
		// we make sure that the extendedBy and implementedBy queue structs exist
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
			if (structKeyExists(metadataRef_struct, "persistent"))
			{
				persistent_bool = metadataRef_struct.persistent;
			}
			if (persistent_bool)
			{
				return_obj = createObject("component", "cfc.cfcData.CFPersistentComponent").init();
			}
			else
			{
				return_obj = createObject("component", "cfc.cfcData.CFComponent").init();
			}
			
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
				throw(message="Error: unknown CFC type #metadataRef_struct.type#.");
			}
		}
		
		// the "private" property has a default value for both components and interfaces
		return_obj.setPrivate(false);
		// additionally, the "hint" property is set to "" by default in the hint resolver
		
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

		variables._hintResolver_obj.resolveHint(metadataRef_struct, return_obj, metadataRef_struct.path);
		_resolveInheritance(metadataRef_struct, return_obj, libraryRef_struct);
		_resolveProperties(metadataRef_struct, return_obj);
		_resolveFunctions(metadataRef_struct, return_obj);
		if (persistent_bool)
		{
			_resolveORMAttributes(metadataRef_struct, return_obj);
		}
		
		return return_obj;
	}
	
	/**
		@private
		Determines the inheritance of a component and sets the appropriate parameters. 
		If no reference object is made yet for a certain component up in the hierarchy, the 
		information is stored temporarily in the libraryRef_struct["_extendedByQueue"] or 
		libraryRef_struct["_implementedByQueue"] struct.
	*/
	private void function _resolveInheritance(required struct metadata, required any metadataObject, required struct library)
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
		var metadataRef_obj = arguments.metadataObject;

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
				metadataRef_obj.setExtends(extends_str);
			}
	
			// set the inheritance info for ancestors of this component
			// when no metadata object is present for the ancestor, we add its name to the queue
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
			metadataRef_obj.setImplements(implements_str);
	
			// set the inheritance info for interfaces that this component implements
			// when no metadata object is present for the interface, we add its name to the queue
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
		// finally, check for previously existing inheritance information
		// if a component was earlier found to extend or implement this component, 
		// its name is set as an ancestor or implementor, respectively, of this component 
		// and it is removed from the queue
		if (structKeyExists(libraryRef_struct["_extendedByQueue"], name_str))
		{
			metadataRef_obj.setExtendedBy(libraryRef_struct["_extendedByQueue"][name_str]);
			structDelete(libraryRef_struct["_extendedByQueue"], name_str);
		}
		if (structKeyExists(libraryRef_struct["_implementedByQueue"], name_str))
		{
			metadataRef_obj.setImplementedBy(libraryRef_struct["_implementedByQueue"][name_str]);
			structDelete(libraryRef_struct["_implementedByQueue"], name_str);
		}
	}
	
	/**
		@private
		Determines the properties of the component and sets the appropriate parameters.
	*/
	private void function _resolveProperties(required struct metadata, required any metadataObject)
	{
		var persistent_bool = false;
		var propertiesRef_arr = "";
		var propertyObjs_arr = arrayNew(1);
		var property_obj = "";
		var i = 0;
		var metadataRef_struct = arguments.metadata;
		var metadataRef_obj = arguments.metadataObject;

		// determine persistence of the component
		if (structKeyExists(metadataRef_struct, "persistent"))
		{
			persistent_bool = metadataRef_struct.persistent;
		}

		if (structKeyExists(metadataRef_struct, "properties"))
		{
			propertiesRef_arr = metadataRef_struct.properties;
			for (i = 1; i <= arrayLen(propertiesRef_arr); i++)
			{
				property_obj = createPropertyObject(propertiesRef_arr[i], persistent_bool);
				variables._hintResolver_obj.resolveHint(propertiesRef_arr[i], property_obj, metadataRef_struct.path);

				arrayAppend(propertyObjs_arr, property_obj);
			}
			
			metadataRef_obj.setProperties(propertyObjs_arr);
		}
	}

	/**
		Creates and returns a property metadata object from a struct.
		
		@propertyMetadata Metadata struct for a single property, obtained from a component metadata struct.
		@persistent Indicates whether the property is defined by a persistent component.
	*/
	public cfc.cfcData.CFProperty function createPropertyObject(required struct propertyMetadata, boolean persistent=false)
	{
		var return_obj = "";
		var persistent_bool = arguments.persistent; // the default value for property persistence is equal to that of the component
		var propertyRef_struct = arguments.propertyMetadata;

		// check if the property persistence has a value other than the default value
		if (structKeyExists(propertyRef_struct, "persistent"))
		{
			persistent_bool = propertyRef_struct.persistent;
		}
		if (persistent_bool)
		{
			return_obj = createObject("component", "cfc.cfcData.CFMapping").init();
		}
		else
		{
			return_obj = createObject("component", "cfc.cfcData.CFProperty").init();
		}

		// the "type", "serializable", and "private" properties have default values
		return_obj.setType("any");
		return_obj.setSerializable(true);
		return_obj.setPrivate(false);
		// additionally, the "hint" property is set to "" by default in _resolveProperties() by the hint resolver
		
		// name		
		return_obj.setName(propertyRef_struct.name);
		
		// type
		if (structKeyExists(propertyRef_struct, "type"))
		{
			return_obj.setType(propertyRef_struct.type);
		}
		
		// default
		if (structKeyExists(propertyRef_struct, "default"))
		{
			return_obj.setDefault(propertyRef_struct.default);
		}
		
		// serializable		
		if (structKeyExists(propertyRef_struct, "serializable"))
		{
			return_obj.setSerializable(propertyRef_struct.serializable);
		}
		
		// author - possible, but not currently applied in documentation
		if (structKeyExists(propertyRef_struct, "author"))
		{
			return_obj.setAuthor(propertyRef_struct.author);
		}
		
		// date - possible, but not currently applied in documentation
		if (structKeyExists(propertyRef_struct, "date"))
		{
			return_obj.setDate(propertyRef_struct.date);
		}
		
		// private
		if (structKeyExists(propertyRef_struct, "private"))
		{
			return_obj.setPrivate(propertyRef_struct.private);
		}

		// ORM-specific attributes
		if (persistent_bool)
		{
			// the "fieldType" property has a default value
			return_obj.setFieldType("column");

			_resolveORMAttributes(propertyRef_struct, return_obj);

			// the "type" property has a default value "array" instead of "any" for collections, as well as for one-to-many and many-to-many relationships
			if (not structKeyExists(propertyRef_struct, "type") and listValueCountNoCase("collection,one-to-many,many-to-many", return_obj.getFieldType()))
			{
				return_obj.setType("array");
			}
		}
		
		return return_obj;
	}
	
	/**
		@private
		Determines the methods of the component and sets the appropriate parameters.
	*/
	private void function _resolveFunctions(required struct metadata, required any metadataObject)
	{
		var functionsRef_arr = "";
		var functionObjs_arr = arrayNew(1);
		var function_obj = "";
		var i = 0;
		var metadataRef_struct = arguments.metadata;
		var metadataRef_obj = arguments.metadataObject;
		
		if (structKeyExists(metadataRef_struct, "functions"))
		{
			functionsRef_arr = metadataRef_struct.functions;
			for (i = 1; i <= arrayLen(functionsRef_arr); i++)
			{
				function_obj = createFunctionObject(functionsRef_arr[i]);
				variables._hintResolver_obj.resolveHint(functionsRef_arr[i], function_obj, metadataRef_struct.path);

				arrayAppend(functionObjs_arr, function_obj);
			}
			
			metadataRef_obj.setFunctions(functionObjs_arr);
		}
	}
	
	/**
		Creates and returns a function metadata object from a struct.
		
		@functionMetadata Metadata struct for a single function, obtained from a component metadata struct.
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
		// additionally, the "hint" property is set to "" by default in _resolveFunctions() by the hint resolver
		
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
		
		// author - possible, but not currently applied in documentation
		if (structKeyExists(functionRef_struct, "author"))
		{
			return_obj.setAuthor(functionRef_struct.author);
		}
		
		// date - possible, but not currently applied in documentation
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
		Creates and returns an argument metadata object from a struct.
		
		@argumentMetadata Metadata struct for a single argument, obtained from a function metadata struct.
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
		Assigns the values of ORM-specific attributes in the metadata struct to the metadata 
		object. All property names of the metadata object are identical to the corresponding 
		attributes.
	*/
	private void function _resolveORMAttributes(required struct metadata, required struct metadataObject)
	{
		var i = 0;
		var attributeName_str = "";
		var argumentCollection_struct = "";
		var tagUtils_obj = createObject("component", "cfc.TagUtils");
		var metadataRef_struct = arguments.metadata;
		var metadataRef_obj = arguments.metadataObject;
		var ormAttributes_arr = getMetadata(metadataRef_obj).properties;
		
		for (i = 1; i <= arrayLen(ormAttributes_arr); i++)
		{
			attributeName_str = ormAttributes_arr[i].name;
			if (structKeyExists(metadataRef_struct, attributeName_str))
			{
				argumentCollection_struct = structNew();
				structInsert(argumentCollection_struct, attributeName_str, metadataRef_struct[attributeName_str]);
				tagUtils_obj.invokeMethod(metadataRef_obj, "set" & attributeName_str, argumentCollection_struct);
			}
		}
	}
}