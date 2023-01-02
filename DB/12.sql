--  �������� ������ �������������� � ���� ������� �.�.

select teacher_name
from TEACHER;
select regexp_substr(teacher_name, '(\S+)', 1, 1) || ' ' ||
       substr(regexp_substr(teacher_name, '(\S+)', 1, 2), 1, 1) || '. ' ||
       substr(regexp_substr(teacher_name, '(\S+)', 1, 3), 1, 1) || '. '
from teacher;

--3. �������� ������ ��������������, ���������� � �����������.

select teacher_name, BIRTHDAY
from TEACHER
where to_char(BIRTHDAY, 'D') = '1';

--4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.

create or replace view TEACHER_NEXT_MONTH as
select teacher_name
from TEACHER
where TO_CHAR(ADD_MONTHS(sysdate, 1), 'mm') = TO_CHAR(birthday, 'mm');

--5. �������� �������������, � ������� ��������� ���������� ��������������, ������� �������� � ������ ������.

create view TEACHER_COUNT_BY_MONTH as
select to_char(BIRTHDAY, 'MM') as MONTH, count(*) as COUNT
from TEACHER
group by to_char(BIRTHDAY, 'MM');

--6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.

declare
    cursor c1 is
        select teacher_name
        from TEACHER
        where MOD((TO_CHAR(sysdate, 'yyyy') - TO_CHAR(birthday, 'yyyy') + 1), 10) = 0;
begin
    for i in c1
        loop
            dbms_output.put_line(i.teacher_name);
        end loop;
end;

--7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����
-- , ������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.

declare
    cursor c2 is
        select TEACHER.PULPIT, floor(avg(SALARY)) as SALARY
        from TEACHER
        group by TEACHER.PULPIT;
    cursor c3 is
        select P.FACULTY, floor(avg(SALARY)) as SALARY
        from TEACHER
                 inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
        group by P.FACULTY;
    cursor c4 is
        select floor(avg(SALARY)) as SALARY
        from TEACHER;

begin
    for i in c2
        loop
            dbms_output.put_line(i.PULPIT || ' ' || i.SALARY);
        end loop;
    DBMS_OUTPUT.PUT_LINE('-----------------');
    for i in c3
        loop
            dbms_output.put_line(i.FACULTY || ' ' || i.SALARY);
        end loop;
    DBMS_OUTPUT.PUT_LINE('-----------------');
    for i in c4
        loop
            dbms_output.put_line(i.SALARY);
        end loop;
end;

-- �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. ����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������.
declare
    type SalaryAndYears is record
                           (
                               salary     teacher.SALARY%type,
                               experience number(10)
                           );
    type CustomTeacher is record
                          (
                              name teacher.teacher_name%type,
                              pulp teacher.pulpit%type,
                              info SalaryAndYears
                          );
    example CustomTeacher;

begin
    select teacher_name, pulpit
    into example.name, example.PULP
    from teacher
    where teacher = '���';
    example.info.salary := 9999;
    example.info.experience := 999;
    DBMS_OUTPUT.PUT_LINE(example.info.salary || ' ' || example.info.experience || example.name || example.PULP);

end;








