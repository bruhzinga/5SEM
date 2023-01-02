--1. простейший АБ без операторов
begin
    null;
end;

--2. АБ, вывод 'hello world'
begin
    dbms_output.put_line('Hello, world');
end;
--3.	Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.
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

--4.	Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.
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
--5.	Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.
alter system set plsql_warnings = 'ENABLE:INFORMATIONAL';
select name, value
from v$parameter
where name = 'plsql_warnings';

--6.	Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
select keyword
from v$reserved_words
where length = 1
  and keyword != 'A';

--7.	Разработайте скрипт, позволяющий просмотреть все ключевые слова  PL/SQL.
select keyword
from v$reserved_words
where length > 1;
--8.	Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL.
select name, value
from v$parameter
where name like 'plsql%';
--9.	Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
/*10.	объявление и инициализацию целых number-переменных;
11.	арифметические действия над двумя целыми number-переменных, включая деление с остатком;
12.	объявление и инициализацию number-переменных с фиксированной точкой;
13.	объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
14.	объявление и инициализацию BINARY_FLOAT-переменной;
15.	объявление и инициализацию BINARY_DOUBLE-переменной;
16.	объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
17.	объявление и инициализацию BOOLEAN-переменных*/

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
--18.	Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). Продемонстрируйте  возможные операции константами.
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
--19.	Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
--20.	Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.
DECLARE
    example  AUDITORIUM%ROWTYPE;
    example2 AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;

BEGIN
    example2 := 100;
    SELECT * INTO example FROM AUDITORIUM WHERE AUDITORIUM_NAME = '429-4'; -- retrieve record
    DBMS_OUTPUT.PUT_LINE('AUDIT NAME: ' || example.AUDITORIUM_NAME || ' AUDIT CAPACITY '
        || example2);
END;

--21.	Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
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
--23.	Разработайте АБ, демонстрирующий работу оператора CASE.
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
24.	Разработайте АБ, демонстрирующий работу оператора LOOP.
25.	Разработайте АБ, демонстрирующий работу оператора WHILE.
26.	Разработайте АБ, демонстрирующий работу оператора FOR.
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