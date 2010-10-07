component
{
	this.name = "DocumentationGenerator";
	
	//TODO zet deze informatie in een los bestand
	this.customTagPaths = "C:\development\libraries\CSOShared,C:\development\libraries\RhinoflyLibrary\src,C:\development\libraries\TICC2Library\src";

	public void function onRequestStart(string target)
	{
		application["sourcePaths"] = this.customTagPaths;
		//TODO Get all of these from an external file
		application["reExcludedFolders"] = "^\."; // separate different folder REs by "|"
		application["documentRoot"] = "C:\development\docGen\test";
	}
}