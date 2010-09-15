<div class="summaryTableTitle">
	Properties
</div>
<div class="showHideLinks">
	<cfoutput>
		<div id="hideInheritedProperty" class="hideInheritedProperty">
			<a class="showHideLink" 
				href="##propertySummary" 
				onclick="javascript:setInheritedVisible(false,'Property');">
				<img class="showHideLinkImage" src="#localVar.rootPath_str#images/expanded.gif">
				Hide Inherited Properties</a>
		</div>
		<div id="showInheritedProperty" class="showInheritedMProperty">
			<a class="showHideLink" 
				href="##propertySummary" 
				onclick="javascript:setInheritedVisible(true,'Property');">
				<img class="showHideLinkImage" src="#localVar.rootPath_str#images/collapsed.gif">
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

	<cfloop from="1" to="#arrayLen(localVar.properties_struct.propertySummaryRows)#" index="localVar.row_num">
		<cfset localVar.propertyMetadata_obj = localVar.properties_struct.propertySummaryRows[localVar.row_num].metadata />

		<cfset localVar.propertySignature_str = model.rendering_obj.convertToLink(localVar.propertyMetadata_obj.getType(), localVar.rootPath_str, true) />
		<cfset localVar.propertySignature_str &= " <a href=""" />
		<cfif localVar.properties_struct.propertySummaryRows[localVar.row_num].definedBy neq localVar.componentName_str>
			<cfset localVar.propertySignature_str &= localVar.rootPath_str />
			<cfset localVar.propertySignature_str &= replace(localVar.properties_struct.propertySummaryRows[localVar.row_num].definedBy, ".", "/", "all") />
			<cfset localVar.propertySignature_str &= ".html" />
		</cfif>
		<!--- append a pound sign --->
		<cfset localVar.propertySignature_str &= chr(35) />
		<cfset localVar.propertySignature_str &= localVar.properties_struct.propertySummaryRows[localVar.row_num].name />
		<cfset localVar.propertySignature_str &= """ class=""signatureLink"">" />
		<cfset localVar.propertySignature_str &= localVar.properties_struct.propertySummaryRows[localVar.row_num].name />
		<cfset localVar.propertySignature_str &= "</a>" />
		
		<cfoutput>
			<cfif localVar.properties_struct.propertySummaryRows[localVar.row_num].definedBy eq localVar.componentName_str>
				<tr class="">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						&nbsp;
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#localVar.propertySignature_str#
						</div>
						<div class="summaryTableDescription">
							#model.rendering_obj.renderHint(localVar.propertyMetadata_obj, localVar.rootPath_str, "short")#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#listLast(localVar.componentName_str, ".")#
					</td>
				</tr>
			<cfelse>
				<tr class="hideInheritedMethod">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						<img src="#localVar.rootPath_str#images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage">
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#localVar.propertySignature_str#
						</div>
						<div class="summaryTableDescription">
							#model.rendering_obj.renderHint(localVar.propertyMetadata_obj, localVar.rootPath_str, "short")#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#model.rendering_obj.convertToLink(localVar.properties_struct.propertySummaryRows[localVar.row_num].definedBy, localVar.rootPath_str, true)#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfloop>
</table>