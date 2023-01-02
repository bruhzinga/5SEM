create table ZDA_t( x number(3) primary key ,s varchar2(50));

-- 11. Дополните скрипт операторами INSERT, добавляющими 3 строки в таблицу XXX_t. Выполните операторы INSERT. Выполните оператор COMMIT;
insert into ZDA_t values(1,'a');
insert into ZDA_t values(2,'b');
insert into ZDA_t values(3,'c');
select * from ZDA_t;
commit ;
--12. Дополните скрипт оператором UPDATЕ, изменяющим 2 строки в таблице XXX_t. Выполните оператор UPDATЕ. Выполните оператор COMMIT;
update ZDA_t set s='d' where x=1;
update ZDA_t set s='e' where x=2;
commit;
select * from ZDA_t;
--13. Дополните скрипт операторами SELECT (выборка по условию, применение агрегатных функций);
select * from ZDA_t where x=1;
select count(*) from ZDA_t;
--14. Дополните скрипт операторами DELETE, удаляющими 1 строки в таблице XXX_t. Выполните оператор DELETE. Выполните оператор COMMIT;
delete from ZDA_t where x=3;
commit;
select * from ZDA_t;
--15. Создайте таблицу XXX_t1, связанную отношением внешнего ключа с таблицей XXX_t. Добавьте данные в таблицу XXX_t1.
create table ZDA_t1(
    x1 number(3),
    s1 varchar2(50),
     constraint key_foreign foreign key (x1) references ZDA_t(x));
insert into ZDA_t1 values(1,'a');
insert into ZDA_t1 values(2,'b');
commit;
select * from ZDA_t1;
--16. Дополните скрипт операторами SELECT из обеих таблиц (левое и правое соединение, внутреннее соединение);

select * from ZDA_t;
select * from ZDA_t1;

select * from ZDA_t left join ZDA_t1 on ZDA_t.x=ZDA_t1.x1;
select * from ZDA_t right join ZDA_t1 on ZDA_t.x=ZDA_t1.x1;
select * from ZDA_t inner join ZDA_t1 on ZDA_t.x=ZDA_t1.x1;
--18. Дополните скрипт оператором DROP, удаляющим таблицы XXX_t, XXX_t1.
drop table  ZDA_t;
drop table ZDA_t1;

