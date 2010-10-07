<cffunction name="renderLink" returntype="string" output="false" hint="
	Converts a piece of string to a hyperlink, or text, depending whether such a link would 
	lead somewhere.
	@return HTML hyperlink or plain text.
">
	<cfargument name="link" type="string" required="true" hint="String to be converted to a hyperlink." />
	<cfargument name="renderingObject" type="any" required="true" hint"Instance of the type {@link} cfc.TemplateRendering." />
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
	<cfset var rendering_obj = arguments.renderingObject />

	<cfif left(link_str, 7) eq "http://">
		<cfset componentLink_str = "<a href=""" />
		<cfset componentLink_str &= link_str />
		<cfset componentLink_str &= """>" />
		<cfset componentLink_str &= link_str />
		<cfset componentLink_str &= "</a>" />
		<cfreturn componentLink_str />
	<cfelse>
		<cfset componentName_str = listFirst(link_str, chr(35)) />

		<cfif right(componentName_str, 2) eq "[]">
			<cfset componentName_str = removeChars(componentName_str, len(componentName_str) - 1, 2) />
			<cfset typeArray_bool = true />
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
			<cfset componentURL_str = rendering_obj.toHRef(componentName_str, arguments.rootPath, arguments.fromPackageRoot) />
			
			<cfif len(componentURL_str) gt 0>
				<cfset classListFrameLink_str = rendering_obj.toFrameLink(componentName_str, arguments.rootPath, arguments.fromPackageRoot) />

				<cfset componentLink_str = "<a href=""" />
				<cfset componentLink_str &= componentURL_str />
				<cfif len(link_str) > len(componentName_str)>
					<cfset componentLink_str &= removechars(link_str, 1, len(componentName_str)) />
					<cfif typeArray_bool>
						<cfset componentLink_str &= removechars(link_str, 1, 2) />
					</cfif>
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
					<cfset componentLink_str &= componentName_str />
				</cfif>
				<cfset componentLink_str &= "</a>" />
				<cfif typeArray_bool>
					<cfset componentLink_str &= "[]" />
				</cfif>
				<cfif arguments.componentLastName and rendering_obj.isInterface(componentName_str)>
					<cfset componentLink_str = "<i>" & componentLink_str & "</i>" />
				</cfif>
				<cfset return componentLink_str />
			<cfelse>
				<cfif arguments.returnHRefOnly>
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