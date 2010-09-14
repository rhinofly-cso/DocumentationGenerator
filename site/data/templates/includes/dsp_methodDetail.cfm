<a name="methodDetail"></a>
<div class="detailSectionHeader">
	Method Detail
</div>

<cfset local.started_bool = false />

<cfloop from="1" to="#arrayLen(local.methods_struct.methodDetailItems)#" index="local.row_num">
	<cfset local.methodMetadata_obj = local.methods_struct.methodDetailItems[local.row_num].metadata />

	<cfset local.methodReturnType_str = local.methodMetadata_obj.getReturnType() />
	<cfset local.methodReturnHint_str = model.rendering_obj.renderHint(local.methodMetadata_obj, local.rootPath_str, "return") />
	<cfset local.methodThrows_arr = local.methodMetadata_obj.getThrows() />
	<cfset local.methodRelated_str = local.methodMetadata_obj.getRelated() />

	<cfset local.methodSignature_str = local.methodMetadata_obj.getAccess() />
	<cfset local.methodSignature_str &= " " />
	<cfset local.methodSignature_str &= model.rendering_obj.convertToLink(local.methodReturnType_str, local.rootPath_str, true) />
	<cfif local.methods_struct.methodDetailItems[local.row_num].override>
		<cfset local.methodSignature_str &= " override" />
	</cfif>
	<cfset local.methodSignature_str &= " function " />
	<cfset local.methodSignature_str &= local.methods_struct.methodDetailItems[local.row_num].name />

	<cfset local.methodSignature_str &= "(" />
	<cfset local.parameters_arr = local.methodMetadata_obj.getParameters() />
	<cfset local.paramStarted_bool = false />
	<cfloop from="1" to="#arrayLen(local.parameters_arr)#" index="local.param_num">
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
		<a name="#local.methods_struct.methodDetailItems[local.row_num].name#()"></a>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
					#local.methods_struct.methodDetailItems[local.row_num].name#
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
				#model.rendering_obj.renderHint(local.methodMetadata_obj, local.rootPath_str)#
			</p>
			<cfif arrayLen(local.parameters_arr) gt 0>
				<p>
					<span class="label">Parameters</span>
					<table cellpadding="0" cellspacing="0" border="0">
						<cfloop from="1" to="#arrayLen(local.parameters_arr)#" index="local.param_num">
							<cfset local.argumentHint_str = model.rendering_obj.renderHint(local.parameters_arr[local.param_num], local.rootPath_str) />
							<tr>
								<td width="20px"></td>
								<td>
									<code>#local.parameters_arr[local.param_num].getType()# #local.parameters_arr[local.param_num].getName()#</code>
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
								<cfif len(local.methodReturnHint_str) gt 0>
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
							<cfset local.throwsHint_str = model.rendering_obj.renderHint(local.methodThrows_arr[local.throws_num], local.rootPath_str, "throws") />
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
</cfloop>