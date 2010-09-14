<div class="summaryTableTitle">
	Properties
</div>
<div class="showHideLinks">
	<cfoutput>
		<div id="hideInheritedProperty" class="hideInheritedProperty">
			<a class="showHideLink" 
				href="##propertySummary" 
				onclick="javascript:setInheritedVisible(false,'Property');">
				<img class="showHideLinkImage" src="#local.rootPath_str#images/expanded.gif">
				Hide Inherited Properties</a>
		</div>
		<div id="showInheritedProperty" class="showInheritedMProperty">
			<a class="showHideLink" 
				href="##propertySummary" 
				onclick="javascript:setInheritedVisible(true,'Property');">
				<img class="showHideLinkImage" src="#local.rootPath_str#images/collapsed.gif">
				Show Inherited Properties</a>
		</div>
	</cfoutput>
</div>
<table cellspacing="0" cellpadding="3" class="summaryTable " id="summaryTableMethod">
	<tr>
		<th>
			&nbsp;
		</th>
		<th colspan="2">
			Property
		</th>
		<th class="summaryTableOwnerCol">
			Defined By
		</th>
	</tr>

	<cfloop from="1" to="#arrayLen(local.properties_struct.propertySummaryRows)#" index="local.row_num">
		<cfset local.propertyMetadata_obj = local.properties_struct.propertySummaryRows[local.row_num].metadata />

		<cfset local.propertySignature_str = model.rendering_obj.convertToLink(local.propertyMetadata_obj.getType(), local.rootPath_str, true) />
		<cfset local.propertySignature_str &= " <a href=""" />
		<cfif local.properties_struct.propertySummaryRows[local.row_num].definedBy neq local.componentName_str>
			<cfset local.propertySignature_str &= local.rootPath_str />
			<cfset local.propertySignature_str &= replace(local.properties_struct.propertySummaryRows[local.row_num].definedBy, ".", "/", "all") />
			<cfset local.propertySignature_str &= ".html" />
		</cfif>
		<!--- append a pound sign --->
		<cfset local.propertySignature_str &= chr(35) />
		<cfset local.propertySignature_str &= local.properties_struct.propertySummaryRows[local.row_num].name />
		<cfset local.propertySignature_str &= """ class=""signatureLink"">" />
		<cfset local.propertySignature_str &= local.properties_struct.propertySummaryRows[local.row_num].name />
		<cfset local.propertySignature_str &= "</a>" />
		
		<cfoutput>
			<cfif local.properties_struct.propertySummaryRows[local.row_num].definedBy eq local.componentName_str>
				<tr class="">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						&nbsp;
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#local.propertySignature_str#
						</div>
						<div class="summaryTableDescription">
							#model.rendering_obj.renderHint(local.propertyMetadata_obj, local.rootPath_str, "short")#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#listLast(local.componentName_str, ".")#
					</td>
				</tr>
			<cfelse>
				<tr class="hideInheritedMethod">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						<img src="#local.rootPath_str#images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage">
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#local.propertySignature_str#
						</div>
						<div class="summaryTableDescription">
							#model.rendering_obj.renderHint(local.propertyMetadata_obj, local.rootPath_str, "short")#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#model.rendering_obj.convertToLink(local.properties_struct.propertySummaryRows[local.row_num].definedBy, local.rootPath_str, true)#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfloop>
</table>