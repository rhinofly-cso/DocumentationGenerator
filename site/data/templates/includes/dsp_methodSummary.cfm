<div class="summaryTableTitle">
	Public Methods
</div>
<div class="showHideLinks">
	<cfoutput>
		<div id="hideInheritedMethod" class="hideInheritedMethod">
			<a class="showHideLink" 
				href="##methodSummary" 
				onclick="javascript:setInheritedVisible(false,'Method');">
				<img class="showHideLinkImage" src="#local.rootPath_str#images/expanded.gif">
				Hide Inherited Public Methods</a>
		</div>
		<div id="showInheritedMethod" class="showInheritedMethod">
			<a class="showHideLink" 
				href="##methodSummary" 
				onclick="javascript:setInheritedVisible(true,'Method');">
				<img class="showHideLinkImage" src="#local.rootPath_str#images/collapsed.gif">
				Show Inherited Public Methods</a>
		</div>
	</cfoutput>
</div>
<table cellspacing="0" cellpadding="3" class="summaryTable " id="summaryTableMethod">
	<tr>
		<th>
			&nbsp;
		</th>
		<th colspan="2">
			Method
		</th>
		<th class="summaryTableOwnerCol">
			Defined By
		</th>
	</tr>

	<cfloop from="1" to="#arrayLen(local.methods_struct.methodSummaryRows)#" index="local.row_num">
		<cfset local.methodMetadata_obj = local.methods_struct.methodSummaryRows[local.row_num].metadata />
	
		<cfset local.methodSignature_str = model.rendering_obj.convertToLink(local.methodMetadata_obj.getReturnType(), local.rootPath_str, true) />
		<cfset local.methodSignature_str &= " <a href=""" />
		<cfif local.methods_struct.methodSummaryRows[local.row_num].definedBy neq local.componentName_str>
			<cfset local.methodSignature_str &= local.rootPath_str />
			<cfset local.methodSignature_str &= replace(local.methods_struct.methodSummaryRows[local.row_num].definedBy, ".", "/", "all") />
			<cfset local.methodSignature_str &= ".html" />
		</cfif>
		<!--- append a pound sign --->
		<cfset local.methodSignature_str &= chr(35) />
		<cfset local.methodSignature_str &= local.methods_struct.methodSummaryRows[local.row_num].name />
		<cfset local.methodSignature_str &= "()"" class=""signatureLink"">" />
		<cfset local.methodSignature_str &= local.methods_struct.methodSummaryRows[local.row_num].name />
		<cfset local.methodSignature_str &= "</a>" />

		<cfset local.methodSignature_str &= "(" />
		<cfset local.parameters_arr = local.methodMetadata_obj.getParameters() />
		<cfset local.paramStarted_bool = false />
		<cfloop from="1" to="#arrayLen(local.parameters_arr)#" index="local.param_num">
			<cfset model.rendering_obj.renderHint(local.parameters_arr[local.param_num], local.rootPath_str) />
			<cfset local.argumentType_str = local.parameters_arr[local.param_num].getType() />
			<cfset local.argumentDefault = local.parameters_arr[local.param_num].getDefault() />
			<cfif local.paramStarted_bool>
				<cfset local.methodSignature_str &= ", " />
			<cfelse>
				<cfset local.paramStarted_bool = true>
			</cfif>
			<cfif local.parameters_arr[local.param_num].getRequired()>
				<cfset local.methodSignature_str &= "required " />
			</cfif>
			<cfset local.methodSignature_str &= model.rendering_obj.convertToLink(local.argumentType_str, local.rootPath_str, true) />
			<cfset local.methodSignature_str &= " " />
			<cfset local.methodSignature_str &= local.parameters_arr[local.param_num].getName() />
			<cfif not isNull(local.argumentDefault)>
				<cfset local.methodSignature_str &= "=" />
				<cfif local.argumentType_str eq "string">
					<cfset local.methodSignature_str &= """" />
					<cfset local.methodSignature_str &= local.argumentDefault />
					<cfset local.methodSignature_str &= """" />
				<cfelseif local.argumentType_str eq "date">
					<cfset local.methodSignature_str &= """" />
					<cfset local.methodSignature_str &= """" />
				<cfelseif local.argumentType_str eq "numeric">
					<cfset local.methodSignature_str &= local.argumentDefault />
				<cfelseif local.argumentType_str eq "boolean">
					<cfif local.argumentDefault>
						<cfset local.methodSignature_str &= "true" />
					<cfelse>
						<cfset local.methodSignature_str &= "false" />
					</cfif>
				<cfelseif local.argumentType_str eq "variableName">
					<cfset local.methodSignature_str &= local.argumentDefault />
				<cfelse>
					<cfset local.methodSignature_str &= "&lt;<i>" />
					<cfset local.methodSignature_str &= local.argumentType_str />
					<cfset local.methodSignature_str &= "</i>&gt;" />
				</cfif>
			</cfif>
		</cfloop>
		<cfset local.methodSignature_str &= ")" />

		<cfoutput>
			<cfif local.methods_struct.methodSummaryRows[local.row_num].definedBy eq local.componentName_str>
				<tr class="">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						&nbsp;
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#local.methodSignature_str#
						</div>
						<div class="summaryTableDescription">
							<cfif local.methods_struct.methodSummaryRows[local.row_num].override>
								[override]
							</cfif>
							#model.rendering_obj.renderHint(local.methodMetadata_obj, local.rootPath_str, "short")#
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
							#local.methodSignature_str#
						</div>
						<div class="summaryTableDescription">
							<cfif local.methods_struct.methodSummaryRows[local.row_num].override>
								[override]
							</cfif>
							#model.rendering_obj.renderHint(local.methodMetadata_obj, local.rootPath_str, "short")#
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#model.rendering_obj.convertToLink(local.methods_struct.methodSummaryRows[local.row_num].definedBy, local.rootPath_str, true)#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfloop>
</table>