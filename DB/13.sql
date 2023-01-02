--1. ������������ ��������� ���������
-- GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE)
-- ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.

declare
    procedure get_teachers(pcode teacher.pulpit%type) as
    begin
        for i in (select * from teacher where pulpit = pcode)
            loop
                dbms_output.put_line(i.TEACHER_NAME);
            end loop;
    end get_teachers;
begin
    get_teachers('����');
end;



-- 3. GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE)
-- RETURN NUMBER
-- ������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
declare
    function GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE) return number
        is
        num number := 0;
    begin
        select count(*) into num from TEACHER where PULPIT = PCODE;
        return num;
    end GET_NUM_TEACHERS;
begin
    dbms_output.put_line(GET_NUM_TEACHERS('����'));
end;

-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- ��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.

create or replace procedure get_teachers(fcode faculty.faculty%type) as
begin
    for i in (select *
              from teacher
                       inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
                       inner join FACULTY F on F.FACULTY = P.FACULTY
              where F.FACULTY = fcode)
        loop
            dbms_output.put_line(i.TEACHER_NAME);
        end loop;
end;

call get_teachers('����');

create or replace procedure get_subjects(pcode subject.pulpit%type) as
begin
    for i in (select *
              from subject
                       inner join PULPIT P on P.PULPIT = SUBJECT.PULPIT
              where P.PULPIT = pcode)
        loop
            dbms_output.put_line(i.SUBJECT_NAME);
        end loop;
end;

call get_subjects('����');

--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- RETURN NUMBER
-- ������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ �������� ���������� ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� ���������. ������������ ��������� ���� � ����������������� ���������� ���������.

declare
    function get_num_teachers(fcode faculty.faculty%type) return number
        is
        num number := 0;
    begin
        select count(*)
        into num
        from teacher
                 inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
                 inner join FACULTY F on F.FACULTY = P.FACULTY
        where F.FACULTY = fcode;
        return num;
    end get_num_teachers;
begin
    dbms_output.put_line(get_num_teachers('����'));
end;

create or replace function get_num_subjects(pcode subject.pulpit%type) return number
    is
    num number := 0;
begin
    select count(*)
    into num
    from subject
             inner join PULPIT P on P.PULPIT = SUBJECT.PULPIT
    where P.PULPIT = pcode;
    return num;
end;

begin
    dbms_output.put_line(get_num_subjects('����'));
end;

-- //������������ ����� TEACHERS, ���������� ��������� � �������:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER

create or replace package teachers as
    procedure get_teachers(fcode faculty.faculty%type);
    procedure get_subjects(pcode subject.pulpit%type);
    function get_num_teachers(fcode faculty.faculty%type) return number;
    function get_num_subjects(pcode subject.pulpit%type) return number;
end;

CREATE OR REPLACE PACKAGE BODY TEACHERS AS
    PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) AS
    begin
        for i in (select *
                  from teacher
                           inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
                           inner join FACULTY F on F.FACULTY = P.FACULTY
                  where F.FACULTY = fcode)
            loop
                dbms_output.put_line(i.TEACHER_NAME);
            end loop;
    end GET_TEACHERS;
    procedure get_subjects(pcode subject.pulpit%type) as
    begin
        for i in (select *
                  from subject
                           inner join PULPIT P on P.PULPIT = SUBJECT.PULPIT
                  where P.PULPIT = pcode)
            loop
                dbms_output.put_line(i.SUBJECT_NAME);
            end loop;
    end get_subjects;
    function get_num_teachers(fcode faculty.faculty%type) return number as
        num number := 0;
    begin
        select count(*)
        into num
        from teacher
                 inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
                 inner join FACULTY F on F.FACULTY = P.FACULTY
        where F.FACULTY = fcode;
        return num;
    end get_num_teachers;
    function get_num_subjects(pcode subject.pulpit%type) return number as
        num number := 0;
    begin
        select count(*)
        into num
        from subject
                 inner join PULPIT P on P.PULPIT = SUBJECT.PULPIT
        where P.PULPIT = pcode;
        return num;
    end;
end TEACHERS;


--7. ������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.

begin
    teachers.get_teachers('����');
    teachers.get_subjects('����');
    dbms_output.put_line(teachers.get_num_teachers('����'));
    dbms_output.put_line(teachers.get_num_subjects('����'));
end;




