alter session set "_ORACLE_SCRIPT"= true;

--1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������
select tablespace_name, contents from DBA_TABLESPACES;

--2. �������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline. ����� ���������� ��������� ������������ � ��������� online. �������� ������������ XXX ���   �� 2m � ������������ XXX_QDATA. �� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������, ���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������.

create tablespace ZDA_QDATA offline
datafile 'TS_ZDA_QDATA.dbf' size 10m reuse
autoextend on next 5 m
maxsize 20 m;


alter tablespace ZDA_QDATA online;


create user ZDA identified by ZDA;
grant create session to ZDA;
grant create table to ZDA;


alter user ZDA quota 2m on ZDA_QDATA;

drop user ZDA cascade;



--3. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. ���������� ��������� ��������.

select * from DBA_SEGMENTS where tablespace_name='ZDA_QDATA';
select * from dba_segments;

--4. ������� (DROP) ������� XXX_T1. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. ��������� SELECT-������ � ������������� USER_RECYCLEBIN, �������� ���������.

select * from DBA_SEGMENTS where tablespace_name='ZDA_QDATA';


--5. ������������ (FLASHBACK) ��������� �������.









--8. ������� ��������� ������������ XXX_QDATA � ��� ����.
drop tablespace ZDA_QDATA including contents and datafiles;

--9. �������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������.
select * from v$log;

--10. �������� �������� ������ ���� �������� ������� ��������
select * from v$logfile;

--11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. �������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).

alter system switch logfile;
select * from v$log;

--12. EX. �������� �������������� ������ �������� ������� � ����� ������� �������. ��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������). ���������� ������������������ SCN.


alter database add logfile group 4 'REDO04.log'
    size 50 m blocksize 512;
alter database add logfile member
      'REDO041.LOG' reuse  to group 4;
alter database add logfile member
    'REDO042.LOG'  reuse to group 4;

--13. EX. ������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������.
alter system checkpoint;
alter database drop  logfile member 'REDO04.LOG';
alter database drop logfile member 'REDO042.LOG';
alter database drop logfile member 'REDO041.LOG';
alter database drop logfile group 4 ;




--14. ����������, ����������� ��� ��� ������������� �������� ������� (������������� ������ ���� ���������, ����� ���������, ���� ������ ������� �������� ������� � ��������).

select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;

--15. ���������� ����� ���������� ������

select *from v$log;
select * from v$archived_log;
--16. EX.  �������� �������������.

--17. EX. ������������� �������� �������� ����. ���������� ��� �����. ���������� ��� �������������� � ��������� � ��� �������. ���������� ������������������ SCN � ������� � �������� �������.
alter system switch logfile;
select * from v$archived_log;

--18. EX. ��������� �������������. ���������, ��� ������������� ���������.
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;
--19. �������� ������ ����������� ������.
select * from v$controlfile;
--20. �������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.
show parameter control;
select * from v$controlfile_record_section;
--21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����.

--22. ����������� PFILE � ������ XXX_PFILE.ORA. ���������� ��� ����������. �������� ��������� ��� ��������� � �����.
create pfile = 'ZDA_pfile.ora' from spfile;

---- 23: ������������ ����� ������� ��������:
select * from v$pwfile_users;
show parameter remote_login_passwordfile;
---- 24: �������� ����������� ��� ������ ��������� � �����������
select * from v$diag_info;


--25. EX. ������� � ���������� ���������� ��������� ������ �������� (LOG.XML), ������� � ��� ������� ������������ �������� ������� �� ���������.







