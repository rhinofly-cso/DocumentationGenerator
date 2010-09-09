<div class="summaryTableTitle">
	Properties
</div>
<div class="showHideLinks">
	<div id="hideInheritedProperty" class="hideInheritedProperty">
		<a class="showHideLink" 
			href="#propertySummary" 
			onclick="javascript:setInheritedVisible(false,'Property');">
			<img class="showHideLinkImage" src="#variables.rootPath_str#images/expanded.gif">
			Hide Inherited Properties</a>
	</div>
	<div id="showInheritedProperty" class="showInheritedMProperty">
		<a class="showHideLink" 
			href="#propertySummary" 
			onclick="javascript:setInheritedVisible(true,'Property');">
			<img class="showHideLinkImage" src="#variables.rootPath_str#images/collapsed.gif">
			Show Inherited Properties</a>
	</div>
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
	<cfloop from="1" to="#arrayLen(variables.properties_arr)#" index="i">
		<cfset propertyMetadata_obj = variables.properties_arr[i].metadata />
		<cfif not propertyMetadata_obj.getPrivate()>
			<cfset propertySignature_str = builder_obj.convertToLink(variables.propertyMetadata_obj.getType(), variables.libraryRef_struct, variables.rootPath_str, true) />
			<cfset propertySignature_str &= " <a href=""" />
			<cfif variables.properties_arr[i].definedBy neq componentName_str>
				<cfset propertySignature_str &= variables.rootPath_str />
				<cfset propertySignature_str &= replace(variables.properties_arr[i].definedBy, ".", "/", "all") />
				<cfset propertySignature_str &= ".html" />
			</cfif>
			<!--- append a pound sign --->
			<cfset propertySignature_str &= chr(35) />
			<cfset propertySignature_str &= variables.properties_arr[i].name />
			<cfset propertySignature_str &= "()"" class=""signatureLink"">" />
			<cfset propertySignature_str &= variables.properties_arr[i].name />
			<cfset propertySignature_str &= "</a>" />

			<cfoutput>
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
		</cfif>
	</cfloop>
</table>