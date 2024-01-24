#!/bin/bash

# Developer: Asman Mirza
# Email: rambo007.am@gmail.com
# Date: 24 January, 2024

oracle_container_name="oracle19e"
oracle_sid="TEST"
sysdba_username="sys"
sysdba_password="Design_25"

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NOCOLOR='\033[0m'

echo_complete() {
    echo -e "${GREEN}$1${NOCOLOR}"
}

echo_step() {
    echo -e "${ORANGE}$1${NOCOLOR}"
}

echo_error() {
    echo -e "${RED}$1${NOCOLOR}"
}

echo_step "Executing Step 1..."
docker exec $oracle_container_name sqlplus / as sysdba <<-EOF
SELECT LOG_MODE FROM V\$DATABASE;
EXIT;
EOF

echo_step "Executing Step 2..."
docker exec -e ORACLE_SID=$oracle_sid $oracle_container_name sqlplus $sysdba_username/$sysdba_password as sysdba <<-EOF
ALTER SYSTEM SET db_recovery_file_dest_size = 10G;
ALTER SYSTEM SET db_recovery_file_dest = '/opt/oracle/oradata/$oracle_sid' scope=spfile;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
ARCHIVE LOG LIST;
SELECT GROUP#, BYTES/1024/1024 SIZE_MB, STATUS FROM V\$LOG ORDER BY 1;
SELECT GROUP#, MEMBER FROM V\$LOGFILE ORDER BY 1, 2;
EXIT;
EOF

echo_step "Executing Step 3..."
docker exec -e ORACLE_SID=$oracle_sid $oracle_container_name sqlplus $sysdba_username/$sysdba_password as sysdba <<-EOF
ALTER DATABASE CLEAR LOGFILE GROUP 1;
ALTER DATABASE DROP LOGFILE GROUP 1;
ALTER DATABASE ADD LOGFILE GROUP 1 ('/opt/oracle/oradata/$oracle_sid/redo01.log') size 400M REUSE;
ALTER SYSTEM SWITCH LOGFILE;
EXIT;
EOF

echo_step "Executing Step 4..."
docker exec -e ORACLE_SID=$oracle_sid $oracle_container_name sqlplus $sysdba_username/$sysdba_password as sysdba <<-EOF
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
EXIT;
EOF

echo_step "Executing Step 5..."
docker exec -e ORACLE_SID=$oracle_sid $oracle_container_name sqlplus $sysdba_username/$sysdba_password as sysdba <<-EOF
ALTER SESSION SET CONTAINER = CDB$ROOT;
CREATE TABLESPACE LOGMINER_TBS DATAFILE '/opt/oracle/oradata/ORCLCDB/logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
ALTER SESSION SET CONTAINER = ORCLPDB1;
CREATE TABLESPACE LOGMINER_TBS DATAFILE '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
ALTER SESSION SET CONTAINER = CDB$ROOT;
EXIT;
EOF

echo_step "Executing Step 6..."
docker exec -e ORACLE_SID=$oracle_sid $oracle_container_name sqlplus $sysdba_username/$sysdba_password as sysdba <<-EOF
CREATE USER c##d4rky IDENTIFIED BY d4rky007 DEFAULT TABLESPACE LOGMINER_TBS QUOTA UNLIMITED ON LOGMINER_TBS CONTAINER=ALL;
EXIT;
EOF

echo_step "Executing Step 7..."
docker exec -e ORACLE_SID=$oracle_sid $oracle_container_name sqlplus $sysdba_username/$sysdba_password as sysdba <<-EOF
GRANT CREATE SESSION TO c##d4rky CONTAINER=ALL;
GRANT SET CONTAINER TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$DATABASE TO c##d4rky CONTAINER=ALL;
GRANT FLASHBACK ANY TABLE TO c##d4rky CONTAINER=ALL;
GRANT SELECT ANY TABLE TO c##d4rky CONTAINER=ALL;
GRANT SELECT_CATALOG_ROLE TO c##d4rky CONTAINER=ALL;
GRANT EXECUTE_CATALOG_ROLE TO c##d4rky CONTAINER=ALL;
GRANT SELECT ANY TRANSACTION TO c##d4rky CONTAINER=ALL;
GRANT SELECT ANY DICTIONARY TO c##d4rky CONTAINER=ALL;
GRANT LOGMINING TO c##d4rky CONTAINER=ALL;
GRANT CREATE TABLE TO c##d4rky CONTAINER=ALL;
GRANT LOCK ANY TABLE TO c##d4rky CONTAINER=ALL;
GRANT CREATE SEQUENCE TO c##d4rky CONTAINER=ALL;
GRANT EXECUTE ON DBMS_LOGMNR TO c##d4rky CONTAINER=ALL;
GRANT EXECUTE ON DBMS_LOGMNR_D TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$LOG TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$LOG_HISTORY TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$LOGMNR_LOGS TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$LOGMNR_PARAMETERS TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$LOGFILE TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$ARCHIVED_LOG TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$ARCHIVE_DEST_STATUS TO c##d4rky CONTAINER=ALL;
GRANT SELECT ON V_$TRANSACTION TO c##d4rky CONTAINER=ALL;
EXIT;
EOF

echo "Executing Step 10..."
docker exec -e ORACLE_SID=ORCLPDB1 $oracle_container_name sqlplus c##d4rky@$oracle_sid <<-EOF
CREATE TABLE techno (id number(9,0) primary key, name varchar2(50));
-- Add other commands...
EXIT;
EOF

echo_complete "Script execution completed."