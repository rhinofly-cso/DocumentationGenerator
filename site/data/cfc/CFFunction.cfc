<cfscript>
/**
	Contains the properties and functions to store and access function metadata from CF components.
	
	@author Eelco Eggen
	@date
*/
component displayname="cfc.CFFunction" extends="fly.Object" accessors="true" output="false"
{
	property name="name" type="string" hint="Name of the function.";
	property name="returnType" type="string" hint="Variable type of function output.";
	property name="throws" type="string" hint="List of exception types that are possibly thrown by the function.";
	property name="acces" type="string" hint="Indicates whether the function is private or public.";

	property name="hint" type="string" hint="Hint or description that accompanies the component code.";
	property name="returnHint" type="string" hint="Hint that accompanies the function output.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="private" type="boolean" hint="Indicates whether the component should be documented.";
	property name="related" type="string" hint="List of link expressions to related documentation pages.";
}
</cfscript>