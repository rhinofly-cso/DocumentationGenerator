/**
	Contains the properties and functions to store and access property metadata from persistent 
	CF components. The names of all properties defined in this class are identical to the 
	corresponding attributes of a persistent property.
	
	@author Eelco Eggen
	@date 17 August 2010
	@see cfc.cfcData.CFPersistentComponent
*/
component displayname="cfc.cfcData.CFMapping" extends="cfc.cfcData.CFProperty" accessors="true" output="false"
{
	property name="fieldType" type="string" hint="Determines what type of mapping the attribute represents.";
	property name="remotingFetch" type="boolean" hint="Indicates whether the attribute can be sent over flash remoting.";

	// key, column, or versioning
	property name="column" type="string" hint="Column name.";
	property name="ormType" type="string" hint="Column data type.";

	// key
	property name="generator" type="string" hint="Type of key generation for CF.";
	property name="selectKey" type="string" hint="Column name for triggered database key generation.";
	property name="unsavedValue" type="string" hint="Key value associated with an unsaved record.";

	// key or column
	property name="length" type="numeric" hint="Column length for table creation.";
	property name="sqlType" type="string" hint="Column data type for table creation.";

	// column
	property name="dbdefault" type="string" hint="Default value for the column.";

	property name="formula" type="string" hint="SQL expression that defines a value.";
	
	property name="scale" type="numeric" hint="Column scale for table creation.";
	property name="precision" type="numeric" hint="Column precision for table creation.";
	property name="index" type="string" hint="Database index name.";

	// column or versioning
	property name="generated" type="string" hint="Indicates when a value should be generated by the database.";

	// column, versioning, or relationship
	property name="insert" type="boolean" hint="Indicates whether the column should be included in SQL INSERT statements.";

	// column or relationship
	property name="update" type="boolean" hint="Indicates whether the column should be included in SQL UPDATE statements.";
	property name="notNull" type="boolean" hint="Indicates whether a NOT-NULL constraint should be applied to the column.";
	property name="unique" type="boolean" hint="Indicates whether a unique-key constraint should be applied to the column.";
	property name="uniqueKey" type="string" hint="Name of the unique-key constraint for grouping constraints on multiple columns.";

	// column, relationship, or collection
	property name="optimisticLock" type="boolean" hint="Indicates whether updates require acquisition of the optimistic lock on the table row.";

	// timestamp
	property name="source" type="string" hint="Source of the timestamp.";

	// relationship
	property name="cfc" type="string" hint="Name of the associated cfc.";
	property name="linkTable" type="string" hint="Name of the link table.";
	property name="linkCatalog" type="string" hint="Catalog name for the link table.";
	property name="linkSchema" type="string" hint="Schema name of the link table.";

	property name="inverseJoinColumn" type="string" hint="Name of the foreign key column that contains the common value for inheritance mapping.";
	property name="mappedBy" type="string" hint="Name of the unique key column.";

	property name="cacheUse" type="string" hint="Type of secondary cache.";
	property name="cacheName" type="string" hint="Name of the secondary cache, when in use.";

	property name="cascade" type="string" hint="Cascading options.";
	property name="constrained" type="boolean" hint="Indicates whether a constraint is set on the table's Primary Key column.";
	property name="fetch" type="string" hint="Query type for retrieving objects.";
	property name="where" type="string" hint="SQL Expression for filtering the associated collection.";

	property name="inverse" type="boolean" hint="Indicates whether an SQL query should be executed when persisting this object.";
	property name="foreignKeyName" type="string" hint="Name of the foreign-key constraint.";

	property name="missingRowIgnored" type="boolean" hint="Indicates whether exceptions are suppressed for missing rows.";
	property name="singularName" type="string" hint="Name for generating methods other than the property name.";
	
	// relationship or collection
	property name="fkColumn" type="string" hint="Name of the foreign key column.";
	property name="orderBy" type="string" hint="SQL Expression for ordering the associated collection.";

	property name="structKeyColumn" type="string" hint="Column name to use as struct keys for struct type collections.";
	property name="structKeyType" type="string" hint="Data type of the struct keys for struct type collections.";

	property name="lazy" type="string" hint="The amount of lazyness for the property when loading its associations.";
	property name="batchSize" type="numeric" hint="Number of simultaneous select queries.";
	property name="readOnly" type="boolean" hint="Indeicates whether the associated collection is static.";
	
	// collection
	property name="table" type="string" hint="Table name.";
	property name="elementColumn" type="string" hint="Column name for the collection values.";
	property name="elementType" type="string" hint="ORM data type of the column.";
}