<cffunction name="collectProperties" returntype="struct" output="false" hint="
	Collects the different property metadata for the summary of persistent and non-persistent 
	properties, as well as for detail list of all ""local"" (i.e. non-inherited) properties.
">
	<cfargument name="componentName" type="string" required="true" />
	<cfargument name="propertyArray" type="array" required="true" />
	<cfargument name="renderingObject" type="any" required="true" />

	<cfset var i = 0 />
	<cfset var propertySummaryRows_arr = arrayNew(1) />
	<cfset var persistentPropertySummaryRows_arr = arrayNew(1) />
	<cfset var propertyDetailItems_arr = arrayNew(1) />
	<cfset var return_struct = structNew() />
	<cfset var propertiesRef_arr = arguments.propertyArray />

	<cfloop from="1" to="#arrayLen(propertiesRef_arr)#" index="i">
		<cfif isInstanceOf(propertiesRef_arr[i].metadata, "cfc.cfcData.CFMapping")>
			<cfset arrayAppend(persistentPropertySummaryRows_arr, propertiesRef_arr[i]) />
		<cfelse>
			<cfset arrayAppend(propertySummaryRows_arr, propertiesRef_arr[i]) />
		</cfif>
	
		<cfif propertiesRef_arr[i].definedBy eq arguments.componentName>
			<cfset arrayAppend(propertyDetailItems_arr, propertiesRef_arr[i]) />
		</cfif>
	</cfloop>

	<cfset structInsert(return_struct, "propertySummaryRows", propertySummaryRows_arr) />
	<cfset structInsert(return_struct, "persistentPropertySummaryRows", persistentPropertySummaryRows_arr) />
	<cfset structInsert(return_struct, "propertyDetailItems", propertyDetailItems_arr) />
	
	<cfreturn return_struct />
</cffunction>