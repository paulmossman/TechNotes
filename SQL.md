**<span style="font-size:3em;color:black">SQL</span>**
***

# Basics

## Delete
```sql
DELETE FROM table_name WHERE condition;
DELETE FROM table_name; -- All records!
```

## Count
```sql
SELECT COUNT(column_name) FROM table_name WHERE condition;
SELECT COUNT(*) FROM table_name;
```

## Update
```sql
UPDATE table_name SET col = value WHERE condition;
```

## Remove a table (and all its data)
```sql
DROP TABLE table_name;
```

## WITH clause - named sub-query block
```sql
WITH RowFromOtherTable AS (
   SELECT id FROM other_table WHERE name = 'A')
SELECT * FROM this_table WHERE other_id = (SELECT id FROM SpecifiedPlan);
```

## Joins

### INNER JOIN
Selects record that have the same value in two tables.
```sql
SELECT left.id, left.name, right.date FROM left
   INNER JOIN right
   ON left.id = right.id
   WHERE left.customer = '100';
```

### FULL JOIN (aka FULL OUTER JOIN)
Selects all records where there's a match in the first (left) table **or** the second (right) table.
```sql
SELECT left.id, left.name, right.date FROM left
   FULL JOIN right
   ON left.id = right.id;
```
Also supports WHERE.

## PostgreSQL specific

### List Tables (and H2)
```sql
SELECT * FROM information_schema.tables;
SELECT * FROM information_schema.tables WHERE table_schema='schema1';
```

### List Schemas (and H2)
```sql
SELECT catalog_name,schema_name FROM information_schema.schemata;
```
Note: ```catalog_name``` is DB name.

### Show idle connections
```sql
SELECT pid, datname, state, current_timestamp-least(query_start,xact_start) age, application_name, usename, query
   FROM pg_stat_activity
   WHERE query != '<IDLE>'
   AND query NOT ILIKE '%pg_stat_activity%'
   AND usename!='rdsadmin'
   ORDER BY query_start desc;
```