--1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой
declare
    fac faculty%rowtype;
begin
    select * into fac from faculty where faculty = 'ИЭФ';
    dbms_output.put_line(fac.faculty || ' ' || fac.faculty_name);
end;
--2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной выборкой. Используйте конструкцию WHEN OTHERS секции исключений и встроенную функции SQLERRM, SQLCODE для диагностирования неточной выборки
--3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS секции исключений для диагностирования неточной выборки.
--4. Разработайте АБ, демонстрирующий возникновение и обработку исключения NO_DATA_FOUND. Разработайте АБ, демонстрирующий применение атрибутов неявного курсора.

declare
    auditor AUDITORIUM%rowtype;
begin
    --select * into fac from faculty;     --кол-во строк > запрош
    select * into auditor from AUDITORIUM where AUDITORIUM_TYPE = 'ЛК';
exception
    when no_data_found
        then dbms_output.put_line('Данные не надйены');
    when too_many_rows
        then dbms_output.put_line('В результате несколько строк');
    when others
        then dbms_output.put_line(sqlerrm);
end;
--5. Разработайте АБ, демонстрирующий применение оператора UPDATE совместно с операторами COMMIT/ROLLBACK.
--5
begin
    update auditorium set auditorium = '207-1' where auditorium = '206-1';
    --insert into auditorium values ('301-9', '301-1', 90, 'ЛК');
    --delete from auditorium where auditorium = '301-8';
    --rollback;

    if sql%found then dbms_output.put('found '); end if;
    if sql%isopen then dbms_output.put('opened '); end if;
    if sql%notfound then dbms_output.put('not found '); end if;
    dbms_output.put_line('Измененных столбцов ' || sql%rowcount);
    rollback;
exception
    when others then dbms_output.put_line('error = ' || sqlerrm);
end;

select *
from auditorium
where auditorium like '206%';

--6
declare

    auditorium_rec auditorium%rowtype;
begin
    update auditorium
    set auditorium_capacity = 'anything'
    where auditorium = '206-3';
exception
    when others
        then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;


--8
declare
    auditorium_rec auditorium%rowtype;
begin
    insert into auditorium VALUES ('206-4', '206-4', 'NAN', 'ЛК');
    commit;
exception
    when others
        then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;


--10
declare
    

    auditorium_rec auditorium%rowtype;
begin
    delete from auditorium_type where auditorium_type = 'ЛК';
exception
    when others
        then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;


--11. Создайте анонимный блок, распечатывающий таблицу TEACHER с применением явного курсора LOOP-цикла. Считанные данные должны быть записаны в переменные, объявленные с применением опции %TYPE.
declare
    cursor curs_teachers is select TEACHER, TEACHER_NAME, PULPIT
                            from TEACHER;
    teach       TEACHER.teacher%type;
    teacherName TEACHER.teacher_name%type;
    pulpit      TEACHER.pulpit%type;
begin
    open curs_teachers;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    loop
        fetch curs_teachers into teach, teacherName, pulpit;
        exit when curs_teachers%notfound;
        dbms_output.put_line(' ' || curs_teachers%rowcount || ' ' || teach || ' ' || teacherName || ' ' || pulpit);
    end loop;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    close curs_teachers;
exception
    when others
        then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end ;

--12. Создайте АБ, распечатывающий таблицу SUBJECT с применением явного курсора WHILE-цикла. Считанные данные должны быть записаны в запись (RECORD) объявленную с применением опции %ROWTYPE.
declare
    cursor curs_subject is select*
                           from subject;
    rec_subject subject%rowtype;
begin
    open curs_subject;
    dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
    fetch curs_subject into rec_subject;
    while curs_subject%found
        loop
            dbms_output.put_line(' ' || curs_subject%rowcount || ' ' || rec_subject.subject || ' ' ||
                                 rec_subject.subject_name || ' ' || rec_subject.pulpit);
            fetch curs_subject into rec_subject;
        end loop;
    dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
    close curs_subject;
exception
    when others
        then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;

--13. Создайте АБ, распечатывающий все кафедры (таблица PULPIT) и фамилии всех преподавателей (TEACHER) использовав, соединение (JOIN) PULPIT и TEACHER и с применением явного курсора и FOR-цикла.
declare
    cursor cur
        is select pulpit.pulpit, teacher.teacher_name
           from pulpit
                    inner join teacher on pulpit.pulpit = teacher.pulpit;
begin
    for rec in cur
        loop
            dbms_output.put_line(cur%rowcount || ' ' || rec.teacher_name || ' ' || rec.pulpit);
        end loop;
end;
--14. Создайте АБ, распечатывающий следующие списки аудиторий: все аудитории (таблица AUDITORIUM) с вместимостью меньше 20, от 21-30, от 31-60, от 61 до 80, от 81 и выше. Примените курсор с параметрами и три способа организации цикла по строкам курсора.
declare
    cursor cur(firstCapacity auditorium.auditorium%type,secondCapacity auditorium.auditorium%type)
        is select auditorium, auditorium_capacity
           from auditorium
           where auditorium_capacity >= firstCapacity
             and AUDITORIUM_CAPACITY <= secondCapacity;
    rec cur%rowtype;
begin
    dbms_output.put_line('Вместимость <20 :');
    open cur(0, 20);
    loop
        fetch cur into rec;
        exit when cur%notfound;
        dbms_output.put(rec.auditorium || ' ');
    end loop;
    close cur;

    dbms_output.put_line(chr(10) || 'Вместимость 20-30 :');
    open cur(0, 20);
    while cur%found
        loop
            fetch cur into rec;
            dbms_output.put(rec.auditorium || ' ');
        end loop;
    close cur;
    dbms_output.put_line(chr(10) || 'Вместимость 30-60 :');
    for aum in cur(31, 60)
        loop
            dbms_output.put(aum.auditorium || ' ');
        end loop;
    dbms_output.put_line(chr(10) || 'Вместимость 60-80 :');
    for aum in cur(61, 80)
        loop
            dbms_output.put(aum.auditorium || ' ');
        end loop;
    dbms_output.put_line(chr(10) || 'Вместимость выше 80 :');
    for aum in cur(81, 1000)
        loop
            dbms_output.put(aum.auditorium || ' ');
        end loop;
end;

--15. Создайте AБ. Объявите курсорную переменную с помощью системного типа refcursor
declare
    type ref_cur is ref cursor return teacher%rowtype;
    cur ref_cur;
    rec TEACHER%rowtype;
begin
    open cur for select * from UNI.TEACHER;
    fetch cur into rec;
    while cur%found
        loop
            dbms_output.put_line(rec.TEACHER_NAME);
            fetch cur into rec;
        end loop;
end;


--16 Создайте AБ. Продемонстрируйте понятие курсорный подзапрос?
declare
    cursor curs_aut is select auditorium_type,
                              cursor (select auditorium
                                      from auditorium aum
                                      where aut.auditorium_type = aum.auditorium_type)
                       from auditorium_type aut;
    curs_aum sys_refcursor;
    aut      auditorium_type.auditorium_type%type;
    txt      varchar2(1000);
    aum      auditorium.auditorium%type;
begin
    open curs_aut;
    fetch curs_aut into aut, curs_aum;
    while(curs_aut%found)
        loop
            txt := rtrim(aut) || ':';
            loop
                fetch curs_aum into aum;
                exit when curs_aum%notfound;
                txt := txt || ',' || rtrim(aum);
            end loop;
            dbms_output.put_line(txt);
            fetch curs_aut into aut, curs_aum;
        end loop;
    close curs_aut;
exception
    when others
        then dbms_output.put_line(sqlerrm);
end;
--17 Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM) вместимостью от 40 до 80 на 10%. Используйте явный курсор с параметрами, цикл FOR, конструкцию UPDATE CURRENT OF.
declare
    cursor auditoriumCursor(firstCapacity auditorium.auditorium%type,secondCapacity auditorium.auditorium%type)
        is select auditorium, auditorium_capacity
           from auditorium
           where auditorium_capacity >= firstCapacity
             and AUDITORIUM_CAPACITY <= secondCapacity for update ;
begin
    for aum in auditoriumCursor(40, 80)
        loop
            update auditorium
            set auditorium_capacity = aum.auditorium_capacity * 0.9
            where current of auditoriumCursor;
        end loop;
end;
--18. Создайте AБ. Удалите все аудитории (таблица AUDITORIUM) вместимостью от 0 до 20. Используйте явный курсор с параметрами, цикл WHILE, конструкцию UPDATE CURRENT OF.
declare
    cursor auditoriumCursor(firstCapacity auditorium.auditorium%type,secondCapacity auditorium.auditorium%type)
        is select auditorium, auditorium_capacity
           from auditorium
           where auditorium_capacity >= firstCapacity
             and AUDITORIUM_CAPACITY <= secondCapacity for update ;
begin
    open auditoriumCursor(0, 20);
    while auditoriumCursor%found
        loop
            delete
            from auditorium
            where current of auditoriumCursor;
        end loop;
    close auditoriumCursor;
end;
--19.Создайте AБ. Продемонстрируйте применение псевдостолбца ROWID в операторах UPDATE и DELETE.
declare
    cursor cur(capacity auditorium.auditorium%type)
        is select auditorium, auditorium_capacity, rowid
           from auditorium
           where auditorium_capacity >= capacity for update;
    aum auditorium.auditorium%type;
    cap auditorium.auditorium_capacity%type;
begin
    for xxx in cur(80)
        loop
            if xxx.auditorium_capacity >= 90
            then
                delete auditorium where rowid = xxx.rowid and xxx.auditorium_capacity >= 90;
            elsif xxx.auditorium_capacity >= 40
            then
                update auditorium
                set auditorium_capacity = auditorium_capacity + 3
                where rowid = xxx.rowid;
            end if;
        end loop;
    for yyy in cur(80)
        loop
            dbms_output.put_line(yyy.auditorium || ' ' || yyy.auditorium_capacity);
        end loop;
    rollback;
end;
--20 Распечатайте в одном цикле всех преподавателей (TEACHER), разделив группами по три (отделите группы линией -------------).
declare
    cursor teacherCursor
        is select teacher, teacher_name, PULPIT
           from teacher;
begin
    for aum in teacherCursor
        loop
            dbms_output.put_line(' ' || teacherCursor%rowcount || ' ' || aum.TEACHER || ' ' || AUM.TEACHER_NAME ||
                                 ' ' || AUM.PULPIT);
            if (mod(teacherCursor%rowcount, 3) = 0) then
                dbms_output.put_line('------------------------------------------------');
            end if;
        end loop;
end;