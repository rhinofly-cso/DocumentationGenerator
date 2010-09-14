<a name="propertyDetail"></a>
<div class="detailSectionHeader">
	Property Detail
</div>

<cfset local.started_bool = false />

<cfloop from="1" to="#arrayLen(local.properties_struct.propertyDetailItems)#" index="local.row_num">
	<cfset local.propertyMetadata_obj = local.properties_struct.propertyDetailItems[local.row_num].metadata />

	<cfset local.propertyRelated_str = local.propertyMetadata_obj.getRelated() />
	<cfset local.propertySignature_str = model.rendering_obj.convertToLink(local.propertyMetadata_obj.getType(), local.rootPath_str, true) />
	<cfset local.propertySignature_str &= " " />
	<cfset local.propertySignature_str &= local.properties_struct.propertyDetailItems[local.row_num].name />
		
	<cfoutput>
		<a name="#local.properties_struct.propertyDetailItems[local.row_num].name#"></a>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
					#local.properties_struct.propertyDetailItems[local.row_num].name#
				</td>
				<td class="detailHeaderType">
					property
				</td>
				<cfif local.started_bool>
					<td class="detailHeaderRule"></td>
				<cfelse>
					<cfset local.started_bool = true />
				</cfif>
			</tr>
		</table>
		<div class="detailBody">
			<code>#local.propertySignature_str#</code>
			<p>
				#model.rendering_obj.renderHint(local.propertyMetadata_obj, local.rootPath_str)#
			</p>
			<cfif not local.propertyMetadata_obj.getSerializable()>
				<p>
					<span class="label">Not serializable</span>
				</p>
			</cfif>
			<cfif not isNull(local.propertyRelated_str)>
				<cfset local.started_bool = false />
				<cfset local.relatedLinks_str = "" />
				<cfloop list="#local.propertyRelated_str#" index="local.component_str">
					<cfif local.started_bool>
						<cfset local.relatedLinks_str &= ", " />
					<cfelse>
						<cfset local.started_bool = true>
					</cfif>
					<cfset local.relatedLinks_str &= model.rendering_obj.convertToLink(trim(local.component_str), local.rootPath_str, true) />
				</cfloop>
				<p>
					<span class="label">See also</span>
				</p>
				<div class="seeAlso">
					#local.relatedLinks_str#
				</div>
			</cfif>
		</div>
	</cfoutput>
</cfloop>