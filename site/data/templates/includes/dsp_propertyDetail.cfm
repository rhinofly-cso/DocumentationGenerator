<div class="detailSectionHeader">
	Property Detail
</div>

<cfset localVar.started_bool = false />

<cfloop from="1" to="#arrayLen(localVar.properties_struct.propertyDetailItems)#" index="localVar.row_num">
	<cfset localVar.propertyMetadata_obj = localVar.properties_struct.propertyDetailItems[localVar.row_num].metadata />

	<cfset localVar.propertyRelated_str = localVar.propertyMetadata_obj.getRelated() />
	<cfset localVar.propertyType_str = localVar.propertyMetadata_obj.getType() />
	<cfset localVar.propertyDefault = localVar.propertyMetadata_obj.getDefault() />
	<cfset localVar.propertySignature_str = model.rendering_obj.convertToLink(localVar.propertyType_str, localVar.rootPath_str, true) />
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
			<p>
				#model.rendering_obj.renderHint(localVar.propertyMetadata_obj, localVar.rootPath_str)#
			</p>
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
			<cfif not isNull(localVar.propertyRelated_str)>
				<cfset localVar.started_bool = false />
				<cfset localVar.relatedLinks_str = "" />
				<cfloop list="#localVar.propertyRelated_str#" index="localVar.component_str">
					<cfif localVar.started_bool>
						<cfset localVar.relatedLinks_str &= ", " />
					<cfelse>
						<cfset localVar.started_bool = true>
					</cfif>
					<cfset localVar.relatedLinks_str &= model.rendering_obj.convertToLink(trim(localVar.component_str), localVar.rootPath_str, true) />
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