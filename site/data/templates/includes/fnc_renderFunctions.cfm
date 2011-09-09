<cfscript>
	initRenderMethods(model.libraryRef);

	public function initRenderMethods(required struct library)
	{
		var i = 0;

		variables._libraryRef_struct = arguments.library;
		variables._fullNameLookup_struct = {};
		
		var componentNames_arr = structKeyArray(variables._libraryRef_struct);

		// make a list of the last names of all components for performing quick searches
		variables._lastNameList_str = "";
		var componentName_str = "";
		var lastName_str = "";
		for (i = 1; i <= arrayLen(componentNames_arr); i++)
		{
			componentName_str = componentNames_arr[i];
			lastName_str = listLast(componentName_str, ".");
			if (structKeyExists(variables._fullNameLookup_struct, lastName_str))
			{
				//we have a double last name, do not include it at all
				structDelete(variables._fullNameLookup_struct, lastName_str);
			} else
			{
				structInsert(variables._fullNameLookup_struct, lastName_str, componentName_str);
			}
		}
	}

	/**
		Checks whether the full component name can be determined uniquely from its last name 
		and returns it.
	*/
	public string function fullName(required string componentName)
	{
		var componentName_str = arguments.componentName;
		
		if (structKeyExists(variables._fullNameLookup_struct, componentName_str))
		{
			componentName_str = variables._fullNameLookup_struct[componentName_str];
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

				token_str = renderLink(token_str, arguments.rootPath);
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
</cfscript>
<cfset counter_num = 0 />
<cffunction name="renderLink" returntype="string" output="false" hint="
	Converts a piece of string to a hyperlink, or text, depending whether such a link would 
	lead somewhere.
	@return HTML hyperlink or plain text.
">
	<cfargument name="link" type="string" required="true" hint="String to be converted to a hyperlink." />
	<cfargument name="rootPath" type="string" required="false" default="" hint="If not present in the webroot, all links to local pages are prepended by this root path." />
	<cfargument name="componentLastName" type="boolean" required="false" default="false" hint="Display the link as the name behind the last dot of the full component name." />
	<cfargument name="returnNoText" type="boolean" required="false" default="false" hint="Return null/void in case no hyperlink could be created." />
	<cfargument name="fromPackageRoot" type="boolean" required="false" default="false" hint="Treat the current package directory as the webroot and strips links to components of the package path." />

	<cfset var componentName_str = "" />
	<cfset var componentLink_str = "" />
	<cfset var componentURL_str = "" />
	<cfset var classListFrameLink_str = "" />
	<cfset var typeArray_bool = false />
	<cfset var link_str = arguments.link />

	<cfif left(link_str, 7) eq "http://">
		<cfset componentLink_str = "<a href=""" />
		<cfset componentLink_str &= link_str />
		<cfset componentLink_str &= """>" />
		<cfset componentLink_str &= link_str />
		<cfset componentLink_str &= "</a>" />
		<cfreturn componentLink_str />
	<cfelse>
		<cfset componentName_str = listFirst(link_str, "##") />

		<cfif right(componentName_str, 2) eq "[]">
			<cfset componentName_str = removeChars(componentName_str, len(componentName_str) - 1, 2) />
			<cfset typeArray_bool = true />
		</cfif>

	<cfif !typeArray_bool and findNoCase("[]", link_str)>
		<cfdump var="|#link_str#|">
		<cfdump var="|#listFirst(link_str, "##")#|">
		<cfdump var="|#right(listFirst(link_str, "##"), 2)#|">
		<cfabort>
	</cfif>

		<cfif listFirst(componentName_str, ".") eq "java">
			<!--- make sure the last name begins with an uppercase character --->
			<cfset componentName_str = listSetAt(componentName_str, listLen(componentName_str, "."), replace(listLast(componentName_str, "."), left(listLast(componentName_str, "."), 1), UCase(left(listLast(componentName_str, "."), 1))), ".") />
			<cfset componentLink_str = "<a href=""" />
			<cfset componentLink_str &= "http://download.oracle.com/javase/6/docs/api/" />
			<cfset componentLink_str &= replace(componentName_str, ".", "/", "all") />
			<cfset componentLink_str &= ".html" />
			<cfif len(link_str) > len(componentName_str)>
				<cfset componentLink_str &= removechars(link_str, 1, len(componentName_str)) />
			</cfif>
			<cfset componentLink_str &= """>" />
			<cfset componentLink_str &= componentName_str />
			<cfset componentLink_str &= "</a>" />
			<cfif typeArray_bool>
				<cfset componentLink_str &= "[]" />
			</cfif>
			<cfreturn componentLink_str />
		<cfelse>
			<!--- check whether the component can be traced to a documentation page --->
			<cfset componentURL_str = toHRef(componentName_str, arguments.rootPath, arguments.fromPackageRoot) />
			
			<cfif len(componentURL_str) gt 0>
				<cfset classListFrameLink_str = toFrameLink(componentName_str, arguments.rootPath, arguments.fromPackageRoot) />

				<cfset componentLink_str = "<a href=""" />
				<cfset componentLink_str &= componentURL_str />
				<cfif len(link_str) > len(componentName_str)>
					<!--- add the rest of the link --->
					<cfset var linkRest_str = removechars(link_str, 1, len(componentName_str)) />
					<cfif typeArray_bool>
						<cfset linkRest_str = removechars(linkRest_str, 1, 2) />
					</cfif>
					<cfset componentLink_str &= linkRest_str />
				</cfif>

				<cfset componentLink_str &= """ onclick=""javascript:loadClassListFrame('" />
				<cfset componentLink_str &= classListFrameLink_str />
				<cfset componentLink_str &= "');""" />
				<cfif arguments.componentLastName>
					<cfset componentLink_str &= " title=""" />
					<cfset componentLink_str &= componentName_str />
					<cfset componentLink_str &= """>" />
					<cfset componentLink_str &= listLast(componentName_str, ".") />
				<cfelse>
					<cfset componentLink_str &= ">" />
					<cfset componentLink_str &= fullName(componentName_str) />
				</cfif>
				<cfset componentLink_str &= "</a>" />
				<cfif typeArray_bool>
					<cfset componentLink_str &= "[]" />
				</cfif>
				<cfif arguments.componentLastName and isInterface(componentName_str)>
					<cfset componentLink_str = "<i>" & componentLink_str & "</i>" />
				</cfif>
				<cfreturn componentLink_str />
			<cfelse>
				<cfif arguments.returnNoText>
					<cfreturn />
				<cfelse>
					<cfif typeArray_bool>
						<cfset componentName_str &= "[]" />
					</cfif>
					<cfreturn componentName_str />
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="packageLink" returntype="string" output="false" hint="
	Converts a package key to the hyperlink belonging to the package-detail page.
	@return HTML hyperlink.
">
	<cfargument name="packageKey" type="string" required="true" hint="Package key to be converted to a hyperlink." />
	<cfargument name="fromPackageRoot" type="boolean" required="false" default="false" hint="Treat the current package directory as the webroot and strips links to components of the package path." />

	<cfset var displayName_str = "" />
	<cfset var packagePath_str = "" />
	<cfset var return_str = "" />
	<cfset var packageKey_str = arguments.packageKey />

	<cfif packageKey_str eq "_topLevel">
		<cfset displayName_str = "Top Level" />
	<cfelse>
		<cfset displayName_str = packageKey_str />
		<cfif not arguments.fromPackageRoot>
			<cfset packagePath_str = replace(packageKey_str, ".", "/", "all") & "/" />
		</cfif>
	</cfif>

	<cfset return_str = "<a href=""" />
	<cfset return_str &= packagePath_str />
	<cfset return_str &= "package-detail.html"" onclick=""javascript:loadClassListFrame('" />
	<cfset return_str &= packagePath_str />
	<cfset return_str &= "class-list.html');"">" />
	<cfset return_str &= displayName_str />
	<cfset return_str &= "</a>" />

	<cfreturn return_str />
</cffunction>