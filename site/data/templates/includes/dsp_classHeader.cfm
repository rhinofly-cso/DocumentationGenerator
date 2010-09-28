<!--- 
	Creates rows for the component-detail table including the package and component/interface 
	name. The following variables are defined in the local scope in componentDetail.cfm: 
	componentName_str, componentPage_str, packageName_str, packagePath_str, rootPath_str, and 
	type_str
 --->
<cfset localVar.extends_str = model.cfMetadata_obj.getExtends() />
<cfset localVar.extendedBy_str = model.cfMetadata_obj.getExtendedBy() />

<cfif localVar.type_str eq "Component">
	<cfset localVar.implements_str = model.cfMetadata_obj.getImplements() />
</cfif>
<cfif localVar.type_str eq "Interface">
	<cfset localVar.implementedBy_str = model.cfMetadata_obj.getImplementedBy() />
</cfif>

<cfset localVar.author_str = model.cfMetadata_obj.getAuthor() />
<cfset localVar.date_str = model.cfMetadata_obj.getDate() />
<cftry>
	<cfset localVar.hint_str = model.rendering_obj.renderHint(model.cfMetadata_obj, localVar.rootPath_str) />
	<cfcatch type="any">
		<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
	</cfcatch>
</cftry>
<cfset localVar.related_str = model.cfMetadata_obj.getRelated() />

<cfset localVar.extendsLinks_str = "" />

<cfif isInstanceOf(model.cfMetadata_obj, "cfc.cfcData.CFPersistentComponent")>
	<cfset localVar.ormAttributes_arr = getMetadata(model.cfMetadata_obj).properties />
</cfif>

<!--- append the component description with inheritance info for interfaces --->
<cfif localVar.type_str eq "Interface" and not isNull(localVar.extends_str)>
	<cfset localVar.started_bool = false />
	<cfset localVar.extendsLinks_str = " extends " />
	<cfloop list="#localVar.extends_str#" index="localVar.parent_str">
		<cfif localVar.started_bool>
			<cfset localVar.extendsLinks_str &= ", " />
		<cfelse>
			<cfset localVar.started_bool = true>
		</cfif>
		<cfset localVar.extendsLinks_str &= model.rendering_obj.convertToLink(localVar.parent_str, localVar.rootPath_str, true) />
	</cfloop>
</cfif>

<!--- render the links in the part "See Also" --->
<cfset localVar.relatedLinks_str = "" />
<cfif not isNull(localVar.related_str)>
	<cfset localVar.started_bool = false />
	<cfloop list="#localVar.related_str#" index="localVar.component_str">
		<cfset localVar.componentRelated_str = model.rendering_obj.convertToLink(trim(localVar.component_str), localVar.rootPath_str, true, true) />
		<cfif not isNull(localVar.componentRelated_str)>
			<cfif localVar.started_bool>
				<cfset localVar.relatedLinks_str &= ", " />
			<cfelse>
				<cfset localVar.started_bool = true />
			</cfif>
			<cfset localVar.relatedLinks_str &= localVar.componentRelated_str />
		</cfif>
	</cfloop>
</cfif>

<table class="classHeaderTable" cellpadding="0" cellspacing="0">
	<cfoutput>
		<tr>
			<td class="classHeaderTableLabel">
				Package
			</td>
			<td>
				<a href="package-detail.html"
					onclick="javascript:loadClassListFrame('class-list.html')">
					#localVar.packageName_str#</a>
			</td>
		</tr>
		<tr>
			<td class="classHeaderTableLabel">
				#localVar.type_str#
			</td>
			<td class="classSignature">
				#listLast(localVar.componentName_str, ".") & localVar.extendsLinks_str#
			</td>
		</tr>
	</cfoutput>
	
	<!--- display inheritance info for components --->
	<cfif localVar.type_str eq "Component" and not isNull(localVar.extends_str)>
		<cfset localVar.inheritance_str = listLast(localVar.componentName_str, ".") />
		<cfset localVar.parent_str = localVar.extends_str />
		<cfloop condition="true">
			<cfset localVar.inheritance_str &= " <img src=""" />
			<cfset localVar.inheritance_str &= localVar.rootPath_str />
			<cfset localVar.inheritance_str &= "images/inherit-arrow.gif"" title=""Inheritance"" alt=""Inheritance"" class=""inheritArrow""> " />
			<cfset localVar.inheritance_str &= model.rendering_obj.convertToLink(localVar.parent_str, localVar.rootPath_str, true) />
	
			<!--- break the loop if either the ancestor is not present in the library --->
			<cfif structKeyExists(model.libraryRef_struct, localVar.parent_str)>
				<cfset localVar.parent_str = model.libraryRef_struct[localVar.parent_str].getExtends() />
				<!--- if for some reason, the ancestor doesn't extend anything, we break the loop --->
				<cfif isNull(localVar.parent_str)>
					<cfbreak />
				</cfif>
			<cfelse>
				<cfbreak />
			</cfif>
		</cfloop>
	
		<tr>
			<td class="classHeaderTableLabel">
				Inheritance
			</td>
			<td class="inheritanceList">
				<cfoutput>#localVar.inheritance_str#</cfoutput>	
			</td>
		</tr>
	</cfif>
		
	<cfif localVar.type_str eq "Component" and not isNull(localVar.implements_str)>
		<cfset localVar.started_bool = false />
		<cfset localVar.implementsLinks_str = "" />
		<cfloop list="#localVar.implements_str#" index="localVar.interface_str">
			<cfif localVar.started_bool>
				<cfset localVar.implementsLinks_str &= ", " />
			<cfelse>
				<cfset localVar.started_bool = true>
			</cfif>
			<cfset localVar.implementsLinks_str &= model.rendering_obj.convertToLink(localVar.interface_str, localVar.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Implements
			</td>
			<td>
				<cfoutput>#localVar.implementsLinks_str#</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfif localVar.type_str eq "Interface" and not isNull(localVar.implementedBy_str)>
		<cfset localVar.started_bool = false />
		<cfset localVar.implementorsLinks_str = "" />
		<cfloop list="#localVar.implementedBy_str#" index="localVar.component_str">
			<cfif localVar.started_bool>
				<cfset localVar.implementorsLinks_str &= ", " />
			<cfelse>
				<cfset localVar.started_bool = true>
			</cfif>
			<cfset localVar.implementorsLinks_str &= model.rendering_obj.convertToLink(localVar.component_str, localVar.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Implementors
			</td>
			<td>
				<cfoutput>#localVar.implementorsLinks_str#</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfif not isNull(localVar.extendedBy_str)>
		<cfset localVar.started_bool = false />
		<cfset localVar.subclassesLinks_str = "" />
		<cfloop list="#localVar.extendedBy_str#" index="localVar.child_str">
			<cfif localVar.started_bool>
				<cfset localVar.subclassesLinks_str &= ", " />
			<cfelse>
				<cfset localVar.started_bool = true>
			</cfif>
			<cfset localVar.subclassesLinks_str &= model.rendering_obj.convertToLink(localVar.child_str, localVar.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Subclasses
			</td>
			<td>
				<cfoutput>#localVar.subclassesLinks_str#</cfoutput>
			</td>
		</tr>
	</cfif>

	<cfif localVar.type_str eq "Component">
		<cfif not model.cfMetadata_obj.getSerializable()>
			<tr>
				<td class="classHeaderTableLabel">
					Not serializable
				</td>
			</tr>
		</cfif>
	</cfif>
	
	<cfif isInstanceOf(model.cfMetadata_obj, "cfc.cfcData.CFPersistentComponent")>
		<tr>
			<td class="classHeaderTableLabel">
				ORM attributes
			</td>
			<td>
				<ul class="classHeaderCodeList">
					<cfset localVar.started_bool = false />
					<cfloop from="1" to="#arrayLen(localVar.ormAttributes_arr)#" index="localVar.row_num">
						<cfset localVar.attributeName_str = localVar.ormAttributes_arr[localVar.row_num].name />
						<cfinvoke component="#model.cfMetadata_obj#" method="get#localVar.attributeName_str#" returnvariable="localVar.attributeValue" />
						<cfif not isNull(localVar.attributeValue)>
							<cfset localVar.started_bool = true />
							<cfoutput>
								<li class="codeListItem"><code>#localVar.attributeName_str#="#localVar.attributeValue#";</code></li>
							</cfoutput>
						</cfif>
					</cfloop>
					<cfif not localVar.started_bool>
						<li>&lt;<i>none</i>&gt;</li>
					</cfif>
				</ul>
			</td>
		</tr>
	</cfif>
	
	<cfif not isNull(localVar.author_str)>
		<tr>
			<td class="classHeaderTableLabel">
				Author
			</td>
			<td>
				<cfoutput>#localVar.author_str#</cfoutput>
			</td>
		</tr>
	</cfif>
	<cfif not isNull(localVar.date_str)>
		<tr>
			<td class="classHeaderTableLabel">
				Date
			</td>
			<td>
				<cfoutput>#localVar.date_str#</cfoutput>
			</td>
		</tr>
	</cfif>
</table>

<cfif len(localVar.hint_str) gt 0>
	<p>
		<cfoutput>#localVar.hint_str#</cfoutput>
	</p>
</cfif>

<cfif len(localVar.relatedLinks_str) gt 0>
		<p>
			<span class="classHeaderTableLabel">See also</span>
		</p>
		<div class="seeAlso">
			<cfoutput>#localVar.relatedLinks_str#</cfoutput>
		</div>
</cfif>