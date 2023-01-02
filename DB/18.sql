create table table_for_load
(
    id     number(10, 4),
    name   varchar2(20),
    b_date date
);
select * from table_for_load;
drop table table_for_load;

sqlldr system/root CONTROL=lab18.ctl


spool /opt/oracle/export.txt
select id || ',' || name || ',' || b_date
from table_for_load;
