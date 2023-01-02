--2.	Создайте последовательность S1 (SEQUENCE), со следующими характеристиками: начальное значение 1000; приращение 10; нет минимального значения; нет максимального значения; не циклическая; значения не кэшируются в памяти; хронология значений не гарантируется. Получите несколько значений последовательности. Получите текущее значение последовательности.

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
-- получить неск. значений посл-сти
select S1.nextval
from dual;
-- +10
-- получить тек. значение посл-сти
select S1.currval
from dual;

--3.	Создайте последовательность S2 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение 10; максимальное значение 100;

create sequence S2
    increment by 10
    start with 10
    maxvalue 100
    nocycle;
-- получить все значения посл-сти
select S2.nextval

from dual;
-- получить значение, вых. за макс
alter sequence S2 increment by 90;
select S2.nextval
from dual; --x2
alter sequence S2 increment by 10;

--5.	Создайте последовательность S3 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение -10; минимальное значение -100; не циклическую; гарантирующую хронологию значений. Получите все значения последовательности. Попытайтесь получить значение, меньше минимального значения.

create sequence S3
    increment by -10
    start with 10
    maxvalue 20
    minvalue -100
    nocycle
    order;
-- получить все значения посл-сти
select S3.nextval
from dual;
-- получить значение, вых. за мин
alter sequence S3 increment by -110;

--6.Создайте последовательность S4 (SEQUENCE), со следующими характеристиками: начальное значение 1; приращение 1; минимальное значение 10; циклическая; кэшируется в памяти 5 значений; хронология значений не гарантируется. Продемонстрируйте цикличность генерации значений последовательностью S4.

create sequence S4
    increment by 1
    start with 1
    maxvalue 10
    cycle
    cache 5
    noorder;
-- получить все значения посл-сти
select S4.nextval
from dual;

--7.	Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь ZDA

select sequence_name
from user_sequences;

--8.	Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), кэшируемую и расположенную в буферном пуле KEEP. С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов должно формироваться с помощью последовательностей S1, S2, S3, S4.
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

--9.	Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC
    (
    x number(10),
    v varchar2(12)
    )
    hashkeys 200;
--10.	Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table A
(
    XA number(10),
    VA varchar2(12),
    YA number(10)
)
    cluster ABC (XA, VA);
--11.	Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table B
(
    XB number(10),
    VB varchar2(12),
    YB number(10)
)
    cluster ABC (XB, VB);
--12.	Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table C
(
    XC number(10),
    VC varchar2(12),
    YC number(10)
)
    cluster ABC (XC, VC);
--13.	Найдите созданные таблицы и кластер в представлениях словаря Oracle.
select table_name
from user_tables;
select cluster_name
from user_clusters;

--14.	Создайте частный синоним для таблицы XXX.С и продемонстрируйте его применение.
create synonym CC for C;
select *
from CC;
--15.	Создайте публичный синоним для таблицы XXX.B и продемонстрируйте его применение.
create public synonym BB for B;
select *
from BB;

--16.	Создайте две произвольные таблицы A и B (с первичным и внешним ключами), заполните их данными, создайте представление V1, основанное на SELECT... FOR A inner join B. Продемонстрируйте его работоспособность

--17.	На основе таблиц A и B создайте материализованное представление MV, которое имеет периодичность обновления 2 минуты. Продемонстрируйте его работоспособность.

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

