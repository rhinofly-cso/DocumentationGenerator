<cffunction name="collectMethods" returntype="struct" output="false" hint="
	Collects the different methods for the summaries of public, remote, and private methods, as 
	well as for the detail list of all ""local"" methods (i.e. non-inherited). Also adds method 
	signatures to the method metadata structures.
">
	<cfargument name="componentName" type="string" required="true" />
	<cfargument name="methodArray" type="array" required="true" />
	<cfargument name="renderingObject" type="any" required="true" />

	<cfset var i = 0 />
	<cfset var methodSummaryRows_arr = arrayNew(1) />
	<cfset var remoteMethodSummaryRows_arr = arrayNew(1) />
	<cfset var protectedMethodSummaryRows_arr = arrayNew(1) />
	<cfset var methodDetailItems_arr = arrayNew(1) />
	<cfset var return_struct = structNew() />
	<cfset var methodsRef_arr = arguments.methodArray />

	<cfloop from="1" to="#arrayLen(methodsRef_arr)#" index="i">
		<cfif methodsRef_arr[i].metadata.getAccess() eq "public">
			<cfset arrayAppend(methodSummaryRows_arr, methodsRef_arr[i]) />
		<cfelseif methodsRef_arr[i].metadata.getAccess() eq "remote">
			<cfset arrayAppend(remoteMethodSummaryRows_arr, methodsRef_arr[i]) />
		<cfelseif methodsRef_arr[i].metadata.getAccess() eq "private">
			<cfset arrayAppend(protectedMethodSummaryRows_arr, methodsRef_arr[i]) />
		</cfif>
		
		<cfif methodsRef_arr[i].definedBy eq arguments.componentName>
			<cfset arrayAppend(methodDetailItems_arr, methodsRef_arr[i]) />
		</cfif>
	</cfloop>
	
	<cfset structInsert(return_struct, "methodSummaryRows", methodSummaryRows_arr) />
	<cfset structInsert(return_struct, "remoteMethodSummaryRows", remoteMethodSummaryRows_arr) />
	<cfset structInsert(return_struct, "protectedMethodSummaryRows", protectedMethodSummaryRows_arr) />
	<cfset structInsert(return_struct, "methodDetailItems", methodDetailItems_arr) />
	
	<cfreturn return_struct />
</cffunction>