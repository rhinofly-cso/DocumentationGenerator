component
{
	this.name = "DocumentationGenerator";
	this.customTagPaths = "C:\development\libraries\CSOShared";
	
	public void function onRequestStart(string target)
	{
		application["customTagPaths"] = this.customTagPaths;
		application["reExcludedFolders"] = "^\."; // separate different folder REs by "|"
	}
	
}