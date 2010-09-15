/**
	Contains the properties and functions to store and access argument metadata from CF components.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcData.CFArgument" extends="cfc.cfcData.CFMetadata" accessors="true" output="false"
{
	property name="type" type="string" hint="Argument type.";
	property name="default" type="any" hint="Default value of the type <i>type</i>.";
	property name="required" type="boolean" hint="Indicates whether the argument is required.";
}