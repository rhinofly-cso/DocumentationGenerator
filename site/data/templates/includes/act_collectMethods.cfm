<cfset local.methodSummaryRows_str = "" />
<cfset local.protectedMethodSummaryRows_str = "" />
<cfset local.methodDetailItems_str = "" />
<cfset local.nonInheritedMethods_bool = false />
<cfset local.publicMethods_bool = false />
<cfset local.privateMethods_bool = false />
<cfset local.started_bool = false />

<cfloop from="1" to="#arrayLen(model.methods_arr)#" index="local.row_num">
	<cfset local.methodMetadata_obj = model.methods_arr[local.row_num].metadata />

	<!--- TODO: move to DocumentBuilder --->
	<cfset model.rendering_obj.parseObjectHint(local.methodMetadata_obj, model.libraryRef_struct, local.rootPath_str) />

	<cfset local.methodSignature_str = model.rendering_obj.convertToLink(local.methodMetadata_obj.getReturnType(), local.rootPath_str, true) />
	<cfset local.methodSignature_str &= " <a href=""" />
	<cfif variables.methods_arr[local.row_num].definedBy neq local.componentName_str>
		<cfset local.methodSignature_str &= local.rootPath_str />
		<cfset local.methodSignature_str &= replace(model.methods_arr[local.row_num].definedBy, ".", "/", "all") />
		<cfset local.methodSignature_str &= ".html" />
	<cfelse>
		<cfset nonInheritedMethods_bool = true />
	</cfif>
	<!--- append a pound sign --->
	<cfset local.methodSignature_str &= chr(35) />
	<cfset local.methodSignature_str &= model.methods_arr[local.row_num].name />
	<cfset local.methodSignature_str &= "()"" class=""signatureLink"">" />
	<cfset local.methodSignature_str &= model.methods_arr[local.row_num].name />
	<cfset local.methodSignature_str &= "</a>" />

	<cfset local.argumentSignature_str = "(" />
	<cfset local.parameters_arr = local.methodMetadata_obj.getParameters() />
	<cfset local.paramStarted_bool = false />
	<cfloop from="1" to="#arrayLen(local.parameters_arr)#" index="local.param_num">
		<cfset model.rendering_obj.parseObjectHint(local.parameters_arr[local.param_num], model.libraryRef_struct, local.rootPath_str) />
		<cfset local.argumentType_str = local.parameters_arr[local.param_num].getType() />
		<cfset local.argumentDefault = local.parameters_arr[local.param_num].getDefault() />
		<cfif local.paramStarted_bool>
			<cfset local.argumentSignature_str &= ", " />
		<cfelse>
			<cfset local.paramStarted_bool = true>
		</cfif>
		<cfif local.parameters_arr[local.param_num].getRequired()>
			<cfset local.argumentSignature_str &= "required " />
		</cfif>
		<cfset local.argumentSignature_str &= local.rendering_obj.convertToLink(local.argumentType_str, local.rootPath_str, true) />
		<cfset local.argumentSignature_str &= " " />
		<cfset local.argumentSignature_str &= local.parameters_arr[local.param_num].getName() />
		<cfif not isNull(local.argumentDefault)>
			<cfset local.argumentSignature_str &= "=" />
			<cfif local.argumentType_str eq "string">
				<cfset local.argumentSignature_str &= """" />
				<cfset local.argumentSignature_str &= local.argumentDefault />
				<cfset local.argumentSignature_str &= """" />
			<cfelseif local.argumentType_str eq "date">
				<cfset local.argumentSignature_str &= """" />
				<cfset local.argumentSignature_str &= """" />
			<cfelseif local.argumentType_str eq "numeric">
				<cfset local.argumentSignature_str &= local.argumentDefault />
			<cfelseif local.argumentType_str eq "boolean">
				<cfif local.argumentDefault>
					<cfset local.argumentSignature_str &= "true" />
				<cfelse>
					<cfset local.argumentSignature_str &= "false" />
				</cfif>
			<cfelseif local.argumentType_str eq "variableName">
				<cfset local.argumentSignature_str &= local.argumentDefault />
			<cfelse>
				<cfset local.argumentSignature_str &= "&lt;<i>" />
				<cfset local.argumentSignature_str &= local.argumentType_str />
				<cfset local.argumentSignature_str &= "</i>&gt;" />
			</cfif>
		</cfif>
	</cfloop>
	<cfset local.argumentSignature_str &= ")" />
	
	<cfset local.methodSignature_str &= local.argumentSignature_str />

	<cfif local.methodMetadata_obj.getAccess() eq "public">
		<cfset local.publicMethods_bool = true />

		<cfsavecontent variable="local.methodSummaryRows_str">
			<cfoutput>
				#local.methodSummaryRows_str#
				<cfif model.methods_arr[local.row_num].definedBy eq local.componentName_str>
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
								#local.methodMetadata_obj.getShortHint()#
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
								<cfif model.methods_arr[i].override>
									[override]
								</cfif>
								#local.methodMetadata_obj.getShortHint()#
							</div>
						</td>
						<td class="summaryTableOwnerCol">
							#model.rendering_obj.convertToLink(model.methods_arr[local.row_num].definedBy, local.rootPath_str, true)#
						</td>
					</tr>
				</cfif>
			</cfoutput>
		</cfsavecontent>

	<cfelseif model.methods_arr[local.row_num].metadata.getAccess() eq "private">
		<cfset local.privateMethods_bool = true />

		<cfsavecontent variable="local.protectedMethodSummaryRows_str">
			<cfoutput>
				#local.protectedMethodSummaryRows_str#
				<cfif model.methods_arr[local.row_num].definedBy eq local.componentName_str>
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
								#local.methodMetadata_obj.getShortHint()#
							</div>
						</td>
						<td class="summaryTableOwnerCol">
							#listLast(local.componentName_str, ".")#
						</td>
					</tr>
				<cfelse>
					<tr class="hideInheritedProtectedMethod">
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
								#local.methodMetadata_obj.getShortHint()#
							</div>
						</td>
						<td class="summaryTableOwnerCol">
							#local.rendering_obj.convertToLink(model.methods_arr[local.row_num].definedBy, local.rootPath_str, true)#
						</td>
					</tr>
				</cfif>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	
	<cfif model.methods_arr[local.row_num].definedBy eq local.componentName_str>
		<cfset local.methodReturnType_str = local.methodMetadata_obj.getReturnType() />
		<cfset local.methodReturnHint_str = local.methodMetadata_obj.getReturnHint() />
		<cfset local.methodThrows_arr = local.methodMetadata_obj.getThrows() />
		<cfset local.methodRelated_str = local.methodMetadata_obj.getRelated() />
		<cfset local.methodSignature_str = local.methodMetadata_obj.getAccess() />
		<cfset local.methodSignature_str &= " " />
		<cfset local.methodSignature_str &= model.rendering_obj.convertToLink(local.methodReturnType_str, local.rootPath_str, true) />
		<cfif model.methods_arr[local.row_num].override>
			<cfset local.methodSignature_str &= " override" />
		</cfif>
		<cfset local.methodSignature_str &= " function " />
		<cfset local.methodSignature_str &= model.methods_arr[local.row_num].name />

		<cfset local.methodSignature_str &= local.argumentSignature_str />

		<cfsavecontent variable="local.methodDetailItems_str">
			<cfoutput>
				#local.methodDetailItems_str#
				<a name="#model.methods_arr[local.row_num].name#()"></a>
				<table class="detailHeader" cellpadding="0" cellspacing="0">
					<tr>
						<td class="detailHeaderName">
							#model.methods_arr[local.row_num].name#
						</td>
						<td class="detailHeaderParens">
							()
						</td>
						<td class="detailHeaderType">
							method
						</td>
						<cfif local.started_bool>
							<td class="detailHeaderRule"></td>
						<cfelse>
							<cfset local.started_bool = true />
						</cfif>
					</tr>
				</table>
				<div class="detailBody">
					<code>#local.methodSignature_str#</code>
					<p>
						#local.methodMetadata_obj.getHint()#
					</p>
					<cfif arrayLen(model.parameters_arr) gt 0>
						<p>
							<span class="label">Parameters</span>
							<table cellpadding="0" cellspacing="0" border="0">
								<cfloop from="1" to="#arrayLen(model.parameters_arr)#" index="local.param_num">
									<cfset local.argumentHint_str = variables.parameters_arr[local.param_num].getHint() />
									<tr>
										<td width="20px"></td>
										<td>
											<code>#model.parameters_arr[local.param_num].getType()# #model.parameters_arr[local.param_num].getName()#</code>
											<cfif len(local.argumentHint_str) gt 0>
												&mdash; #local.argumentHint_str#
											</cfif>
										</td>
									</tr>
								</cfloop>
							<table>
						</p>
					</cfif>
					<cfif local.methodReturnType_str neq "void">
						<p>
							<span class="label">Returns</span>
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td width="20px"></td>
									<td>
										<code>#model.rendering_obj.convertToLink(local.methodReturnType_str, local.rootPath_str, true)#</code>
										<cfif not isNull(local.methodReturnHint_str)>
											&mdash; #local.methodReturnHint_str#
										</cfif>
									</td>
								</tr>
							<table>
						</p>
					</cfif>
					<cfif not isNull(local.methodThrows_arr)>
						<p>
							<span class="label">Throws</span>
							<table cellpadding="0" cellspacing="0" border="0">
								<cfloop from="1" to="#arrayLen(local.methodThrows_arr)#" index="local.throws_num">
									<cfset local.throwsHint_str = local.methodThrows_arr[local.throws_num].description />
									<tr>
										<td width="20px"></td>
										<td>
											<code>#local.methodThrows_arr[local.throws_num].type#</code>
											<cfif len(local.throwsHint_str) gt 0>
												&mdash; #local.throwsHint_str#
											</cfif>
										</td>
									</tr>
								</cfloop>
							<table>
						</p>
					</cfif>
					<cfif not isNull(local.methodRelated_str)>
						<cfset local.relatedStarted_bool = false />
						<cfset local.relatedLinks_str = "" />
						<cfloop list="#local.methodRelated_str#" index="local.component_str">
							<cfset local.methodRelated_str = model.rendering_obj.convertToLink(trim(local.component_str), local.rootPath_str, true, true) />
							<cfif not isNull(local.methodRelated_str)>
								<cfif local.relatedStarted_bool>
									<cfset local.relatedLinks_str &= ", " />
								<cfelse>
									<cfset local.relatedStarted_bool = true />
								</cfif>
								<cfset local.relatedLinks_str &= local.methodRelated_str />
							</cfif>
						</cfloop>
						<cfif len(local.relatedLinks_str) gt 0>
							<p>
								<span class="label">See also</span>
							</p>
							<div class="seeAlso">
								#local.relatedLinks_str#
							</div>
						</cfif>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
</cfloop>