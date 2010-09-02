<!--- creates rows for the component-details table including the component/interface name --->
<cfset extendsLinks_str = "" />
<cfif variables.type_str eq "Interface" and listLen(variables.extends_str) gt 0>
	<cfset started_bool = false />
	<cfset extendsLinks_str = " extends " />
	<cfloop list="variables.extends_str" index="parent_str">
		<cfif variables.started_bool>
			<cfset extendsLinks_str &= ", " />
		<cfelse>
			<cfset started_bool = true>
		</cfif>
		<cfif structKeyExists(variables.libraryRef_struct, parent_str)>
			<cfset extendsLinks_str &= "<a href=""" />
			<cfset extendsLinks_str &= variables.rootPath_str />
			<cfset extendsLinks_str &= replace(parent_str, ".", "/") />
			<cfset extendsLinks_str &= ".html"">" />
			<cfset extendsLinks_str &= listLast(parent_str, ".") />
			<cfset extendsLinks_str &= "</a>" />
		<cfelse>
			<cfset extendsLinks_str &= listLast(parent_str, ".") />
		</cfif>
	</cfloop>
<cfelseif variables.type_str eq "Component" and listLen(variables.extends_str) gt 0>
	
</cfif>

<tr>
	<td class="classHeaderTableLabel">
		#variables.type_str#
	</td>
	<td class="classSignature">
		#listLast(variables.componentName_str, ".") & variables.extendsLinks_str#
	</td>
</tr>
