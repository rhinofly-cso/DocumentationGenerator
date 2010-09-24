/**
	Contains the properties and functions to store and access metadata from persistent CF 
	components. The names of all properties defined in this class are identical to the 
	corresponding attributes of a persistent component.
	
	@author Eelco Eggen
	@date 23 September 2010
*/
component displayname="cfc.cfcData.CFPersistentComponent" extends="cfc.cfcData.CFComponent" accessors="true" output="false"
{
	property name="entityName" type="string" hint="Entity name if it is different from the component name.";
	property name="table" type="string" hint="Table name if it is different from the component name.";
	property name="catalog" type="string" hint="Database catalog name.";
	property name="schema" type="string" hint="Schema name of the table.";
	property name="optimisticLock" type="string" hint="Database locking strategy.";

	property name="joinColumn" type="string" hint="Column name of the common value for inheritance mapping.";
	property name="discriminatorColumn" type="string" hint="Column name of the discriminating value.";
	property name="discriminatorValue" type="string" hint="Value for discriminating.";

	property name="batchSize" type="numeric" hint="Number of simultaneous select queries.";
	property name="cacheUse" type="string" hint="Type of secondary cache.";
	property name="cacheName" type="string" hint="Name of the secondary cache, when in use.";

	property name="lazy" type="boolean" hint="Indicates whether the entity is supposed to load its relatives on demand only.";
	property name="selectBeforeUpdate" type="boolean" hint="Indicates whether the entity should do a select query to check whether an update is required.";
	property name="readOnly" type="boolean" hint="Indicates whether the entity is forbidden to alter the database.";
	property name="dynamicInsert" type="boolean" hint="Indicates whether the entity dynamically inserts SQL.";
	property name="dynamicUpdate" type="boolean" hint="Indicates whether the entity dynamically updates SQL.";

	property name="saveMapping" type="boolean" hint="Indicates whether the entity sets ormSettings.saveMapping manually for itself.";
}