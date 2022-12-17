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

## PostgreSQL (and H2) specific

### List Tables
```sql
SELECT * FROM information_schema.tables;
SELECT * FROM information_schema.tables WHERE table_schema='schema1';
```

### List Schemas
```sql
SELECT catalog_name,schema_name FROM information_schema.schemata;
```
Note: ```catalog_name``` is DB name.