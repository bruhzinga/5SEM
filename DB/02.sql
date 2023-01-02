alter session set "_ORACLE_SCRIPT"=TRUE;

--Задание 1. Создайте табличное пространство для постоянных данных со следующими параметрами:
create tablespace TS_ZDA
datafile 'TS_ZDA.dbf'
size 7 m
autoextend on next 5 m
maxsize 20 m;

-- Задание 2. Создайте табличное пространство для временных данных со следующими параметрами:
create  temporary tablespace TS_ZDA_TEMP
TEMPFILE 'TS_ZDA_TEMP.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m;

drop tablespace TS_ZDA including contents and datafiles;
drop tablespace TS_ZDA_TEMP including contents and datafiles;
--Задание 3. Получите список всех табличных пространств, списки всех файлов с помощью select-запроса к словарю.


select TABLESPACE_NAME,STATUS, contents logging from SYS.DBA_TABLESPACES;

select FILE_NAME,TABLESPACE_NAME,STATUS, MAXBYTES,USER_BYTES from DBA_DATA_FILES
UNION
SELECT FILE_NAME,TABLESPACE_NAME,STATUS, MAXBYTES,USER_BYTES from DBA_TEMP_FILES;

--Задание 4. Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
create role RL_ZDACORE;
grant create session, create table, create view, create procedure to RL_ZDACORE;
grant drop any table, drop any view, drop any procedure to RL_ZDACORE;

--Задание 5. Найдите с помощью select-запроса роль в словаре. Найдите с помощью select-запроса все системные привилегии, назначенные роли.

select * from DBA_ROLES where role='RL_ZDACORE';
select * from DBA_SYS_PRIVS where grantee='RL_ZDACORE';

--Задание 6. Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные примеру из лекции.
create profile PF_ZDACORE limit
  password_life_time 180
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 30;
  --Задание 7. Получите список всех профилей БД. Получите значения всех параметров профиля PF_XXXCORE. Получите значения всех параметров профиля DEFAULT.
select * from DBA_PROFILES;
select * from DBA_PROFILES where profile='PF_ZDACORE';
select * from DBA_PROFILES where profile='DEFAULT';

--Создайте пользователя с именем XXXCORE со следующими параметрами:
create user ZDACORE identified by 12345
  default tablespace TS_ZDA         --тп по умолч
        quota unlimited on TS_ZDA   --бескон квота
  temporary tablespace TS_ZDA_TEMP --тп для врем. д-х
  profile PF_ZDACORE                --профиль безоп
  account unlock                    --уч.запись разблок
  password expire;   --срок пароля истек
GRANT RL_ZDACORE TO ZDACORE; --назначить роль

drop user ZDACORE cascade ;



select tablespace_name from dba_tablespaces order by 1;

commit;
select * from DBA_USERS;


--Задание 10. Создайте соединение с помощью SQL Developer для пользователя XXXCORE. Создайте любую таблицу и любое представление.



--Задание 11. Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline. Затем переведите табличное пространство в состояние online. Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. От имени пользователя XXX создайте таблицу в пространстве XXX_T1. В таблицу добавьте 3 строки.

create tablespace TS_ZDA_QDATA offline
datafile 'TS_ZDA_QDATA_1.dbf' size 10m reuse
autoextend on next 5 m
maxsize 20 m;

select TABLESPACE_NAME,STATUS, contents logging from SYS.DBA_TABLESPACES;

alter tablespace TS_ZDA_QDATA online;

alter user ZDACORE quota 2m on TS_ZDA_QDATA;






