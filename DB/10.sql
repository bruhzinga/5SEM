--1. ���������� �� ��� ����������
begin
    null;
end;

--2. ��, ����� 'hello world'
begin
    dbms_output.put_line('Hello, world');
end;
--3.	����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.
declare
    x number(3) := 3;
    y number(3) := 0;
    z number(10, 2);
begin
    z := x / y;
exception
    when others
        then dbms_output.put_line(sqlcode || ': error = ' || sqlerrm);
end;

--4.	������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.
declare
    x number(3) := 3;
begin
    begin
        declare
            x number(3) := 1;
        begin
            dbms_output.put_line('x = ' || x);
        end;
    end;
    dbms_output.put_line('x = ' || x);
end;
--5.	��������, ����� ���� �������������� ����������� �������������� � ������ ������.
alter system set plsql_warnings = 'ENABLE:INFORMATIONAL';
select name, value
from v$parameter
where name = 'plsql_warnings';

--6.	������������ ������, ����������� ����������� ��� ����������� PL/SQL.
select keyword
from v$reserved_words
where length = 1
  and keyword != 'A';

--7.	������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.
select keyword
from v$reserved_words
where length > 1;
--8.	������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL.
select name, value
from v$parameter
where name like 'plsql%';
--9.	������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
/*10.	���������� � ������������� ����� number-����������;
11.	�������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
12.	���������� � ������������� number-���������� � ������������� ������;
13.	���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
14.	���������� � ������������� BINARY_FLOAT-����������;
15.	���������� � ������������� BINARY_DOUBLE-����������;
16.	���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
17.	���������� � ������������� BOOLEAN-����������*/

declare
    c1  number(3)      := 100;
    c2  number(3)      := 50;
    div number(10, 2);
    fix number(4, 2)   := 30.1492121111454545;
    otr number(5, -2)  := 1234567 ;
    en  number(32, 10) := 12345E-10;
    bf  binary_float   := 123456789.12345678910;
    bd  binary_double  := 123456789.12345678910;
    b1  boolean        := true;

begin
    div := mod(c1, c2);
    dbms_output.put_line('c1 = ' || c1);
    dbms_output.put_line('c2 = ' || c2);
    dbms_output.put_line('c1%c2 = ' || div);

    dbms_output.put_line('fix = ' || fix);
    dbms_output.put_line('otr = ' || otr);
    dbms_output.put_line('en = ' || en);
    dbms_output.put_line('bf = ' || bf);
    dbms_output.put_line('bd = ' || bd);
    if b1 then dbms_output.put_line('b1 = ' || 'true'); end if;
end;
--18.	������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). �����������������  ��������� �������� �����������.
declare
    n1 constant number(5)   := 5;
    vc constant varchar(25) := 'Hello world';
    c  constant char(8)     := 'Hello BD';
begin
    dbms_output.put_line('vc = ' || vc);
    dbms_output.put_line('n1 = ' || n1);
    dbms_output.put_line('c = ' || c);


exception
    when others
        then dbms_output.put_line('error = ' || n1);
end;
--19.	������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.
--20.	������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.
DECLARE
    example  AUDITORIUM%ROWTYPE;
    example2 AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;

BEGIN
    example2 := 100;
    SELECT * INTO example FROM AUDITORIUM WHERE AUDITORIUM_NAME = '429-4'; -- retrieve record
    DBMS_OUTPUT.PUT_LINE('AUDIT NAME: ' || example.AUDITORIUM_NAME || ' AUDIT CAPACITY '
        || example2);
END;

--21.	������������ ��, ��������������� ��� ��������� ����������� ��������� IF .
declare
    x pls_integer := 17;
begin
    if 8 > x then
        dbms_output.put_line('8>' || x);
    elsif 8 = x then
        dbms_output.put_line('8=' || x);
    else
        dbms_output.put_line('8<' || x);
    end if;
end;
--23.	������������ ��, ��������������� ������ ��������� CASE.
declare
    x pls_integer := 17;
begin
    case x
        when 17 then dbms_output.put_line('17');
        end case;
    case
        when 8 > x then dbms_output.put_line('8>' || x);
        when x between 13 and 20 then dbms_output.put_line('yes');
        else dbms_output.put_line('else');
        end case;
end;
/*
24.	������������ ��, ��������������� ������ ��������� LOOP.
25.	������������ ��, ��������������� ������ ��������� WHILE.
26.	������������ ��, ��������������� ������ ��������� FOR.
*/

declare
    x pls_integer := 0;
begin
    loop
        x := x + 1;
        dbms_output.put(x);
        exit when x > 5;
    end loop;
    for k in 1..5
        loop
            dbms_output.put_line(k);
        end loop;
    while (x > 0)
        loop
            x := x - 1;
            dbms_output.put_line(x);
        end loop;
end;