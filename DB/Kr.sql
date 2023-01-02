select *
from V$INSTANCE;

--2
select *
from DBA_TABLESPACES;

--3
select *
from DBA_USERS;

-- 4 Размер данных в тадблице
select *
from dba_segments
where segment_name = 'TABLE_NAME';

--5 количсетво блоков в таблице
select *
from USER_SEGMENTS;

--6
select *
from V$PARAMETER;

--7
select *
from V$LOG;

--8 check if arhivelog is enabled
select *
from V$ARCHIVED_LOG;


--9
select *
from V$SGA;

--10  get granule size
select *
from v$parameter
where name = 'db_block_size';

--11 get all processes currently active
select *
from V$PROCESS p,
     V$SESSION s
where p.addr = s.paddr;
