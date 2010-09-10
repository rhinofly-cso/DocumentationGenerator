<cfset properties_arr = builder_obj.propertyArray(componentName_str, libraryRef_struct) />
<cfset propertySummaryRows_str = "" />
<cfset propertyDetailItems_str = "" />
<cfset nonInheritedProperties_bool = false />
<cfset started_bool = false />

<cfloop from="1" to="#arrayLen(variables.properties_arr)#" index="i">
	<cfset propertyMetadata_obj = variables.properties_arr[i].metadata />

	<!--- TODO: move to DocumentBuilder --->
	<cfset variables.builder_obj.parseObjectHint(variables.propertyMetadata_obj, variables.libraryRef_struct, variables.rootPath_str) />

	<cfset propertySignature_str = builder_obj.convertToLink(variables.propertyMetadata_obj.getType(), variables.libraryRef_struct, variables.rootPath_str, true) />
	<cfset propertySignature_str &= " <a href=""" />
	<cfif variables.properties_arr[i].definedBy neq componentName_str>
		<cfset propertySignature_str &= variables.rootPath_str />
		<cfset propertySignature_str &= replace(variables.properties_arr[i].definedBy, ".", "/", "all") />
		<cfset propertySignature_str &= ".html" />
	<cfelse>
		<cfset nonInheritedProperties_bool = true />
	</cfif>
	<!--- append a pound sign --->
	<cfset propertySignature_str &= chr(35) />
	<cfset propertySignature_str &= variables.properties_arr[i].name />
	<cfset propertySignature_str &= """ class=""signatureLink"">" />
	<cfset propertySignature_str &= variables.properties_arr[i].name />
	<cfset propertySignature_str &= "</a>" />

	<cfsavecontent variable="variables.propertySummaryRows_str">
		<cfoutput>
			#variables.propertySummaryRows_str#
			<cfif variables.properties_arr[i].definedBy eq componentName_str>
				<tr class="">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						&nbsp;
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#variables.propertySignature_str#
						</div>
						<div class="summaryTableDescription">
							#propertyMetadata_obj.getShortHint()#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#listLast(componentName_str, ".")#
					</td>
				</tr>
			<cfelse>
				<tr class="hideInheritedMethod">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						<img src="#variables.rootPath_str#images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage">
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#variables.propertySignature_str#
						</div>
						<div class="summaryTableDescription">
							#propertyMetadata_obj.getShortHint()#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#builder_obj.convertToLink(variables.properties_arr[i].definedBy, variables.libraryRef_struct, variables.rootPath_str, true)#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfif variables.properties_arr[i].definedBy eq componentName_str>
		<cfset propertyRelated_str = variables.propertyMetadata_obj.getRelated() />
		<cfset propertySignature_str = builder_obj.convertToLink(variables.propertyMetadata_obj.getType(), variables.libraryRef_struct, variables.rootPath_str, true) />
		<cfset propertySignature_str &= " " />
		<cfset propertySignature_str &= variables.properties_arr[i].name />
		
		<cfsavecontent variable="variables.propertyDetailItems_str">
			<cfoutput>
				#variables.propertyDetailItems_str#
				<a name="#variables.properties_arr[i].name#"></a>
				<table class="detailHeader" cellpadding="0" cellspacing="0">
					<tr>
						<td class="detailHeaderName">
							#variables.properties_arr[i].name#
						</td>
						<td class="detailHeaderType">
							property
						</td>
						<cfif started_bool>
							<td class="detailHeaderRule"></td>
						<cfelse>
							<cfset started_bool = true />
						</cfif>
					</tr>
				</table>
				<div class="detailBody">
					<code>#variables.propertySignature_str#</code>
					<p>
						#propertyMetadata_obj.getHint()#
					</p>
					<cfif not variables.propertyMetadata_obj.getSerializable()>
						<p>
							<span class="label">Not serializable</span>
						</p>
					</cfif>
					<cfif not isNull(variables.propertyRelated_str)>
						<cfset started_bool = false />
						<cfset relatedLinks_str = "" />
						<cfloop list="#variables.propertyRelated_str#" index="component_str">
							<cfif variables.started_bool>
								<cfset relatedLinks_str &= ", " />
							<cfelse>
								<cfset started_bool = true>
							</cfif>
							<cfset relatedLinks_str &= variables.builder_obj.convertToLink(trim(component_str), variables.libraryRef_struct, variables.rootPath_str, true) />
						</cfloop>
						<p>
							<span class="label">See also</span>
						</p>
						<div class="seeAlso">
							#relatedLinks_str#
						</div>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
</cfloop>
