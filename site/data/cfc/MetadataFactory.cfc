<cfscript>
/**
	Contains the methods to create metadata objects and assign its values.
	
	@author Eelco Eggen
	@date 18 August 2010
*/
component displayname="cfc.MetadataFactory" extends="fly.Object" accessors="true" output="false"
{
	/**
		@private
		Determines the inheritance of a component and sets the appropriate parameters. 
		If no reference object is made yet for a certain component up in the hierarchy, the 
		information is stored temporarily in the libraryRef_struct["_hierarchy"] struct.
	*/
	private void function _resolveInheritance(required struct metadata, required struct library, required any returnObject)
	{
		var extends_str = "";
		var extendedComponent_str = "";
		var extendedBy_str = "";
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
					extendedBy_str = libraryRef_struct[extendedComponent_str].getExtendedBy();
					if (isNull(extendedBy_str))
					{
						libraryRef_struct[extendedComponent_str].setExtendedBy(name_str);
					}
					else
					{
						extendedBy_str &= ",";
						extendedBy_str &= name_str;
						libraryRef_struct[extendedComponent_str].setExtendedBy(extendedBy_str);
					}
				}
				else
				{
					if (structKeyExists(libraryRef_struct["_hierarchy"], extendedComponent_str))
					{
						libraryRef_struct["_hierarchy"][extendedComponent_str] &= ",";
						libraryRef_struct["_hierarchy"][extendedComponent_str] &= name_str;
					}
					else
					{
						structInsert(libraryRef_struct["_hierarchy"], extendedComponent_str, name_str);
					}
				}
			}
		}			
		//and finally check for previously existing inheritance information
		if (structKeyExists(libraryRef_struct["_hierarchy"], name_str))
		{
			returnRef_obj.setExtendedBy(libraryRef_struct["_hierarchy"][name_str]);
			structDelete(libraryRef_struct["_hierarchy"], name_str);
		}
	}

	/**
		Creates and returns a function metadata object from a struct.
		
		@metadata Metadata struct for a single function from getMetadata.
	*/
	public cfc.cfcMetadata.CFFunction function createFunctionObject(required struct metadata)
	{
		var return_obj = createObject("component", "cfc.cfcMetadata.CFFunction").init();
		var metadataRef_struct = arguments.metadata;
		
		// name		
		return_obj.setName(metadataRef_struct.name);
		
		// access		
		if (structKeyExists(metadataRef_struct, "access"))
		{
			return_obj.setAccess(metadataRef_struct.access);
		}
		else
		{
			return_obj.setAccess("public");
		}
		
		// returnType
		if (structKeyExists(metadataRef_struct, "returnType"))
		{
			return_obj.setReturnType(metadataRef_struct.returnType);
		}
		
		// returnHint		
		if (structKeyExists(metadataRef_struct, "return"))
		{
			return_obj.setReturnHint(metadataRef_struct.return);
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
		else
		{
			return_obj.setPrivate(false);
		}
		
		// TODO: parameters
		if (structKeyExists(metadataRef_struct, ""))
		{
			return_obj.set();
		}
	}
	
	/**
		@private
		Determines the interface or component where the documentation for the @inheritDoc can 
		be found. If an interface or component in the hierchy is missing, the assignment is 
		postponed.
	*/
	private void function _resolveInheritDoc(required struct metadata, required any functionObject)
	{
	}
	
	/**
		@private
		Determines whether the hint contained @throws and/or @see tags that were removed by
		the parsing of CFScript code. If so, these are retrieved from the .cfc file and
		processed. Alternatively, for tag-based CF code, the tags in the hint are all parsed.
	*/
		private void function _resolveHint(required string hint, required struct metadata, required any functionObject)
		{
			var search_str = "";
			var component_str = "";
			var reverse_str = "";
			var endFromLast_num = 0;
			var beginFromLast_num = 0;
			var i = 0;
			var token_str = "";
			var throws_str = "";
			var related_str = "";
			var hint_str = arguments.hint;
			var metadataRef_struct = arguments.metadata;
			var functionRef_obj = arguments.functionObject;
			
			if (structKeyExists(metadataRef_struct, "throws") or structKeyExists(metadataRef_struct, "see"))
			{
				// we have a hint to parse from CFScript code
				search_str = "function ";
				search_str &= functionRef_obj.getName();
				search_str &= "(";
				component_str = FileRead(metadataRef_struct.path);

				component_str = left(component_str, find(search_str, component_str));
				reverse_str = reverse(component_str);
				endFromLast_num = find("/*", reverse_str);
				
				if (endFromLast_num gt 0 and endFromLast_num lt find("{", reverse_str))
				{
					beginFromLast_num = find("**/", reverse_str);
					component_str = right(component_str, beginFromLast_num - 1);
					component_str = left(component_str, beginFromLast_num - endFromLast_num - 2);

					i = 1;
					
					while (true)
					{
						token_str = getToken(hint_str, i, chr(10));
						if (len(token_str))
						{
							token_str = trim(token_str);
							if (left(token_str, 1) eq "*")
							{
								token_str = trim(removeChars(token_str, 1, 1));
							}
							i += 1;
							
							// parse token_str
							if (find("@throws", token_str) eq 1)
							{
								listAppend(throws_str, trim(removechars(token_str, 1, 7));
							}
							else
							{
								if (find("@see", token_str) eq 1)
								{
									listAppend(related_str, trim(removechars(token_str, 1, 4));
								}
							}
						}
						else
						{
							break;
						}
					}
				}
				
				if (len(throws_str) > 0)
				{
					functionRef_obj.setThrows(throws_str);
				}
				if (len(related_str) > 0)
				{
					functionRef_obj.setThrows(related_str);
				}
			}
			
			//tag-based hint parsing
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
				if (structKeyExists(metadataRef_struct, "inheritDoc"))
				{
					function_obj = createObject("component", "cfc.cfcMetadata.CFFunction");
					_resolveInheritDoc(metadataRef_struct, function_obj);
					arrayAppend(functionObjs_arr, function_obj);
				}
				else
				{
					function_obj = createFunctionObject(functionsRef_arr[i]);

					hint_str = "";
					if (structKeyExists(metadataRef_struct, "hint"))
					{
						hint_str &= metadataRef_struct.hint;
					}
					if (structKeyExists(metadataRef_struct, "description"))
					{
						hint_str &= metadataRef_struct.description;
					}
					_resolveHint(hint_str, metadataRef_struct, function_obj);

					arrayAppend(functionObjs_arr, function_obj);
				}
			}
			
			returnRef_obj.setFunctions(functionObjs_arr);
		}
	}

	/**
		Determines the data type, creates the appropriate object, and returns it.
		
		@metadata Metadata struct of the component, interface, property, function, or argument.
		@library Reference to a struct in which the component inheritance will be stored.
	*/
	public cfc.CFCMetadata function createMetadataObject(required struct metadata, required struct library)
	{
		var metadataRef_struct = arguments.metadata;
		var libraryRef_struct = arguments.library;
		var name_str = metadataRef_struct.name;
		var return_obj = "";
		
		// we make sure that the libraryRef_struct["_hierarchy"] struct exists
		if (!structKeyExists(libraryRef_struct, "_hierarchy"))
		{
			structInsert(libraryRef_struct, "_hierarchy", structNew());
		}
		
		// determine the type and create the appropriate object
		if (metadataRef_struct.type == "component")
		{
			return_obj = createObject("component", "cfc.cfcMetadata.CFComponent").init();
		}
		else
		{
			if (metadataRef_struct.type == "interface")
			{
				return_obj = createObject("component", "cfc.cfcMetadata.CFInterface").init();
			}
			else
			{
				throw (message="Error: unknown CFC type #metadataRef_struct.type#.")
			}
		}
		
		return_obj.setName(name_str);
		_resolveInheritance(metadataRef_struct, libraryRef_struct, return_obj);
		
		return return_obj;
	}
	
	public void function browseDirectory(required string path, required string customTagPath, required struct library)
	{
		var i = 0;
		var files_qry = "";
		var dirs_qry = "";
		var componentPath_str = "";
		var directoryPath_str = "";
		var metadata_struct = "";
		var metadata_obj = "";
		var path_str = arguments.path;
		var customTagPath_str = arguments.customTagPath;
		var libraryRef_struct = arguments.library;
		
		directoryPath_str = path_str;
		directoryPath_str = removeChars(path_str, 1, len(customTagPath_str));
		directoryPath_str = replace(directoryPath_str, "\\", ".", "all");
		directoryPath_str = replace(directoryPath_str, "//", ".", "all");
		directoryPath_str = replace(directoryPath_str, "\", ".", "all");
		directoryPath_str = replace(directoryPath_str, "/", ".", "all");
		if (left(directoryPath_str, 1) eq ".")
		{
			directoryPath_str = removeChars(directoryPath_str, 1, 1);
		}
		if (len(directoryPath_str) > 0 and right(directoryPath_str, 1) neq ".")
		{
			directoryPath_str &= ".";
		}

		files_qry = directoryList(path_str, false, "query", "*.cfc");
		for (i = 1; i <= files_qry.recordCount; i++)
		{
			componentPath_str = directoryPath_str;
			componentPath_str &= listGetAt(files_qry.name[i], 1, ".");
			
			metadata_struct = getComponentMetadata(componentPath_str);
			metadata_obj = createMetadataObject(metadata_struct, libraryRef_struct);
			structInsert(libraryRef_struct, metadata_struct.name, metadata_obj);
		}
		
		dirs_qry = directoryList(path_str, false, "query");
		for (i = 1; i <= dirs_qry.recordCount; i++)
		{
			if (dirs_qry.type[i] eq "Dir")
			{
				directoryPath_str = path_str;
				// TODO: check expandPath
				directoryPath_str &= "/";
				directoryPath_str &= dirs_qry.name[i];
				browseDirectory(directoryPath_str, customTagPath_str, libraryRef_struct);
			}
		}		
	}
}
</cfscript>