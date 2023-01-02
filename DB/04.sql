alter session set "_ORACLE_SCRIPT"= true;

--1. Получите список всех существующих PDB в рамках экземпляра ORA12W. Определите их текущее состояние.

select PDB_NAME, STATUS from DBA_PDBS;
select name, V$PDBS.OPEN_MODE from V$PDBS;
--2. Выполните запрос к ORA12W, позволяющий получить перечень экземпляров
select INSTANCE_NAME from v$instance;
--3. Выполните запрос к ORA12W, позволяющий получить перечень установленных компонентов СУБД Oracle 12c и их версии и статус.
select * from PRODUCT_COMPONENT_VERSION;

--4. Создайте собственный экземпляр PDB
create pluggable database ZDA_PDB admin user ZDA_pdb_admin identified by qwerty
    storage (maxsize 2 g)
    default tablespace ts_ZDA_pdb
        datafile '/vrl_ZDA/ts_ZDA_pdb.dbf' size 250 m autoextend on
    path_prefix ='/vrl_ZDA/'
    file_name_convert =('/pdbseed/','/vrl_pdb/');

--5
alter pluggable database ZDA_PDB open;


--9. Подключитесь  к CDB-базе данных, создайте общего пользователя с именем C##XXX, назначьте ему привилегию, позволяющую подключится к базе данных XXX_PDB. Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB-базе данных и  XXX_PDB – базе данных. Проверьте их работоспособность.
create user C##ZDA identified by qwerty;
grant create session to C##ZDA;
drop user C##ZDA cascade;

--12. Продемонстрируйте преподавателю, работоспособную PDB-базу данных и созданную инфраструктуру (результаты всех запросов). Покажите файлы PDB-базы данных (на серверном компьютере).
select * from DBA_PDBS;











