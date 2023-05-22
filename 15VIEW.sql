/*
VIEW는 제한적인 자료를 보기 위해 사용하는 가상테이블 이다
VIEW를 이용해서 필요한 컬럼을 정의해두면, 관리가 용이해진다
VIEW를 통해서 데이터에 접근하면, 비교적 안전하게 데이터를 관리할 수 있다
*/
SELECT * FROM emp_details_view;

--뷰를 생성하려면 권한이 필요하다
SELECT * FROM user_sys_privs;

--CREATE OR REPLACE VIEW
--뷰의 생성
CREATE OR REPLACE VIEW EMPS_VIEW
AS (
SELECT employee_id,
       first_name || ' ' || last_name AS NAME,
       job_id,
       salary
FROM employees
);

SELECT * FROM emps_view;
--뷰의 수정은 OR REPLACE 가 있으면 된다
CREATE OR REPLACE VIEW emps_view
AS (
SELECT employee_id,
       first_name ||' ' || last_name AS NAME,
       job_id,
       salary,
       commission_pct
FROM employees
WHERE job_id = 'IT_PROG'
);

--복합뷰
--JOIN을 이용해서 필요한 데이터를 뷰로 생성함
CREATE OR REPLACE VIEW emps_view
AS (
SELECT e.employee_id,
       first_name || ' ' || last_name AS NAME,
       d.department_name,
       j.job_title
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN jobs j ON e.job_id = j.job_id
);

SELECT * FROM emps_view;

--뷰의 삭제
--DROP VIEW
DROP VIEW emps_view;

--------------------------------------------------------------------------------
/*
VIEW를 통한 DML은 가능하긴 하지만, 몇가지 제약 사항이 있다
1. 가상 열이면 안된다
2. JOIN을 이용한 테이블인 경우에도 안된다
3. 원본 테이블에 NOT NULL제약이 있다면 안된다
*/

SELECT * FROM emps_view;
--1. 가상열이면 안된다 (NAME은 가상열)
INSERT INTO emps_view(employee_id, name, department_name, job_title)
VALUES (1000, 'DEMO HONG', 'DEMO IT', 'DEMO IT PROG'); 
--2. JOIN을 이용한 테이블인 경우에도 안된다
INSERT INTO emps_view(department_name) VALUES ('DEMO');
--3. 원본테이블 NOT NULL 제약이 있다면 안된다
INSERT INTO emps_view(employee_id, job_title) VALUES (300, 'TEST');

--뷰의 제약조건 READ ONLY
--DML문장이 뷰를 통해서는 실행 불가
CREATE OR REPLACE VIEW emps_view
AS(
    SELECT employee_id, first_name, last_name, salary
    FROM employees
) WITH READ ONLY; --맨 뒤에 붙는다 ( 읽기 전용 )






