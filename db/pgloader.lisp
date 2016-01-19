LOAD DATABASE
FROM mysql://root@localhost/honeycomb_development
INTO postgresql://root@localhost/honeycomb_development
WITH data only
SET session_replication_role = 'replica'
EXCLUDING TABLE NAMES MATCHING 'schema_migrations';
