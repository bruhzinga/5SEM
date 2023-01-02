--1.	Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.
create table LABA15
(
    id   int primary key,
    name varchar(50)
);

--2.	Заполните таблицу строками (10 шт.).
insert into LABA15
values (1, 'One');

insert into LABA15
values (2, 'Two');
insert into LABA15
values (3, 'Three');
insert into LABA15
values (4, 'Four');
insert into LABA15
values (5, 'Five');
insert into LABA15
values (6, 'Six');
insert into LABA15
values (7, 'Seven');
insert into LABA15
values (8, 'Eight');
insert into LABA15
values (9, 'Nine');
insert into LABA15
values (10, 'Ten');


--3.	Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE.
create or replace trigger LABA15_Before_OP
    before insert or delete or update
    on LABA15
begin
    DBMS_OUTPUT.PUT_LINE('LABA15_Before_OP');

end;


--5.	Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger LABA15_Before_SR
    before insert or delete or update
    on LABA15
    for each row
begin
    DBMS_OUTPUT.PUT_LINE('LABA15_Before_SR');
end;


delete
from LABA15
where id = 1;


--6.	Примените предикаты INSERTING, UPDATING и DELETING.
create trigger LABA15_Before_GENERAL
    before insert or delete or update
    on LABA15
begin
    if inserting then
        DBMS_OUTPUT.PUT_LINE('LABA15_Before_GENERAL INSERTING');
    elsif updating then
        DBMS_OUTPUT.PUT_LINE('LABA15_Before_GENERAL UPDATING');
    elsif deleting then
        DBMS_OUTPUT.PUT_LINE('LABA15_Before_GENERAL DELETING');
    end if;
end;
--7.	Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.
--8.	Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.
create trigger LABA15_After_OP
    after insert or delete or update
    on LABA15
begin
    DBMS_OUTPUT.PUT_LINE('LABA15_After_OP');
end;

create trigger LABA15_After_SR
    after insert or delete or update
    on LABA15
    for each row
begin
    DBMS_OUTPUT.PUT_LINE('LABA15_After_SR');

end;

--9.	Создайте таблицу с именем AUDIT. Таблица должна содержать поля: OperationDate,
/*OperationType (операция вставки, обновления и удаления),
TriggerName(имя триггера),
Data (строка с значениями полей до и после операции).*/

create table "AUDIT"
(
    OperationDate date,
    OperationType varchar(50),
    TriggerName   varchar(50),
    Data          varchar(50)
);

select *
from "AUDIT";

--10.	Измените триггеры таким образом, чтобы они регистрировали все операции с исходной таблицей в таблице AUDIT.

create or replace trigger LABA15_Before_AUDIT
    before insert or delete or update
    on LABA15
    for each row
begin
    if inserting then
        insert into "AUDIT"(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'inserting', 'LABA15_Before_AUDIT',
                'OLD: ' || :OLD.id || ' ' || :OLD.name || ' NEW: ' || :NEW.id || ' ' || :NEW.name);
    end if;
    if updating then
        insert into "AUDIT"(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'updating', 'LABA15_Before_AUDIT',
                'OLD: ' || :OLD.id || ' ' || :OLD.name || ' NEW: ' || :NEW.id || ' ' || :NEW.name);
    end if;
    if deleting then
        insert into "AUDIT"(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'deleting', 'LABA15_Before_AUDIT',
                'OLD: ' || :OLD.id || ' ' || :OLD.name || ' NEW: ' || :NEW.id || ' ' || :NEW.name);
    end if;
end;
create or replace trigger LABA15_AFTER_AUDIT
    after insert or delete or update
    on LABA15
    for each row
begin
    if inserting then
        insert into "AUDIT"(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'inserting', 'LABA15_AFTER_AUDIT',
                'OLD: ' || :OLD.id || ' ' || :OLD.name || ' NEW: ' || :NEW.id || ' ' || :NEW.name);
    end if;
    if updating then
        insert into "AUDIT"(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'updating', 'LABA15_AFTER_AUDIT',
                'OLD: ' || :OLD.id || ' ' || :OLD.name || ' NEW: ' || :NEW.id || ' ' || :NEW.name);
    end if;
    if deleting then
        insert into "AUDIT"(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'deleting', 'LABA15_AFTER_AUDIT',
                'OLD: ' || :OLD.id || ' ' || :OLD.name || ' NEW: ' || :NEW.id || ' ' || :NEW.name);
    end if;
end;

select *
from "AUDIT";

insert into LABA15(id, name)
values (1, 'name1');

drop table LABA15;
--. Добавьте триггер, запрещающий удаление исходной таблицы.
create or replace trigger LABA15_Before_DROP
    before drop
    on SCHEMA
begin
    if ORA_DICT_OBJ_NAME = 'LABA15' then
        raise_application_error(-20000, 'Нельзя удалять таблицу LABA15');
    end if;
end;
drop trigger LABA15_Before_DROP;
drop table "AUDIT";

create or replace view lab_view as
SELECT *
FROM LABA15;

CREATE OR REPLACE TRIGGER instead_trigg
    instead of insert
    on lab_view
BEGIN
    if inserting then
        dbms_output.put_line('instead_trigg');
        insert into LABA15 VALUES (1000, 'test');
    end if;
END instead_trigg;

select *
from lab_view;

insert into LAB_VIEW
values (1, '1000');


create or replace trigger BEFORE_DELETE
    before delete
    on LABA15
begin
    if Deleting then
        DBMS_OUTPUT.PUT_LINE('BEFORE_DELETE');
    end if;
end;

delete
from LABA15
where id = 1;