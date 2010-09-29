<div class="summaryTableTitle">
	Private Methods
</div>
<table cellspacing="0" cellpadding="3" class="summaryTable " id="summaryTableProtectedMethod">
	<tr>
		<th>
			&nbsp;
		</th>
		<th colspan="3">
			Method
		</th>
		<th class="summaryTableOwnerCol">
			Defined By
		</th>
	</tr>

	<cfloop from="1" to="#arrayLen(localVar.methods_struct.protectedMethodSummaryRows)#" index="localVar.row_num">
		<cfset localVar.methodMetadata_obj = localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].metadata />
	
		<cfset localVar.methodSignature_str = "<a href=""" />
		<cfif localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy neq localVar.componentName_str>
			<cfset localVar.methodSignature_str &= localVar.rootPath_str />
			<cfset localVar.methodSignature_str &= replace(localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy, ".", "/", "all") />
			<cfset localVar.methodSignature_str &= ".html" />
		<cfelse>
			<cfset nonInheritedMethods_bool = true />
		</cfif>
		<!--- append a pound sign --->
		<cfset localVar.methodSignature_str &= chr(35) />
		<cfset localVar.methodSignature_str &= localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].name />
		<cfset localVar.methodSignature_str &= "()"" class=""signatureLink"">" />
		<cfset localVar.methodSignature_str &= localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].name />
		<cfset localVar.methodSignature_str &= "</a>" />
	
		<cfset localVar.methodSignature_str &= "(" />
		<cfset localVar.parameters_arr = localVar.methodMetadata_obj.getParameters() />
		<cfset localVar.paramStarted_bool = false />
		<cfloop from="1" to="#arrayLen(localVar.parameters_arr)#" index="localVar.param_num">
			<cftry>
				<cfset model.rendering_obj.renderHint(localVar.parameters_arr[localVar.param_num], localVar.rootPath_str) />
				<cfcatch type="any">
					<cfthrow message="Please review the comments in component #localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy#." detail="#cfcatch.message#">
				</cfcatch>
			</cftry>
			<cfset localVar.argumentType_str = localVar.parameters_arr[localVar.param_num].getType() />
			<cfset localVar.argumentDefault = localVar.parameters_arr[localVar.param_num].getDefault() />
			<cfif localVar.paramStarted_bool>
				<cfset localVar.methodSignature_str &= ", " />
			<cfelse>
				<cfset localVar.paramStarted_bool = true>
			</cfif>
			<cfif localVar.parameters_arr[localVar.param_num].getRequired()>
				<cfset localVar.methodSignature_str &= "required " />
			</cfif>
			<cfset localVar.methodSignature_str &= model.rendering_obj.convertToLink(localVar.argumentType_str, localVar.rootPath_str, true) />
			<cfset localVar.methodSignature_str &= " " />
			<cfset localVar.methodSignature_str &= localVar.parameters_arr[localVar.param_num].getName() />
			<cfif not isNull(localVar.argumentDefault)>
				<cfset localVar.methodSignature_str &= "=" />
				<cfif localVar.argumentType_str eq "string">
					<cfset localVar.methodSignature_str &= """" />
					<cfset localVar.methodSignature_str &= localVar.argumentDefault />
					<cfset localVar.methodSignature_str &= """" />
				<cfelseif localVar.argumentType_str eq "date">
					<cfset localVar.methodSignature_str &= """" />
					<cfset localVar.methodSignature_str &= localVar.argumentDefault />
					<cfset localVar.methodSignature_str &= """" />
				<cfelseif localVar.argumentType_str eq "numeric">
					<cfset localVar.methodSignature_str &= localVar.argumentDefault />
				<cfelseif localVar.argumentType_str eq "boolean">
					<cfif localVar.argumentDefault>
						<cfset localVar.methodSignature_str &= "true" />
					<cfelse>
						<cfset localVar.methodSignature_str &= "false" />
					</cfif>
				<cfelseif localVar.argumentType_str eq "variableName">
					<cfset localVar.methodSignature_str &= localVar.argumentDefault />
				<cfelse>
					<cfset localVar.methodSignature_str &= "&lt;<i>" />
					<cfset localVar.methodSignature_str &= localVar.argumentType_str />
					<cfset localVar.methodSignature_str &= "</i>&gt;" />
				</cfif>
			</cfif>
		</cfloop>
		<cfset localVar.methodSignature_str &= ")" />
	
		<cfoutput>
			<cfif localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy eq localVar.componentName_str>
				<tr class="">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						&nbsp;
					</td>
					<td class="summaryTableTypeCol">
						<div class="summarySignature">
							#model.rendering_obj.convertToLink(localVar.methodMetadata_obj.getReturnType(), localVar.rootPath_str, true)#
						</div>
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#localVar.methodSignature_str#
						</div>
						<div class="summaryTableDescription">
							<cfif localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].override>
								[override]
							</cfif>
							<cftry>
								#model.rendering_obj.renderHint(localVar.methodMetadata_obj, localVar.rootPath_str, true)#
								<cfcatch type="any">
									<cfthrow message="Please review the comments in component #localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy#." detail="#cfcatch.message#">
								</cfcatch>
							</cftry>
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#listLast(localVar.componentName_str, ".")#
					</td>
				</tr>
			<cfelse>
				<tr class="">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableInheritanceCol">
						<img src="#localVar.rootPath_str#images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage">
					</td>
					<td class="summaryTableTypeCol">
						<div class="summarySignature">
							#model.rendering_obj.convertToLink(localVar.methodMetadata_obj.getReturnType(), localVar.rootPath_str, true)#
						</div>
					</td>
					<td class="summaryTableSignatureCol">
						<div class="summarySignature">
							#localVar.methodSignature_str#
						</div>
						<div class="summaryTableDescription">
							<cfif localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].override>
								[override]
							</cfif>
							<cftry>
								#model.rendering_obj.renderHint(localVar.methodMetadata_obj, localVar.rootPath_str, true)#
								<cfcatch type="any">
									<cfthrow message="Please review the comments in component #localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy#." detail="#cfcatch.message#">
								</cfcatch>
							</cftry>
						</div>
					</td>
					<td class="summaryTableOwnerCol">
						#model.rendering_obj.convertToLink(localVar.methods_struct.protectedMethodSummaryRows[localVar.row_num].definedBy, localVar.rootPath_str, true)#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfloop>
</table>