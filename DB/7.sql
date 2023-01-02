--1. ������ ������ ������� ���������
select name, description from v$bgprocess;

--2. ���������� ������� ��������, ������� �������� � �������� � ��������� ������.
select * from v$bgprocess where paddr!=hextoraw('00'); 

--3.	����������, ������� ��������� DBWn �������� � ��������� ������.
show parameter db_writer_processes;
select count(*) from v$session where program like '%DBW%';

--4. �������� ������� ���������� � ���������.
select * from v$session where username is not null;

--5. ���������� ������ ���� ����������
select username, server from v$session where username is not null;

--6  ���������� ������� (����� ����������� ����������).
select * from V$SERVICES ;  

--7.	�������� ��������� ��� ��������� ���������� � �� ��������.
SELECT * FROM V$DISPATCHER;
show parameter DISPATCHERS;
--9.	�������� �������� ������� ���������� � ���������. (dedicated, shared). 
SELECT USERNAME,SERVER FROM V$SESSION;

--10.	����������������� � �������� ���������� ����� LISTENER.ORA. 

--11.	��������� ������� lsnrctl � �������� �� �������� �������. 
--lsnrctl status, start, stop

-- 12: ������ ����� ��������, ������������� ��������� LISTENER
-- lsnrctl -> services