create table ZDA_T1 (id number(10), name varchar2(20),primary key(id) ) tablespace ZDA_QDATA;
insert into ZDA_T1 values (1,'ZDA');
insert into ZDA_T1 values (2,'DAZ');
insert into ZDA_T1 values (3,'AZD');

select * from ZDA_T1;

drop table ZDA_T1  ;


select * from user_recyclebin;

flashback table ZDA_T1 to before drop;

--6. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк).
begin
  for x in 4..10004
  loop
    insert into ZDA_T1 values(x, x);
  end loop;
end;


--7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов.


select * from user_extents
where tablespace_name = 'ZDA_QDATA';

select segment_name, segment_type,
    tablespace_name, bytes, blocks, extents
from user_segments where tablespace_name = 'ZDA_QDATA';

