--2.	�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1000; ���������� 10; ��� ������������ ��������; ��� ������������� ��������; �� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������. �������� ��������� �������� ������������������. �������� ������� �������� ������������������.

--create  user ZDA with password 12345;
create user ZDA identified by "12345";
grant connect, resource to ZDA;
grant create synonym to ZDA;
grant create public synonym to ZDA;
grant create view to ZDA;
grant create materialized view to ZDA;

create sequence S1
    increment by 10
    start with 1000
    nomaxvalue
    nominvalue
    nocycle
    nocache
    noorder;
-- �������� ����. �������� ����-���
select S1.nextval
from dual;
-- +10
-- �������� ���. �������� ����-���
select S1.currval
from dual;

--3.	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� 10; ������������ �������� 100;

create sequence S2
    increment by 10
    start with 10
    maxvalue 100
    nocycle;
-- �������� ��� �������� ����-���
select S2.nextval

from dual;
-- �������� ��������, ���. �� ����
alter sequence S2 increment by 90;
select S2.nextval
from dual; --x2
alter sequence S2 increment by 10;

--5.	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� -10; ����������� �������� -100; �� �����������; ������������� ���������� ��������. �������� ��� �������� ������������������. ����������� �������� ��������, ������ ������������ ��������.

create sequence S3
    increment by -10
    start with 10
    maxvalue 20
    minvalue -100
    nocycle
    order;
-- �������� ��� �������� ����-���
select S3.nextval
from dual;
-- �������� ��������, ���. �� ���
alter sequence S3 increment by -110;

--6.�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1; ���������� 1; ����������� �������� 10; �����������; ���������� � ������ 5 ��������; ���������� �������� �� �������������. ����������������� ����������� ��������� �������� ������������������� S4.

create sequence S4
    increment by 1
    start with 1
    maxvalue 10
    cycle
    cache 5
    noorder;
-- �������� ��� �������� ����-���
select S4.nextval
from dual;

--7.	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ ZDA

select sequence_name
from user_sequences;

--8.	�������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� KEEP. � ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� ������ ������������� � ������� ������������������� S1, S2, S3, S4.
create table T1
(
    N1 number(20),
    N2 number(20),
    N3 number(20),
    N4 number(20)
) storage
(
    buffer_pool keep
);
BEGIN
    FOR i IN 1..7
        LOOP
            insert into T1(N1, N2, N3, N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
        END LOOP;
END;
select *
from T1;

--9.	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC
    (
    x number(10),
    v varchar2(12)
    )
    hashkeys 200;
--10.	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table A
(
    XA number(10),
    VA varchar2(12),
    YA number(10)
)
    cluster ABC (XA, VA);
--11.	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table B
(
    XB number(10),
    VB varchar2(12),
    YB number(10)
)
    cluster ABC (XB, VB);
--12.	�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table C
(
    XC number(10),
    VC varchar2(12),
    YC number(10)
)
    cluster ABC (XC, VC);
--13.	������� ��������� ������� � ������� � �������������� ������� Oracle.
select table_name
from user_tables;
select cluster_name
from user_clusters;

--14.	�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.
create synonym CC for C;
select *
from CC;
--15.	�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
create public synonym BB for B;
select *
from BB;

--16.	�������� ��� ������������ ������� A � B (� ��������� � ������� �������), ��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. ����������������� ��� �����������������

--17.	�� ������ ������ A � B �������� ����������������� ������������� MV, ������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.

create table A1
(
    x int primary key,
    y nvarchar2(10)
);

create table B1
(
    x int primary key,
    y int,
    foreign key (y) references A1 (x)
);

insert into A1(x, y)
values (1, 'A');
insert into B1(x, y)
values (2, 1);
insert into A1(x, y)
values (2, 'B');
insert into B1(x, y)
values (11, 2);
insert into A1(x, y)
values (4, 'C');
insert into B1(x, y)
values (10, 4);
insert into A1(x, y)
values (222, 'D');
insert into B1(x, y)
values (223, 222);

insert into A1(x, y)
values (5, 'E');
insert into B1(x, y)
values (5, 5);

select *
from A1;
select *
from B1;

create view V1
as
select a.x x, a.y y, b.x x1
from A1 a
         inner join B1 b
                    on a.x = b.y;

select *
from V1;

--            TASK 17
create materialized view MV
            build immediate
    refresh complete start with sysdate next sysdate + Interval '1' minute
as
select a.x x, a.y y, b.x x1
from A1 a
         inner join B1 b
                    on a.x = b.y;

select *
from MV;

