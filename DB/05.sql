alter session set "_ORACLE_SCRIPT"= true;

--1. Получите список всех файлов табличных пространств (перманентных  и временных
select tablespace_name, contents from DBA_TABLESPACES;

--2. Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline. Затем переведите табличное пространство в состояние online. Выделите пользователю XXX кво   ту 2m в пространстве XXX_QDATA. От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов, один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.

create tablespace ZDA_QDATA offline
datafile 'TS_ZDA_QDATA.dbf' size 10m reuse
autoextend on next 5 m
maxsize 20 m;


alter tablespace ZDA_QDATA online;


create user ZDA identified by ZDA;
grant create session to ZDA;
grant create table to ZDA;


alter user ZDA quota 2m on ZDA_QDATA;

drop user ZDA cascade;



--3. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. Определите остальные сегменты.

select * from DBA_SEGMENTS where tablespace_name='ZDA_QDATA';
select * from dba_segments;

--4. Удалите (DROP) таблицу XXX_T1. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. Выполните SELECT-запрос к представлению USER_RECYCLEBIN, поясните результат.

select * from DBA_SEGMENTS where tablespace_name='ZDA_QDATA';


--5. Восстановите (FLASHBACK) удаленную таблицу.









--8. Удалите табличное пространство XXX_QDATA и его файл.
drop tablespace ZDA_QDATA including contents and datafiles;

--9. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.
select * from v$log;

--10. Получите перечень файлов всех журналов повтора инстанса
select * from v$logfile;

--11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).

alter system switch logfile;
select * from v$log;

--12. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала. Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением). Проследите последовательность SCN.


alter database add logfile group 4 'REDO04.log'
    size 50 m blocksize 512;
alter database add logfile member
      'REDO041.LOG' reuse  to group 4;
alter database add logfile member
    'REDO042.LOG'  reuse to group 4;

--13. EX. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.
alter system checkpoint;
alter database drop  logfile member 'REDO04.LOG';
alter database drop logfile member 'REDO042.LOG';
alter database drop logfile member 'REDO041.LOG';
alter database drop logfile group 4 ;




--14. Определите, выполняется или нет архивирование журналов повтора (архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).

select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;

--15. Определите номер последнего архива

select *from v$log;
select * from v$archived_log;
--16. EX.  Включите архивирование.

--17. EX. Принудительно создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии. Проследите последовательность SCN в архивах и журналах повтора.
alter system switch logfile;
select * from v$archived_log;

--18. EX. Отключите архивирование. Убедитесь, что архивирование отключено.
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;
--19. Получите список управляющих файлов.
select * from v$controlfile;
--20. Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.
show parameter control;
select * from v$controlfile_record_section;
--21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла.

--22. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните известные вам параметры в файле.
create pfile = 'ZDA_pfile.ora' from spfile;

---- 23: расположение файла паролей инстанса:
select * from v$pwfile_users;
show parameter remote_login_passwordfile;
---- 24: перечень директориев для файлов сообщений и диагностики
select * from v$diag_info;


--25. EX. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML), найдите в нем команды переключения журналов которые вы выполняли.







