component
{
	this.name = "DocumentationGenerator";
	this.customTagPaths = "C:\development\libraries\CSOShared,C:\development\libraries\RhinoflyLibrary\src,C:\development\libraries\TICC2Library\src";

	public void function onRequestStart(string target)
	{
		application["customTagPaths"] = this.customTagPaths;
		application["reExcludedFolders"] = "^\."; // separate different folder REs by "|"
		application["documentRoot"] = "C:\development\docGen\test";
	}
}