-- --������ ������ � SQLPLUS.������� �� ���������� ���������������� ����� SQLNET.ORA � TNSNAMES.ORA � ������������ � �� ����������.
-- /opt/oracle/homes/OraDBHome21cXE/network/admin
--
-- --2.	����������� ��� ������ sqlplus � Oracle ��� ������������ SYSTEM, �������� �������� ���������� ���������� Oracle.
--  sqlplus  system/root
-- SHOW PARAMETERS
-- --3.	����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM, �������� ������ ��������� �����������, ������ ��������� �����������, ����� � �������������.
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


--	������������ � ������� sqlplus ��� ����������� ������������� � � ����������� �������������� ������ �����������.
--ZDA
--7.	��������� select � ����� �������, ������� ������� ��� ������������.
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

--10.	�������� �������� ���� ���������, ���������� ������� �������� ��� ������������.
SELECT SEGMENT_NAME,
       SEGMENT_TYPE
FROM USER_SEGMENTS;
--11.	�������� �������������, � ������� �������� ���������� ���� ���������, ���������� ���������, ������ ������ � ������ � ����������, ������� ��� ��������.
create or replace view ZDA_V as
select count(*)     as count,
       sum(extents) as count_extents,
       sum(blocks)  as count_blocks,
       sum(bytes)   as Kb
from user_segments;
select *
from ZDA_V;


