<cffunction name="collectProperties" returntype="struct" output="false" hint="
	Collects the different properties for the summary, as well as for detail list of all 
	""local"" properties (i.e. non-inherited).
">
	<cfargument name="componentName" type="string" required="true" />
	<cfargument name="propertyArray" type="array" required="true" />
	<cfargument name="renderingObject" type="any" required="true" />

	<cfset var i = 0 />
	<cfset var propertySummaryRows_arr = arrayNew(1) />
	<cfset var propertyDetailItems_arr = arrayNew(1) />
	<cfset var return_struct = structNew() />
	<cfset var propertiesRef_arr = arguments.propertyArray />

	<cfloop from="1" to="#arrayLen(propertiesRef_arr)#" index="i">
		<cfset arrayAppend(propertySummaryRows_arr, propertiesRef_arr[i]) />
	
		<cfif propertiesRef_arr[i].definedBy eq arguments.componentName>
			<cfset arrayAppend(propertyDetailItems_arr, propertiesRef_arr[i]) />
		</cfif>
	</cfloop>

	<cfset structInsert(return_struct, "propertySummaryRows", propertySummaryRows_arr) />
	<cfset structInsert(return_struct, "propertyDetailItems", propertyDetailItems_arr) />
	
	<cfreturn return_struct />
</cffunction>