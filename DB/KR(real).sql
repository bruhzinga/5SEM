--Создайте процедуру, которая выводит список заказов и их итоговую стоимость для определенного офиса (OFFICES). Параметр – наименование офиса. Обработайте возможные ошибки.
CREATE OR REPLACE PROCEDURE display_orders_by_office(office_number IN OFFICES.OFFICE%TYPE)
AS
    office_name OFFICES.CITY%TYPE;
BEGIN
    -- Validate the input office number
    SELECT (select CITY
            FROM OFFICES
            WHERE OFFICE = office_number)
    INTO office_name
    from dual;

    -- If no office is found, raise an exception
    IF office_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Office not found');
    END IF;

    -- Display the orders and their total cost for the specified office
    DBMS_OUTPUT.PUT_LINE('Orders for ' || office_number || ' office:');
    FOR r IN ( select ORDERS.ORDER_NUM, ORDERS.AMOUNT as TOTAL
               from orders
                        join SALESREPS S2 on S2.EMPL_NUM = ORDERS.REP
                        join OFFICES O on O.OFFICE = S2.REP_OFFICE
               where O.OFFICE = office_number

               order by ORDER_NUM)

        LOOP
            DBMS_OUTPUT.PUT_LINE(r.ORDER_NUM || ' ' || r.TOTAL);
        END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No orders found for ' || office_number || ' office');
    WHEN INVALID_NUMBER
        THEN DBMS_OUTPUT.PUT_LINE('Invalid office number');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' ' || SQLERRM);

END;


BEGIN
    display_orders_by_office(23);
END;

--Создайте функцию, которая подсчитывает количество заказов для определенного офиса (OFFICES) за определенный период. Параметры – код офиса, дата начала периода, дата окончания периода. Обработайте возможные ошибки.

CREATE OR REPLACE FUNCTION count_orders_by_office(office_number IN OFFICES.OFFICE%TYPE, date_start IN DATE,
                                                  date_end IN DATE)
    RETURN NUMBER
AS
    office_name   OFFICES.CITY%TYPE;
    l_order_count NUMBER;
BEGIN
    -- Validate the input office number
    SELECT (select CITY
            FROM OFFICES
            WHERE OFFICE = office_number)
    INTO office_name
    from dual;

    -- If no office is found, raise an exception
    IF office_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Office not found');
    END IF;

    -- Count the number of orders for the specified office and period
    SELECT COUNT(*)
    INTO l_order_count
    from orders
             join SALESREPS S2 on S2.EMPL_NUM = ORDERS.REP
             join OFFICES O on O.OFFICE = S2.REP_OFFICE
    where O.OFFICE = office_number
      and ORDERS.ORDER_DATE between date_start and date_end;


    -- Return the result
    RETURN l_order_count;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Orders from office 22: ' || count_orders_by_office(22, to_date('01.01.2006', 'dd.mm.yyyy'),
                                                                             to_date('01.01.2020', 'dd.mm.yyyy')));
END;
--Создайте процедуру, которая выводит список всех товаров, проданных определенным офисом (OFFICES), с указанием суммы продаж по убыванию. Параметр – город, в котором находится офис. Обработайте возможные ошибки.

CREATE OR REPLACE PROCEDURE display_products_by_office(office_number IN OFFICES.OFFICE%TYPE)
AS
    office_city OFFICES.CITY%TYPE;
BEGIN
    SELECT (select CITY
            FROM OFFICES
            WHERE OFFICE = office_number)
    INTO office_city
    from dual;

    -- If no office is found, raise an exception
    IF office_city IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Office not found');
    END IF;

    -- Display the products and their total cost for the specified office
    DBMS_OUTPUT.PUT_LINE('Products for ' || office_number || ' office:');

    FOR r IN (SELECT P.DESCRIPTION, SUM(O.AMOUNT) AS TOTAL_SALES
              FROM ORDERS O
                       join SALESREPS S2 on S2.EMPL_NUM = O.REP
                       join OFFICES O on O.OFFICE = S2.REP_OFFICE
                       join PRODUCTS P on O.PRODUCT = P.PRODUCT_ID
              WHERE O.OFFICE = office_number
              GROUP BY P.DESCRIPTION
              ORDER BY TOTAL_SALES DESC)
        LOOP
            DBMS_OUTPUT.PUT_LINE(r.DESCRIPTION || ': $' || r.TOTAL_SALES);
        END LOOP;
END;

BEGIN
    display_products_by_office(22);
END;

--Создайте функцию, которая подсчитывает общее количество заказов за определенный период. Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки.

CREATE OR REPLACE FUNCTION count_orders_by_period(date_start IN DATE, date_end IN DATE)
    RETURN NUMBER
AS
    l_order_count NUMBER;
BEGIN
    -- Count the number of orders for the specified period
    SELECT COUNT(*)
    INTO l_order_count
    from orders
    where ORDERS.ORDER_DATE between date_start and date_end;

    -- Return the result
    RETURN l_order_count;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Orders from 01.01.2006 to 01.01.2020: ' ||
                         count_orders_by_period(to_date('01.01.2006', 'dd.mm.yyyy'),
                                                to_date('01.01.2020', 'dd.mm.yyyy')));
END;

--2	Создайте процедуру, которая выводит список офисов (OFFICES), в порядке убывания общей стоимости заказов. Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки.

CREATE OR REPLACE PROCEDURE display_offices_by_sales(date_start IN DATE, date_end IN DATE)
AS
BEGIN
    -- Display the offices and their total cost for the specified period
    DBMS_OUTPUT.PUT_LINE('Offices for ' || date_start || ' - ' || date_end || ':');

    FOR r IN (SELECT O.OFFICE, SUM(O.AMOUNT) AS TOTAL_SALES
              FROM ORDERS O
                       join SALESREPS S2 on S2.EMPL_NUM = O.REP
                       join OFFICES O on O.OFFICE = S2.REP_OFFICE
              WHERE O.ORDER_DATE between date_start and date_end
              GROUP BY O.OFFICE
              ORDER BY TOTAL_SALES DESC)
        LOOP
            DBMS_OUTPUT.PUT_LINE(r.OFFICE || ': $' || r.TOTAL_SALES);
        END LOOP;
END;

BEGIN
    display_offices_by_sales(to_date('01.01.2006', 'dd.mm.yyyy'),
                             to_date('01.01.2020', 'dd.mm.yyyy'));
END;

--Создайте функцию, которая подсчитывает среднюю цену заказанных товаров за определенный период. Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки. Выведите значение функции для 2007 и 2008 годов.

CREATE OR REPLACE FUNCTION avg_order_price_by_period(date_start IN DATE, date_end IN DATE)
    RETURN NUMBER
AS
    l_avg_price NUMBER(10, 2);
BEGIN
    -- Count the average price of orders for the specified period
    SELECT AVG(O.AMOUNT)
    INTO l_avg_price
    from orders O
    where O.ORDER_DATE between date_start and date_end;

    -- Return the result
    RETURN l_avg_price;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Average order price from 01.01.2007 to 01.01.2008: ' ||
                         avg_order_price_by_period(to_date('01.01.2007', 'dd.mm.yyyy'),
                                                   to_date('01.01.2008', 'dd.mm.yyyy')));
END;

--Создайте процедуру, которая выводит список сотрудников определенного офиса (OFFICES), у которых есть заказы в этом временном периоде. Параметры – дата начала периода, дата окончания периода, код офиса. Обработайте возможные ошибки.

CREATE OR REPLACE PROCEDURE display_salesreps_by_office(date_start IN DATE, date_end IN DATE, office_code IN VARCHAR2)
AS
    office_name VARCHAR2(50);
BEGIN
    SELECT (select CITY
            FROM OFFICES
            WHERE OFFICE = office_code)
    INTO office_name
    from dual;

    -- If no office is found, raise an exception
    IF office_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Office not found');
    END IF;


    -- Display the sales representatives and their total cost for the specified period
    DBMS_OUTPUT.PUT_LINE('Sales representatives for ' || date_start || ' - ' || date_end || ':');

    FOR r IN (SELECT S.EMPL_NUM, S.NAME AS SALESREP_NAME
              FROM ORDERS O
                       join SALESREPS S on S.EMPL_NUM = O.REP
              WHERE O.ORDER_DATE between date_start and date_end
                AND S.REP_OFFICE = office_code
              GROUP BY S.EMPL_NUM, S.NAME
              ORDER BY S.NAME)
        LOOP
            DBMS_OUTPUT.PUT_LINE(r.EMPL_NUM || ': ' || r.SALESREP_NAME);
        end loop;

END;

BEGIN
    display_salesreps_by_office(to_date('01.01.2006', 'dd.mm.yyyy'),
                                to_date('01.01.2020', 'dd.mm.yyyy'),
                                12);
END;

--Создайте функцию, которая подсчитывает количество сотрудников определенного офиса (OFFICES), которые не продавали товар определенного производителя. Параметры – код офиса, производитель. Обработайте возможные ошибки.

CREATE OR REPLACE FUNCTION count_salesreps_by_office(office_code IN VARCHAR2, manufacturer IN VARCHAR2)
    RETURN NUMBER
AS
    l_salesrep_count NUMBER(10);
BEGIN
    -- Count the number of sales representatives for the specified office
    SELECT COUNT(S.EMPL_NUM)
    INTO l_salesrep_count
    from SALESREPS S
    where S.REP_OFFICE = office_code
      AND S.EMPL_NUM NOT IN (SELECT O.REP
                             FROM ORDERS O
                                      join PRODUCTS P on P.PRODUCT_ID = O.PRODUCT
                             WHERE P.MFR_ID = manufacturer);

    -- Return the result
    RETURN l_salesrep_count;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Number of sales representatives for office 12 and manufacturer 100: ' ||
                         count_salesreps_by_office(12, 'ACI'));
END;

--Создайте процедуру, которая уменьшает на N% стоимость определенного товара. Параметр – N, наименование товара, производитель. Обработайте возможные ошибки.

CREATE OR REPLACE PROCEDURE decrease_product_price(percent IN NUMBER, product_name IN VARCHAR2, manufacturer IN VARCHAR2)
AS
    l_product_id VARCHAR2(10);
BEGIN
    -- Get the product ID
    SELECT (select P.PRODUCT_ID
            from PRODUCTS P
            where P.DESCRIPTION = product_name
              AND P.MFR_ID = manufacturer)
    INTO l_product_id
    from dual;

    -- If no product is found, raise an exception
    IF l_product_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Product not found');
    END IF;

    -- Update the product price
    UPDATE PRODUCTS
    SET PRICE = PRICE * (1 - percent / 100)
    WHERE PRODUCT_ID = l_product_id;

    -- Display the result
    DBMS_OUTPUT.PUT_LINE('Product price updated');
END;

BEGIN
    decrease_product_price(10, 'Widget Remover', 'ACI');
END;

--Создайте функцию, которая вычисляет максимальную сумму заказа из выполненных в определенном году для определенного офиса (OFFICES). Параметры – город, в котором расположен офис, год. Обработайте возможные ошибки.

CREATE OR REPLACE FUNCTION max_order_amount_by_office(office_code IN VARCHAR2, year IN NUMBER)
    RETURN NUMBER
AS
    l_max_amount NUMBER(10);
    office_name  VARCHAR2(50);
BEGIN
    SELECT (select CITY
            FROM OFFICES
            WHERE OFFICE = office_code)
    INTO office_name
    from dual;

    -- If no office is found, raise an exception
    IF office_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Office not found');
    END IF;
    -- Get the maximum order amount for the specified office and year
    SELECT MAX(O.AMOUNT)
    INTO l_max_amount
    from ORDERS O
             join SALESREPS S on S.EMPL_NUM = O.REP
    where S.REP_OFFICE = office_code
      AND EXTRACT(YEAR FROM O.ORDER_DATE) = year;

    -- Return the result
    RETURN l_max_amount;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Maximum order amount for office 12 and year 2007: ' ||
                         max_order_amount_by_office(12, 2007));
END;

--Напишите процедуру которая возврощает всех сотрудников и их клиентов в виде таблицы. Обработайте возможные ошибки.
create or replace procedure show_all_reps_and_their_clients
as
begin
    for r in (SELECT NAME
              from SALESREPS
              group by NAME
        )
        loop
            DBMS_OUTPUT.PUT_LINE('REP NAME : ' || r.NAME);
            DBMS_OUTPUT.PUT_LINE('COMPANY NAMES : ');
            for c in (SELECT COMPANY
                      from CUSTOMERS
                               join SALESREPS S2 on S2.EMPL_NUM = CUSTOMERS.CUST_REP
                      where S2.NAME = r.NAME)
                loop
                    DBMS_OUTPUT.PUT(c.COMPANY || ', ');
                end loop;
            DBMS_OUTPUT.PUT_LINE('');
        end loop;

end;

begin
    show_all_reps_and_their_clients();
end;