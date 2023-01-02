CREATE OR REPLACE PROCEDURE display_offices_by_sales(date_start IN DATE, date_end IN DATE)
AS
BEGIN
    if date_start > date_end then
        RAISE_APPLICATION_ERROR(-20001, 'Start date cant be more than end date');
    end if;
    DBMS_OUTPUT.PUT_LINE('Offices for ' || date_start || ' - ' || date_end || ':');
    FOR r IN (SELECT O.OFFICE, SUM(O.AMOUNT) AS TOTAL_SALES
              FROM ORDERS O
                       join SALESREPS S2 on S2.EMPL_NUM = O.REP
                       join OFFICES O on O.OFFICE = S2.REP_OFFICE
              WHERE O.ORDER_DATE between date_start and date_end
              GROUP BY O.OFFICE
              ORDER BY TOTAL_SALES DESC)

        LOOP
            DBMS_OUTPUT.PUT_LINE(r.OFFICE || ': ' || r.TOTAL_SALES);
        END LOOP;

EXCEPTION
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('Invalid number');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unknown error');
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || ' - ' || SQLERRM);

END;

BEGIN
    display_offices_by_sales(to_date('01.01.2006', 'dd.mm.yyyy'),
                             to_date('01.01.2020', 'dd.mm.yyyy'));
END;

create or replace FUNCTION count_orders_by_period(date_start IN DATE, date_end IN DATE)
    RETURN NUMBER
as
    amount number(10);
begin
    if date_start > date_end then
        RAISE_APPLICATION_ERROR(-20001, 'Start date cant be more than end date');
    end if;
    select COUNT(*)
    into amount
    from ORDERS
    where ORDER_DATE
              between date_start and date_end;
    return amount;

EXCEPTION
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('Invalid number');
        return 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || ' - ' || SQLERRM);
        return 0;
end;



begin
    dbms_output.put_line(count_orders_by_period(to_date('01.01.2001', 'dd.mm.yyyy'),
                                                to_date('01.01.2022', 'dd.mm.yyyy')));
end;

