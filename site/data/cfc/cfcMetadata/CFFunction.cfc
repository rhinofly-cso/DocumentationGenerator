/**
	Contains the properties and functions to store and access function metadata from CF components.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcMetadata.CFFunction" extends="fly.Object" accessors="true" output="false"
{
	property name="name" type="string" hint="Name of the function.";
	property name="access" type="string" hint="Indicates whether the function is private or public.";
	property name="returnType" type="string" hint="Variable type of function output.";
	property name="throws" type="string" hint="List of exception types that are possibly thrown by the function.";
	property name="parameters" type="array" hint="Metadata concerning arguments of the function.";

	property name="inheritDoc" type="boolean" hint="Indicates whether the documentation should be copied from an identical function of an ancestor.";
	property name="hint" type="string" hint="Hint or description that accompanies the function in the component code.";
	property name="returnHint" type="string" hint="Hint that accompanies the function output.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="private" type="boolean" hint="Indicates whether the function should be documented.";
	property name="related" type="string" hint="List of link expressions to related documentation pages.";
	
	public void function addThrows(required string exception)
	{
		var throws_str = this.getThrows();
		
		if (isNull(throws_str))
		{
			throws_str = "";
		}
		throws_str = listAppend(throws_str, arguments.exception);
		this.setThrows(throws_str);
	}

	public void function addRelated(required string link)
	{
		var related_str = this.getRelated();
		
		if (isNull(related_str))
		{
			related_str = "";
		}
		related_str = listAppend(related_str, arguments.link);
		this.setRelated(related_str);
	}
}