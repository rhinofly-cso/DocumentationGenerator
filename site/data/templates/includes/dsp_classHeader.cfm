<!--- 
	Creates rows for the component-detail table including the package and component/interface 
	name. The following variables are defined in the local scope in componentDetail.cfm: 
	componentName_str, componentPage_str, packageName_str, packagePath_str, rootPath_str, and 
	type_str
 --->
<cfset local.extends_str = model.cfMetadata_obj.getExtends() />
<cfset local.extendedBy_str = model.cfMetadata_obj.getExtendedBy() />

<cfif local.type_str eq "Component">
	<cfset local.implements_str = model.cfMetadata_obj.getImplements() />
</cfif>
<cfif local.type_str eq "Interface">
	<cfset local.implementedBy_str = model.cfMetadata_obj.getImplementedBy() />
</cfif>

<cfset local.author_str = model.cfMetadata_obj.getAuthor() />
<cfset local.date_str = model.cfMetadata_obj.getDate() />
<cftry>
	<cfset local.hint_str = model.rendering_obj.renderHint(model.cfMetadata_obj, local.rootPath_str) />
	<cfcatch type="any">
		<cfthrow message="Please review the comments in component #local.componentName_str#." detail="#cfcatch.message#">
	</cfcatch>
</cftry>
<cfset local.related_str = model.cfMetadata_obj.getRelated() />

<cfset local.extendsLinks_str = "" />

<!--- append the component description with inheritance info for interfaces --->
<cfif local.type_str eq "Interface" and not isNull(local.extends_str)>
	<cfset local.started_bool = false />
	<cfset local.extendsLinks_str = " extends " />
	<cfloop list="#local.extends_str#" index="local.parent_str">
		<cfif local.started_bool>
			<cfset local.extendsLinks_str &= ", " />
		<cfelse>
			<cfset local.started_bool = true>
		</cfif>
		<cfset local.extendsLinks_str &= model.rendering_obj.convertToLink(local.parent_str, local.rootPath_str, true) />
	</cfloop>
</cfif>

<!--- render the links in the part "See Also" --->
<cfset local.relatedLinks_str = "" />
<cfif not isNull(local.related_str)>
	<cfset local.started_bool = false />
	<cfloop list="#local.related_str#" index="local.component_str">
		<cfset local.componentRelated_str = model.rendering_obj.convertToLink(trim(local.component_str), local.rootPath_str, true, true) />
		<cfif not isNull(local.componentRelated_str)>
			<cfif local.started_bool>
				<cfset local.relatedLinks_str &= ", " />
			<cfelse>
				<cfset local.started_bool = true />
			</cfif>
			<cfset local.relatedLinks_str &= local.componentRelated_str />
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
					#local.packageName_str#</a>
			</td>
		</tr>
		<tr>
			<td class="classHeaderTableLabel">
				#local.type_str#
			</td>
			<td class="classSignature">
				#listLast(local.componentName_str, ".") & local.extendsLinks_str#
			</td>
		</tr>
	</cfoutput>
	
	<!--- display inheritance info for components --->
	<cfif local.type_str eq "Component" and not isNull(local.extends_str)>
		<cfset local.inheritance_str = listLast(local.componentName_str, ".") />
		<cfset local.parent_str = local.extends_str />
		<cfloop condition="true">
			<cfset local.inheritance_str &= " <img src=""" />
			<cfset local.inheritance_str &= local.rootPath_str />
			<cfset local.inheritance_str &= "images/inherit-arrow.gif"" title=""Inheritance"" alt=""Inheritance"" class=""inheritArrow""> " />
			<cfset local.inheritance_str &= model.rendering_obj.convertToLink(local.parent_str, local.rootPath_str, true) />
	
			<!--- break the loop if either the ancestor is not present in the library --->
			<cfif structKeyExists(model.libraryRef_struct, local.parent_str)>
				<cfset local.parent_str = model.libraryRef_struct[local.parent_str].getExtends() />
				<!--- if for some reason, the ancestor doesn't extend anything, we break the loop --->
				<cfif isNull(local.parent_str)>
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
				<cfoutput>#local.inheritance_str#</cfoutput>	
			</td>
		</tr>
	</cfif>
		
	<cfif local.type_str eq "Component" and not isNull(local.implements_str)>
		<cfset local.started_bool = false />
		<cfset local.implements_str = "" />
		<cfloop list="#local.implements_str#" index="local.interface_str">
			<cfif local.started_bool>
				<cfset local.implements_str &= ", " />
			<cfelse>
				<cfset local.started_bool = true>
			</cfif>
			<cfset local.implements_str &= model.rendering_obj.convertToLink(local.interface_str, local.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Implements
			</td>
			<td>
				<cfoutput>#local.implements_str#</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfif local.type_str eq "Interface" and not isNull(local.implementedBy_str)>
		<cfset local.started_bool = false />
		<cfset local.implementorsLinks_str = "" />
		<cfloop list="#local.implementedBy_str#" index="local.component_str">
			<cfif local.started_bool>
				<cfset local.implementorsLinks_str &= ", " />
			<cfelse>
				<cfset local.started_bool = true>
			</cfif>
			<cfset local.implementorsLinks_str &= model.rendering_obj.convertToLink(local.component_str, local.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Implementors
			</td>
			<td>
				<cfoutput>#local.implementorsLinks_str#</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfif not isNull(local.extendedBy_str)>
		<cfset local.started_bool = false />
		<cfset local.subclassesLinks_str = "" />
		<cfloop list="#local.extendedBy_str#" index="local.child_str">
			<cfif local.started_bool>
				<cfset local.subclassesLinks_str &= ", " />
			<cfelse>
				<cfset local.started_bool = true>
			</cfif>
			<cfset local.subclassesLinks_str &= model.rendering_obj.convertToLink(local.child_str, local.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Subclasses
			</td>
			<td>
				<cfoutput>#local.subclassesLinks_str#</cfoutput>
			</td>
		</tr>
	</cfif>

	<cfif not model.cfMetadata_obj.getSerializable()>
		<tr>
			<td class="classHeaderTableLabel">
				Not serializable
			</td>
		</tr>
	</cfif>
	
	<cfif not isNull(local.author_str)>
		<tr>
			<td class="classHeaderTableLabel">
				Author
			</td>
			<td>
				<cfoutput>#local.author_str#</cfoutput>
			</td>
		</tr>
	</cfif>
	<cfif not isNull(local.date_str)>
		<tr>
			<td class="classHeaderTableLabel">
				Date
			</td>
			<td>
				<cfoutput>#local.date_str#</cfoutput>
			</td>
		</tr>
	</cfif>
</table>

<cfif len(local.hint_str) gt 0>
	<p>
		<cfoutput>#local.hint_str#</cfoutput>
	</p>
</cfif>

<cfif len(local.relatedLinks_str) gt 0>
		<p>
			<span class="classHeaderTableLabel">See also</span>
		</p>
		<div class="seeAlso">
			<cfoutput>#local.relatedLinks_str#</cfoutput>
		</div>
</cfif>