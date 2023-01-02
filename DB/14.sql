CREATE DATABASE LINK VASYA
    CONNECT TO customer
        IDENTIFIED BY qwerty
    USING 'DESKTOP-8T2LUTM:1521/XE';

-------------------------------------------
drop database link VASYA;
alter session set "_ORACLE_SCRIPT"= true;
------------------------------------------
CREATE PROFILE CUSTOMER_PROFILE LIMIT PASSWORD_LIFE_TIME 180 SESSIONS_PER_USER 20 FAILED_LOGIN_ATTEMPTS 7 PASSWORD_LOCK_TIME 1 PASSWORD_REUSE_TIME 10 PASSWORD_GRACE_TIME DEFAULT CONNECT_TIME 180 IDLE_TIME 30;
DROP USER CUSTOMER;
CREATE USER customer IDENTIFIED BY qwerty
    DEFAULT TABLESPACE USERS
    PROFILE CUSTOMER_PROFILE
    QUOTA UNLIMITED ON USERS;
DROP ROLE CUSTOMER_ROLE;
CREATE ROLE CUSTOMER_ROLE;
-----------------------------------------------
grant connect, resource to customer;
grant execute on TEST_PACKAGE to CUSTOMER;

create table TIMOHA
(
    id number(10)
);

------------------------------------------
select *
from TIMOHA;

insert into qqqa@VASYA
values (151);

update qqqa@VASYA
set c = 15;


delete
from qqqa@VASYA
where c = 2;

--------------------------------------------------------
select *
from CUSTOMER.TEST;


------------------------------------------------

begin
    /*dbms_output.put_line(sys.TEST_PACKAGE.test_proc@VASYA());*/
    sys.TEST_PACKAGE.test_p@VASYA();
end;
---------------------------


create or replace package TEST_PACKAGE as
    function test_func return number;
    procedure test_proc;
end TEST_PACKAGE;

create or replace package body TEST_PACKAGE as
    function test_func return number as
    begin
        return 2;
    end;
    procedure test_proc as
    begin
        insert into TIMOHA values (1337);
    end ;
end TEST_PACKAGE;
-------------------------------------


--change container
alter session set container = cdb$root;

--------------------------------------
CREATE Public DATABASE LINK VASYA
    CONNECT TO customer
        IDENTIFIED BY qwerty
    USING 'DESKTOP-8T2LUTM:1521/XE';
drop public database link VASYA;



