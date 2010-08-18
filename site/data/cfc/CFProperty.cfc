<cfscript>
/**
	Contains the properties and functions to store and access property metadata from CF components.
	
	@author Eelco Eggen
	@date
*/
component displayname="cfc.CFProperty" extends="fly.Object" accessors="true" output="false"
{
	property name="name" type="string" hint="Name of the property.";
	property name="type" type="string" hint="Variable type of the property.";
	property name="serializable" type="boolean" hint="Indicates whether the property is serializable.";
	property name="hint" type="string" hint="Hint that accompanies the component code.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="related" type="string" hint="List of link expressions to related documentation pages.";
}
</cfscript>