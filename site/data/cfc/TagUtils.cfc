<cfcomponent displayname="cfc.TagUtils" hint="
	Methods in this component provide access to functionality that is only available through 
	tags. This component was taken as {@link} fly.cso.system.TagUtils from the CSOShared 
	library and stripped down to only the invokeMethod function.
">
	<cffunction name="invokeMethod" access="public" returntype="any" hint="Gives access to the cfinvoke tag">
		<cfargument name="component" type="any" required="true" />
		<cfargument name="method" type="string" required="true" />
		<cfargument name="methodArguments" type="struct" required="false" default="#structNew()#" />
	
		<cfset var result = "" />
	
		<cfinvoke component="#arguments.component#" method="#arguments.method#" argumentcollection="#arguments.methodArguments#" returnvariable="result" />
	
		<cfif not isNull(result)>
			<cfreturn result />
		</cfif>
	</cffunction>
</cfcomponent>