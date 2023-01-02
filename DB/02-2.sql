--Задание 10. Создайте соединение с помощью SQL Developer для пользователя XXXCORE. Создайте любую таблицу и любое представление.

create TABLE TEST
(
test NUMBER(10)
);

insert into test values(12);

create view test_VIEW as
select * from   TEST;


select * from test_VIEW;



CREATE TABLE ZDA_T1 (c NUMBER) TABLESPACE TS_ZDA_QDATA;


INSERT INTO ZDA_T1(c) VALUES(3);
INSERT INTO ZDA_T1(c) VALUES(1);
INSERT INTO ZDA_T1(c) VALUES(2);

--От имени пользователя XXX создайте таблицу в пространстве XXX_T1. В таблицу добавьте 3 строки
SELECT * FROM ZDA_T1;