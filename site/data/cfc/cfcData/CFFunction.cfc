/**
	Contains the properties and functions to store and access function metadata from CF components.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcData.CFFunction" extends="cfc.cfcData.CFMetadata" accessors="true" output="false"
{
	property name="access" type="string" hint="Indicates whether the function is private or public.";
	property name="returnType" type="string" hint="Variable type of function output.";
	property name="throws" type="array" hint="Array of structures of exception-type-description value pairs that are possibly thrown by the function.";
	property name="parameters" type="array" hint="Metadata concerning arguments of the function.";

	property name="inheritDoc" type="boolean" hint="Indicates whether the documentation should be copied from an identical function of an ancestor.";
	property name="returnHint" type="string" hint="Hint that accompanies the function output.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="private" type="boolean" hint="Indicates whether the function should be documented.";
	property name="related" type="string" hint="List of link expressions to related documentation pages.";
	
	public void function addThrows(required struct exception)
	{
		var throws_arr = this.getThrows();
		
		if (isNull(throws_arr))
		{
			throws_arr = arrayNew(1);
		}
		arrayAppend(throws_arr, arguments.exception);
		this.setThrows(throws_arr);
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