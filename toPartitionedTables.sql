CREATE OR REPLACE PROCEDURE [yourDataset].toPartitionedTable(PROJECT_NAME STRING, DATASET STRING, TABLE_NAME STRING, PARTITION_FIELD STRING)

BEGIN

  DECLARE FULL_TABLE_NAME STRING;
  DECLARE TABLE_NAME_PARTITIONED STRING;
  DECLARE TABLE_NAME_NONPARTITIONED STRING;
  DECLARE QUERY_CREATE STRING;
  DECLARE QUERY_ALTER_NONPARTITIONED STRING;
  DECLARE QUERY_ALTER_PARTITIONED STRING;

  SET FULL_TABLE_NAME = CONCAT(PROJECT_NAME,'.',DATASET,'.',TABLE_NAME);
  SET TABLE_NAME_PARTITIONED = CONCAT(PROJECT_NAME,'.',DATASET,'.',TABLE_NAME,'_PARTITIONED');
  SET TABLE_NAME_NONPARTITIONED = CONCAT(PROJECT_NAME,'.',DATASET,'.',TABLE_NAME,'_NONPARTITIONED');

  SET QUERY_CREATE = FORMAT("CREATE TABLE `%s` PARTITION BY `%s` AS SELECT * FROM `%s`", TABLE_NAME_PARTITIONED, PARTITION_FIELD, FULL_TABLE_NAME);
  SET QUERY_ALTER_NONPARTITIONED = FORMAT("ALTER TABLE `%s` RENAME TO `%s_NONPARTITIONED`", FULL_TABLE_NAME, TABLE_NAME);
  SET QUERY_ALTER_PARTITIONED = FORMAT("ALTER TABLE `%s` RENAME TO `%s`", TABLE_NAME_PARTITIONED, TABLE_NAME);
  
  EXECUTE IMMEDIATE QUERY_CREATE;
  EXECUTE IMMEDIATE QUERY_ALTER_NONPARTITIONED;
  EXECUTE IMMEDIATE QUERY_ALTER_PARTITIONED;
  -- Optional: EXECUTE IMMEDIATE FORMAT("DROP TABLE `%s`",TABLE_NAME_NONPARTITIONED)
END
