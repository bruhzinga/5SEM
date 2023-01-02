-- 1: общий размер области SGA
select * from v$sga;
select sum(value) from v$sga;

-- 2: текущие размеры основных пулов SGA
select * from v$sga_dynamic_components where current_size > 0;

-- 3: размеры гранулы для каждого пула
select component, current_size, max_size,
    granule_size, current_size/granule_size as ratio
from v$sga_dynamic_components where current_size > 0;

-- 4: объем доступной свободной памяти в SGA
select current_size from v$sga_dynamic_free_memory;

-- 5: размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша
select component, min_size, current_size, max_size
from v$sga_dynamic_components where component like '%cache%';

-- 6: создать таблицу, которая будут помещаться в пул КЕЕP
create table Keep(k int) storage(buffer_pool keep) tablespace users;
insert into Keep values (4);
commit;


select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where SEGMENT_NAME = 'KEEP';

-- 7: создать таблицу, которая будут кэшироваться в пуле DEFAULT
create table DDefault(k int) cache storage(buffer_pool default) tablespace users;
insert into DDefault values (7);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like 'DD%';

-- 8: размер буфера журналов повтора
show parameter log_buffer;
-- 9: 10 самых больших объектов в разделяемом пуле
select * from v$sgastat where pool = 'shared pool'
order by bytes desc fetch first 10 rows only;

-- 10: размер свободной памяти в большом пуле
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11 и 12 : перечень текущих соединений с инстансом + их режимы
select username, service_name, server from v$session where username is not null;

-- 13: самые часто используемые объекты в базе данных
select owner, name, type, executions from v$db_object_cache order by executions desc;