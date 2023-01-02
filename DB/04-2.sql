
alter session set "_ORACLE_SCRIPT"= true;
--6-7. Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer, создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице.
CREATE TABLESPACE ts_pdb_ZDA
    DATAFILE 'ts_ZDA_pdb.dbf' SIZE 7 M
    AUTOEXTEND ON NEXT 5 M MAXSIZE 20 M;

CREATE TEMPORARY TABLESPACE ts_temp_pdb_ZDA
    TEMPFILE 'ts__temp_ZDA_pdb.dbf' SIZE 5 M
    AUTOEXTEND ON NEXT 3 M MAXSIZE 30 M;



CREATE ROLE rl_ZDA_pdbcore;

grant create session, create table, create view, create procedure to rl_ZDA_pdbcore;
grant drop any table, drop any view, drop any procedure to rl_ZDA_pdbcore;

CREATE PROFILE pf_ZDA_pdbcore LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;

CREATE USER u1_ZDA_pdb IDENTIFIED BY qwerty
    DEFAULT TABLESPACE ts_pdb_ZDA
    QUOTA UNLIMITED ON ts_pdb_ZDA
    TEMPORARY TABLESPACE ts_temp_pdb_ZDA
    PROFILE pf_ZDA_pdbcore
    ACCOUNT UNLOCK;
grant rl_ZDA_pdbcore to u1_ZDA_pdb;

SELECT tablespace_name,
       con_id
FROM cdb_tablespaces;


select username
from dba_users;

--8. С помощью представлений словаря базы данных определите, все табличные пространства, все  файлы (перманентные и временные), все роли (и выданные им привилегии), профили безопасности, всех пользователей  базы данных XXX_PDB и  назначенные им роли.

select *
from DBA_TABLESPACES;

select *
from DBA_ROLE_PRIVS;

select *
from DBA_PROFILES;

select *
from DBA_ROLE_PRIVS;

select *
from DBA_DATA_FILES;
select *
from DBA_TEMP_FILES;



grant create session to  C##ZDA;
--show all users
select username from dba_users;




