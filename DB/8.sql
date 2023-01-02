-- --Основы работы с SQLPLUS.Найдите на компьютере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA и ознакомьтесь с их содержимым.
-- /opt/oracle/homes/OraDBHome21cXE/network/admin
--
-- --2.	Соединитесь при помощи sqlplus с Oracle как пользователь SYSTEM, получите перечень параметров экземпляра Oracle.
--  sqlplus  system/root
-- SHOW PARAMETERS
-- --3.	Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM, получите список табличных пространств, файлов табличных пространств, ролей и пользователей.
select TABLESPACE_NAME
from DBA_TABLESPACES;
select FILE_NAME
from DBA_DATA_FILES
union
select NAME
from V$TEMPFILE;
select *
from DBA_USERS;
select *
from DBA_ROLES;
-- */


--	Подключитесь с помощью sqlplus под собственным пользователем и с применением подготовленной строки подключения.
--ZDA
--7.	Выполните select к любой таблице, которой владеет ваш пользователь.
SELECT *
FROM user_tables;
select *
from ZDA_T1;

--TIMING START;
/*
SQL> select * from ZDA_T1;

        ID NAME
---------- --------------------
         1 ZDA
         2 DAZ
         3 AZD

SQL> TIMING STOP;*/

--10.	Получите перечень всех сегментов, владельцем которых является ваш пользователь.
SELECT SEGMENT_NAME,
       SEGMENT_TYPE
FROM USER_SEGMENTS;
--11.	Создайте представление, в котором получите количество всех сегментов, количество экстентов, блоков памяти и размер в килобайтах, которые они занимают.
create or replace view ZDA_V as
select count(*)     as count,
       sum(extents) as count_extents,
       sum(blocks)  as count_blocks,
       sum(bytes)   as Kb
from user_segments;
select *
from ZDA_V;


