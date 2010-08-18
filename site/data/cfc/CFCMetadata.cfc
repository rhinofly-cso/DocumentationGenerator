<cfscript>
/**
	Contains the properties and functions to store and access metadata from CF components.
	
	@author Eelco Eggen
	@date
*/
component displayname="cfc.CFCMetadata" extends="fly.Object" accessors="true" output="false"
{
	property name="name" type="string" hint="Display name of the component. Must always correspond to its path.";
	property name="extends" type="string" hint="Name of the CFC that is extended by the component, or multiple in case of an interface.";
	property name="extendedBy" type="string" hint="Names of CFCs that extend the component.";
	property name="functions" type="array" hint="Metadata concerning methods of the component.";
	property name="hint" type="string" hint="Hint that accompanies the component code.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="private" type="boolean" hint="Indicates whether the component should be documented.";
}
</cfscript>