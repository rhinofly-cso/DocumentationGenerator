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
	public cfc.cfcMetadata.CFArgument function createArgumentObject(required struct argumentMetadata)
	{
		var return_obj = createObject("component", "cfc.cfcMetadata.CFArgument").init();
		var argumentRef_struct = arguments.argumentMetadata;

		// the "required" property has a default value
		return_obj.setRequired(false);
		
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
		var parametersRef_arr = "";
		var i = 0;
		var argument_obj = "";
		var argumentObjs_arr = arrayNew(1);
		var functionRef_struct = arguments.functionMetadata;
		var functionRef_obj = arguments.functionObject;
		
		if (structKeyExists(functionRef_struct, "parameters"))
		{
			parametersRef_arr = functionRef_struct.parameters;
			for (i = 1; i <= arrayLen(parametersRef_arr); i++)
			{
				argument_obj = createArgumentObject(parametersRef_arr[i]);
				arrayAppend(argumentObjs_arr, argument_obj);
			}
			
			functionRef_obj.setParameters(argumentObjs_arr);
		}		
	}

	/**
		Creates and returns a function metadata object from a struct.
		
		@functionMetadata Metadata struct for a single function from getMetadata.
	*/
	public cfc.cfcMetadata.CFFunction function createFunctionObject(required struct functionMetadata)
	{
		var return_obj = createObject("component", "cfc.cfcMetadata.CFFunction").init();
		var functionRef_struct = arguments.functionMetadata;
		
		// the "access", "inheritDoc", and "private" properties have default values
		return_obj.setAccess("public");
		return_obj.setInheritDoc(false);
		return_obj.setPrivate(false);
		
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
		
		return return_obj;
	}
	
	/**
		@private
		Determines whether the hint contained @throws and/or @see tags that were removed by
		the parsing of CFScript code. If so, these are retrieved from the .cfc file and
		processed. Alternatively, for tag-based CF code, the tags in the hint are all parsed.
	*/
	private void function _resolveHint(required struct metadata, required any returnObject)
	{
		var type_str = "";
		var search_str = "";
		var component_str = "";
		var reverse_str = "";
		var endFromLast_num = 0;
		var beginFromLast_num = 0;
		var i = 0;
		var token_str = "";
		var exception_struct = "";
		var throwsTagFollow_bool = false;
		var seeTagFollow_bool = false;
		var tag_str = "";
		var hintTag_bool = false;
		var parsedHint_str = "";
		var metadataRef_struct = arguments.metadata;
		var returnRef_obj = arguments.returnObject;
		var hint_str = returnRef_obj.getHint();
		
		if (isInstanceOf(returnRef_obj, "cfc.CFProperty"))
		{
			type_str = "property";
		}
		else
		{
			if (isInstanceOf(returnRef_obj, "cfc.CFFunction"))
			{
				type_str = "function";
			}
			else
			{
				if (isInstanceOf(returnRef_obj, "cfc.CFComponent"))
				{
					type_str = "component";
				}
				else
				{
					if (isInstanceOf(returnRef_obj, "cfc.CFInterface"))
					{
						type_str = "interface";
					}
					else
					{
						throw(message="Could not process hint for type #getMetadata(cfcMetadata_obj).name#.");
					}
				}
			}
		}

		if (structKeyExists(metadataRef_struct, "throws") or structKeyExists(metadataRef_struct, "see"))
		{
			// we have a hint to parse from CFScript code, which must be isolated
			search_str = type_str;
			if (type_str = "property")
			{
				search_str &= "[^\n\r]*";
				search_str &= returnRef_obj.getName();
				search_str &= "\b";
			}
			else
			{
				if (type_str = "function")
				{
					search_str &= "[\n\r]*";
					search_str &= returnRef_obj.getName();
					search_str &= "[\s]*\(";
				}
				else
				{
					search_str &= "[^\n\r]*[\s]*\{";
				}
			}
			
			component_str = FileRead(metadataRef_struct.path);
			component_str = left(component_str, reFind(search_str, component_str));
			reverse_str = reverse(component_str);
			endFromLast_num = find("/*", reverse_str);
			
			if (endFromLast_num > 0 and endFromLast_num lt find("{", reverse_str))
			{
				beginFromLast_num = find("**/", reverse_str);
				component_str = right(component_str, beginFromLast_num - 1);
				component_str = left(component_str, beginFromLast_num - endFromLast_num - 2);

				// parsing the hint one line after another
				i = 1;
				while (true)
				{
					token_str = getToken(component_str, i, chr(10));
					// getToken only returns an empty string if index i is larger than the number of tokens
					if (len(token_str) > 0)
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
							if (left(token_str, 1) eq "@")
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
							if (left(token_str, 1) eq "@")
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
							if (type_str = "function")
							{
								if (find("@throws", token_str) eq 1)
								{
									token_str = trim(removechars(token_str, 1, 7));
									exception_struct = structNew();
									exception_struct.type = getToken(token_str, 1);
									exception_struct.description = trim(removechars(token_str, 1, len(exception_struct.type)));
									returnRef_obj.addThrows(exception_struct);
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
					else
					{
						break;
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
				if (len(token_str) > 0)
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
						if (type_str = "function")
						{
							if (tag_str eq "@return")
							{
								returnRef_obj.setReturnHint(trim(removechars(token_str, 1, 7)));
							}
							if (find("@throws", token_str) eq 1)
							{
								token_str = trim(removechars(token_str, 1, 7));
								exception_struct = structNew();
								exception_struct.type = getToken(token_str, 1);
								exception_struct.description = trim(removechars(token_str, 1, len(exception_struct.type)));
								returnRef_obj.addThrows(exception_struct);
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
				else
				{
					break;
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
		var hint_str = "";
		var metadataRef_struct = arguments.metadata;
		var returnRef_obj = arguments.returnObject;
		
		if (structKeyExists(metadataRef_struct, "functions"))
		{
			functionsRef_arr = metadataRef_struct.functions;
			for (i = 1; i <= arrayLen(functionsRef_arr); i++)
			{
				function_obj = createFunctionObject(functionsRef_arr[i]);

				hint_str = "";
				if (structKeyExists(functionsRef_arr[i], "hint"))
				{
					hint_str &= functionsRef_arr[i].hint;
				}
				if (structKeyExists(functionsRef_arr[i], "description"))
				{
					hint_str &= functionsRef_arr[i].description;
				}
				function_obj.setHint(hint_str);
				_resolveHint(metadataRef_struct, function_obj);

				arrayAppend(functionObjs_arr, function_obj);
			}
			
			returnRef_obj.setFunctions(functionObjs_arr);
		}
	}
	
	/**
		Creates and returns a property metadata object from a struct.
		
		@functionMetadata Metadata struct for a single property from getMetadata.
	*/
	public cfc.cfcMetadata.CFProperty function createPropertyObject(required struct propertyMetadata)
	{
		var return_obj = createObject("component", "cfc.cfcMetadata.CFProperty").init();
		var propertyRef_struct = arguments.propertyMetadata;
		
		// the "serializable", and "private" properties have default values
		return_obj.setSerializable(true);
		return_obj.setPrivate(false);
		
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

				if (structKeyExists(propertiesRef_arr[i], "hint"))
				{
					property_obj.setHint(propertiesRef_arr[i].hint);
				}
				else
				{
					property_obj.setHint("");
				}
				_resolveHint(metadataRef_struct, property_obj);

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
			returnRef_obj.setExtends(extends_str);
	
			// set the inheritance info for components extended by the current one
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
	
			// set the inheritance info for components extended by the current one
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
		//and finally check for previously existing inheritance information
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
	public cfc.CFCMetadata function createMetadataObject(required struct metadata, required struct library)
	{
		var metadataRef_struct = arguments.metadata;
		var libraryRef_struct = arguments.library;
		var name_str = metadataRef_struct.name;
		var return_obj = "";
		
		// we make sure that the extendedBy queue and implementedBy queue structs exist
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
			return_obj = createObject("component", "cfc.cfcMetadata.CFComponent").init();
			
			// the "serializable" property has a default value for components
			return_obj.setSerializable(true);
		}
		else
		{
			if (metadataRef_struct.type eq "interface")
			{
				return_obj = createObject("component", "cfc.cfcMetadata.CFInterface").init();
			}
			else
			{
				throw (message="Error: unknown CFC type #metadataRef_struct.type#.")
			}
		}
		
		// the "private" property has a default value
		return_obj.setPrivate(false);
		
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

		// initial version of the hint
		if (structKeyExists(metadataRef_struct, "hint"))
		{
			return_obj.setHint(metadataRef_struct.hint);
		}
		else
		{
			return_obj.setHint("");
		}

		_resolveHint(metadataRef_struct, return_obj);
		_resolveInheritance(metadataRef_struct, libraryRef_struct, return_obj);
		_resolveProperties(metadataRef_struct, return_obj);
		_resolveFunctions(metadataRef_struct, return_obj);
		
		return return_obj;
	}
	
	public void function browseDirectory(required string path, required string customTagPath, required struct library, required struct packages)
	{
		var i = 0;
		var files_qry = "";
		var dirs_qry = "";
		var componentPath_str = "";
		var directoryPath_str = "";
		var packageName_str = "";
		var content_str = "";
		var metadata_struct = "";
		var metadata_obj = "";
		var path_str = arguments.path;
		var customTagPath_str = arguments.customTagPath;
		var libraryRef_struct = arguments.library;
		var packagesRef_struct = arguments.packages;
		
		directoryPath_str = path_str;
		directoryPath_str = removeChars(path_str, 1, len(customTagPath_str));
		directoryPath_str = reReplace(directoryPath_str, "[/\\]+", ".", "all");
		if (left(directoryPath_str, 1) eq ".")
		{
			directoryPath_str = removeChars(directoryPath_str, 1, 1);
		}
		if (len(directoryPath_str) > 0)
		{
			if (right(directoryPath_str, 1) eq ".")
			{
				packageName_str = removeChars(directoryPath_str, len(directoryPath_str), 1);
			}
			else
			{
				packageName_str = directoryPath_str;
				directoryPath_str &= ".";
			}
		}
		else
		{
			packageName_str = "_topLevel";
		}

		files_qry = directoryList(path_str, false, "query", "*.cfc");
		if (files_qry.recordCount > 0)
		{
			structInsert(packagesRef_struct, packageName_str, structNew());
		}
		for (i = 1; i <= files_qry.recordCount; i++)
		{
			componentPath_str = directoryPath_str;
			componentPath_str &= listGetAt(files_qry.name[i], 1, ".");
			
			try
			{
				metadata_struct = getComponentMetadata(componentPath_str);
			}
			catch (any excptn)
			{
				throw(message="Could not obtain component metadata for #componentPath_str#.");
			}
			metadata_obj = createMetadataObject(metadata_struct, libraryRef_struct);
			structInsert(libraryRef_struct, metadata_struct.name, metadata_obj);

			content_str = metadata_struct.name;
			if (structKeyExists(packagesRef_struct[packageName_str], metadata_struct.type))
			{
				content_str = listAppend(packagesRef_struct[packageName_str][metadata_struct.type], content_str);
				packagesRef_struct[packageName_str][metadata_struct.type] = content_str;
			}
			else
			{
				structInsert(packagesRef_struct[packageName_str], metadata_struct.type, content_str);
			}
		}
		
		dirs_qry = directoryList(path_str, false, "query");
		for (i = 1; i <= dirs_qry.recordCount; i++)
		{
			if (dirs_qry.type[i] eq "Dir")
			{
				// we use directoryPath_str for an actual path again
				directoryPath_str = path_str;
				// the forward slash is always supposed to work
				directoryPath_str &= "/";
				directoryPath_str &= dirs_qry.name[i];
				browseDirectory(directoryPath_str, customTagPath_str, libraryRef_struct, packagesRef_struct);
			}
		}		
	}
}