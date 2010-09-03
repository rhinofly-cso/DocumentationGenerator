/**
	Contains the properties and functions to store and access argument metadata from functions.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcMetadata.CFArgument" extends="fly.Object" accessors="true" output="false"
{
	property name="name" type="string" hint="Name of the argument.";
	property name="type" type="string" hint="Argument type.";
	property name="default" type="any" hint="Default value of the type <i>type</i>.";
	property name="required" type="boolean" hint="Indicates whether the argument is required.";
	property name="hint" type="string" hint="Hint that accompanies the argument in the component code.";
}