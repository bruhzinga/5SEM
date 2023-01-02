--1. полный список фоновых процессов
select name, description from v$bgprocess;

--2. Определите фоновые процессы, которые запущены и работают в настоящий момент.
select * from v$bgprocess where paddr!=hextoraw('00'); 

--3.	Определите, сколько процессов DBWn работает в настоящий момент.
show parameter db_writer_processes;
select count(*) from v$session where program like '%DBW%';

--4. перечень текущих соединений с инстансом.
select * from v$session where username is not null;

--5. Определите режимы этих соединений
select username, server from v$session where username is not null;

--6  Определите сервисы (точки подключения экземпляра).
select * from V$SERVICES ;  

--7.	Получите известные вам параметры диспетчера и их значений.
SELECT * FROM V$DISPATCHER;
show parameter DISPATCHERS;
--9.	Получите перечень текущих соединений с инстансом. (dedicated, shared). 
SELECT USERNAME,SERVER FROM V$SESSION;

--10.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 

--11.	Запустите утилиту lsnrctl и поясните ее основные команды. 
--lsnrctl status, start, stop

-- 12: список служб инстанса, обслуживаемых процессом LISTENER
-- lsnrctl -> services