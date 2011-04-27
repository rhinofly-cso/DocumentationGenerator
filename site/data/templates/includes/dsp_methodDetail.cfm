<div class="detailSectionHeader">
	Method Detail
</div>

<cfset localVar.started_bool = false />

<cfloop from="1" to="#arrayLen(localVar.methods_struct.methodDetailItems)#" index="localVar.row_num">
	<cfset localVar.methodMetadata_obj = localVar.methods_struct.methodDetailItems[localVar.row_num].metadata />

	<cfset localVar.methodReturnType_str = localVar.methodMetadata_obj.getReturnType() />
	<cftry>
		<cfset localVar.methodReturnHint_str = renderHint(localVar.methodMetadata_obj, localVar.rootPath_str, "return") />
		<cfcatch type="any">
			<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
		</cfcatch>
	</cftry>
	<cfset localVar.methodThrows_arr = localVar.methodMetadata_obj.getThrows() />
	<cfset localVar.methodRelated_str = localVar.methodMetadata_obj.getRelated() />

	<cfset localVar.methodSignature_str = localVar.methodMetadata_obj.getAccess() />
	<cfset localVar.methodSignature_str &= " " />
	<cfset localVar.methodSignature_str &= renderLink(localVar.methodReturnType_str, localVar.rootPath_str, true) />
	<cfif localVar.methods_struct.methodDetailItems[localVar.row_num].override>
		<cfset localVar.methodSignature_str &= " override" />
	</cfif>
	<cfset localVar.methodSignature_str &= " function " />
	<cfset localVar.methodSignature_str &= localVar.methods_struct.methodDetailItems[localVar.row_num].name />

	<cfset localVar.methodSignature_str &= "(" />
	<cfset localVar.parameters_arr = localVar.methodMetadata_obj.getParameters() />
	<cfset localVar.paramStarted_bool = false />
	<cfloop from="1" to="#arrayLen(localVar.parameters_arr)#" index="localVar.param_num">
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
		<cfset localVar.methodSignature_str &= renderLink(localVar.argumentType_str, localVar.rootPath_str, true) />
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
		<a name="#localVar.methods_struct.methodDetailItems[localVar.row_num].name#()"></a>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
					#localVar.methods_struct.methodDetailItems[localVar.row_num].name#
				</td>
				<td class="detailHeaderParens">
					()
				</td>
				<cfif localVar.started_bool>
					<td class="detailHeaderRule"></td>
				<cfelse>
					<cfset localVar.started_bool = true />
				</cfif>
			</tr>
		</table>
		<div class="detailBody">
			<code>#localVar.methodSignature_str#</code>
			<cftry>
				<p>
					#renderHint(localVar.methodMetadata_obj, localVar.rootPath_str)#
				</p>
				<cfcatch type="any">
					<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
				</cfcatch>
			</cftry>
			<cfif arrayLen(localVar.parameters_arr) gt 0>
				<p>
					<span class="label">Parameters</span>
					<ul class="paddedList">
						<cfloop from="1" to="#arrayLen(localVar.parameters_arr)#" index="localVar.param_num">
							<cftry>
								<cfset localVar.argumentHint_str = renderHint(localVar.parameters_arr[localVar.param_num], localVar.rootPath_str) />
								<cfcatch type="any">
									<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
								</cfcatch>
							</cftry>
							<li>
								<code>#renderLink(localVar.parameters_arr[localVar.param_num].getType(), localVar.rootPath_str, true)# #localVar.parameters_arr[localVar.param_num].getName()#</code>
								<cfif len(localVar.argumentHint_str) gt 0>
									&mdash; #localVar.argumentHint_str#
								</cfif>
							</li>
						</cfloop>
					</ul>
				</p>
			</cfif>
			<cfif localVar.methodReturnType_str neq "void">
				<p>
					<span class="label">Returns</span>
					<ul class="paddedList">
						<li>
							<code>#renderLink(localVar.methodReturnType_str, localVar.rootPath_str, true)#</code>
							<cfif len(localVar.methodReturnHint_str) gt 0>
								&mdash; #localVar.methodReturnHint_str#
							</cfif>
						</li>
					</ul>
				</p>
			</cfif>
			<cfif not isNull(localVar.methodThrows_arr)>
				<p>
					<span class="label">Throws</span>
					<ul class="paddedList">
						<cfloop from="1" to="#arrayLen(localVar.methodThrows_arr)#" index="localVar.throws_num">
							<cftry>
								<cfset localVar.throwsHint_str = renderHint(localVar.methodThrows_arr[localVar.throws_num], localVar.rootPath_str) />
								<cfcatch type="any">
									<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
								</cfcatch>
							</cftry>
							<li>
								<code>#localVar.methodThrows_arr[localVar.throws_num].getName()#</code>
								<cfif len(localVar.throwsHint_str) gt 0>
									&mdash; #localVar.throwsHint_str#
								</cfif>
							</li>
						</cfloop>
					</ul>
				</p>
			</cfif>
			<cfif not isNull(localVar.methodRelated_str)>
				<cfset localVar.relatedStarted_bool = false />
				<cfset localVar.relatedLinks_str = "" />
				<cfloop list="#localVar.methodRelated_str#" index="localVar.component_str">
					<cfset localVar.methodRelated_str = renderLink(trim(localVar.component_str), localVar.rootPath_str, true, true) />
					<cfif not isNull(localVar.methodRelated_str)>
						<cfif localVar.relatedStarted_bool>
							<cfset localVar.relatedLinks_str &= ", " />
						<cfelse>
							<cfset localVar.relatedStarted_bool = true />
						</cfif>
						<cfset localVar.relatedLinks_str &= localVar.methodRelated_str />
					</cfif>
				</cfloop>
				<cfif len(localVar.relatedLinks_str) gt 0>
					<p>
						<span class="label">See also</span>
					</p>
					<div class="seeAlso">
						#localVar.relatedLinks_str#
					</div>
				</cfif>
			</cfif>
		</div>
	</cfoutput>
</cfloop>