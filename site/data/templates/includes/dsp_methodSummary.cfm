<div class="summaryTableTitle">
	Public Methods
</div>
<div class="showHideLinks">
	<div id="hideInheritedMethod" class="hideInheritedMethod">
		<a class="showHideLink" 
			href="#methodSummary" 
			onclick="javascript:setInheritedVisible(false,'Method');">
			<img class="showHideLinkImage" src="#variables.rootPath_str#images/expanded.gif">
			Hide Inherited Public Methods</a>
	</div>
	<div id="showInheritedMethod" class="showInheritedMethod">
		<a class="showHideLink" 
			href="#methodSummary" 
			onclick="javascript:setInheritedVisible(true,'Method');">
			<img class="showHideLinkImage" src="#variables.rootPath_str#images/collapsed.gif">
			Show Inherited Public Methods</a>
	</div>
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
	<cfloop from="1" to="#arrayLen(variables.methods_arr)#" index="i">
		<cfset methodMetadata_obj = variables.methods_arr[i].metadata />
		<cfif not methodMetadata_obj.getPrivate() and methodMetadata_obj.getAccess() eq "public">
			<cfset methodSignature_str = builder_obj.convertToLink(variables.methodMetadata_obj.getReturnType(), variables.libraryRef_struct, variables.rootPath_str, true) />
			<cfset methodSignature_str &= " <a href=""" />
			<cfif variables.methods_arr[i].definedBy neq componentName_str>
				<cfset methodSignature_str &= variables.rootPath_str />
				<cfset methodSignature_str &= replace(variables.methods_arr[i].definedBy, ".", "/", "all") />
				<cfset methodSignature_str &= ".html" />
			</cfif>
			<!--- append a pound sign --->
			<cfset methodSignature_str &= chr(35) />
			<cfset methodSignature_str &= variables.methods_arr[i].name />
			<cfset methodSignature_str &= "()"" class=""signatureLink"">" />
			<cfset methodSignature_str &= variables.methods_arr[i].name />
			<cfset methodSignature_str &= "</a> (" />

			<cfset parameters_arr = variables.methodMetadata_obj.getParameters() />
			<cfset started_bool = false />
			<cfloop from="1" to="#arrayLen(variables.parameters_arr)#" index="j">
				<cfset argumentType_str = variables.parameters_arr[j].getType() />
				<cfset argumentDefault = variables.parameters_arr[j].getDefault() />
				<cfif variables.started_bool>
					<cfset methodSignature_str &= ", " />
				<cfelse>
					<cfset started_bool = true>
				</cfif>
				<cfif variables.parameters_arr[j].getRequired()>
					<cfset methodSignature_str &= "required " />
				</cfif>
				<cfset methodSignature_str &= builder_obj.convertToLink(variables.argumentType_str, variables.libraryRef_struct, variables.rootPath_str) />
				<cfset methodSignature_str &= " " />
				<cfset methodSignature_str &= variables.parameters_arr[j].getName() />
				<cfif not isNull(variables.argumentDefault)>
					<cfset methodSignature_str &= "=" />
					<cfif variables.argumentType_str eq "string">
						<cfset methodSignature_str &= """" />
						<cfset methodSignature_str &= variables.argumentDefault />
						<cfset methodSignature_str &= """" />
					<cfelseif variables.argumentType_str eq "date">
						<cfset methodSignature_str &= """" />
						<cfset methodSignature_str &= """" />
					<cfelseif variables.argumentType_str eq "numeric">
						<cfset methodSignature_str &= variables.argumentDefault />
					<cfelseif variables.argumentType_str eq "boolean">
						<cfif variables.argumentDefault>
							<cfset methodSignature_str &= "true" />
						<cfelse>
							<cfset methodSignature_str &= "false" />
						</cfif>
					<cfelseif variables.argumentType_str eq "variableName">
						<cfset methodSignature_str &= variables.argumentDefault />
					<cfelse>
						<cfset methodSignature_str &= "&lt;<i>" />
						<cfset methodSignature_str &= variables.argumentType_str />
						<cfset methodSignature_str &= "&gt;</i>" />
					</cfif>
				</cfif>
			</cfloop>
			
			<cfset methodSignature_str &= ")" />

			<cfoutput>
				<cfif variables.methods_arr[i].definedBy eq componentName_str>
					<tr class="">
						<td class="summaryTablePaddingCol">
							&nbsp;
						</td>
						<td class="summaryTableInheritanceCol">
							&nbsp;
						</td>
						<td class="summaryTableSignatureCol">
							<div class="summarySignature">
								#variables.methodSignature_str#
							</div>
							<div class="summaryTableDescription">
								#methodMetadata_obj.getShortHint()#
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
								#variables.methodSignature_str#
							</div>
							<div class="summaryTableDescription">
								#methodMetadata_obj.getShortHint()#
							</div>
						</td>
						<td class="summaryTableOwnerCol">
							#builder_obj.convertToLink(variables.methods_arr[i].definedBy, variables.libraryRef_struct, variables.rootPath_str, true)#
						</td>
					</tr>
				</cfif>
			</cfoutput>
		</cfif>
	</cfloop>
</table>