<div class="detailSectionHeader">
	Property Detail
</div>

<cfset localVar.started_bool = false />

<cfloop from="1" to="#arrayLen(localVar.properties_struct.propertyDetailItems)#" index="localVar.row_num">
	<cfset localVar.propertyMetadata_obj = localVar.properties_struct.propertyDetailItems[localVar.row_num].metadata />

	<cfif isInstanceOf(localVar.propertyMetadata_obj, "cfc.cfcData.CFMapping")>
		<cfset localVar.ormAttributes_arr = getMetadata(localVar.propertyMetadata_obj).properties />
	</cfif>

	<cfset localVar.propertyRelated_str = localVar.propertyMetadata_obj.getRelated() />
	<cfset localVar.propertyType_str = localVar.propertyMetadata_obj.getType() />
	<cfset localVar.propertyDefault = localVar.propertyMetadata_obj.getDefault() />
	<cfset localVar.propertySignature_str = renderLink(localVar.propertyType_str, localVar.rootPath_str, true) />
	<cfif localVar.properties_struct.propertyDetailItems[localVar.row_num].override>
		<cfset localVar.propertySignature_str &= " override" />
	</cfif>
	<cfset localVar.propertySignature_str &= " " />
	<cfset localVar.propertySignature_str &= localVar.properties_struct.propertyDetailItems[localVar.row_num].name />

	<cfif not isNull(localVar.propertyDefault)>
		<cfif localVar.propertyType_str eq "string">
		<cfelseif localVar.propertyType_str eq "date">
		<cfelseif localVar.propertyType_str eq "numeric">
		<cfelseif localVar.propertyType_str eq "boolean">
			<cfif localVar.propertyDefault>
				<cfset localVar.propertyDefault &= "true" />
			<cfelse>
				<cfset localVar.propertyDefault &= "false" />
			</cfif>
		<cfelseif localVar.propertyType_str eq "variableName">
		<cfelse>
			<cfset localVar.propertyDefault = "&lt;<i>" />
			<cfset localVar.propertyDefault &= localVar.propertyType_str />
			<cfset localVar.propertyDefault &= "</i>&gt;" />
		</cfif>
	</cfif>
		
	<cfoutput>
		<a name="#localVar.properties_struct.propertyDetailItems[localVar.row_num].name#"></a>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
					#localVar.properties_struct.propertyDetailItems[localVar.row_num].name#
				</td>
				<cfif localVar.started_bool>
					<td class="detailHeaderRule"></td>
				<cfelse>
					<cfset localVar.started_bool = true />
				</cfif>
			</tr>
		</table>
		<div class="detailBody">
			<code>#localVar.propertySignature_str#</code>
			<cftry>
				<p>
					#renderHint(localVar.propertyMetadata_obj, localVar.rootPath_str)#
				</p>
				<cfcatch type="any">
					<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
				</cfcatch>
			</cftry>
			<cfif not localVar.propertyMetadata_obj.getSerializable()>
				<p>
					<span class="label">Not serializable</span>
				</p>
			</cfif>
			<cfif not isNull(localVar.propertyDefault)>
				<p>
					<span class="label">Default value:</span>
					#localVar.propertyDefault#
				</p>
			</cfif>
			<cfif isInstanceOf(localVar.propertyMetadata_obj, "cfc.cfcData.CFMapping")>
				<p>
					<span class="label">ORM attributes</span>
					<ul class="paddedList">
						<cfset localVar.ormStarted_bool = false />
						<cfloop from="1" to="#arrayLen(localVar.ormAttributes_arr)#" index="localVar.row_num">
							<cfset localVar.attributeName_str = localVar.ormAttributes_arr[localVar.row_num].name />
							<cfinvoke component="#localVar.propertyMetadata_obj#" method="get#localVar.attributeName_str#" returnvariable="localVar.attributeValue" />
							<cfif not isNull(localVar.attributeValue)>
								<cfset localVar.ormStarted_bool = true />
								<cfif localVar.attributeName_str eq "cfc">
									<cfset localVar.attributeValue = renderLink(localVar.attributeValue, localVar.rootPath_str, false) />
								</cfif>
								<cfoutput>
									<li><code>#localVar.attributeName_str#="#localVar.attributeValue#";</code></li>
								</cfoutput>
							</cfif>
						</cfloop>
						<cfif not localVar.ormStarted_bool>
							<li>&lt;<i>none</i>&gt;</li>
						</cfif>
					</ul>
				</p>
			</cfif>
			<cfif not isNull(localVar.propertyRelated_str)>
				<cfset localVar.relatedStarted_bool = false />
				<cfset localVar.relatedLinks_str = "" />
				<cfloop list="#localVar.propertyRelated_str#" index="localVar.component_str">
					<cfif localVar.relatedStarted_bool>
						<cfset localVar.relatedLinks_str &= ", " />
					<cfelse>
						<cfset localVar.relatedStarted_bool = true>
					</cfif>
					<cfset localVar.relatedLinks_str &= renderLink(trim(localVar.component_str), localVar.rootPath_str, true) />
				</cfloop>
				<p>
					<span class="label">See also</span>
				</p>
				<div class="seeAlso">
					#localVar.relatedLinks_str#
				</div>
			</cfif>
		</div>
	</cfoutput>
</cfloop>