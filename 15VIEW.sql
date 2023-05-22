/*
VIEW�� �������� �ڷḦ ���� ���� ����ϴ� �������̺� �̴�
VIEW�� �̿��ؼ� �ʿ��� �÷��� �����صθ�, ������ ����������
VIEW�� ���ؼ� �����Ϳ� �����ϸ�, ���� �����ϰ� �����͸� ������ �� �ִ�
*/
SELECT * FROM emp_details_view;

--�並 �����Ϸ��� ������ �ʿ��ϴ�
SELECT * FROM user_sys_privs;

--CREATE OR REPLACE VIEW
--���� ����
CREATE OR REPLACE VIEW EMPS_VIEW
AS (
SELECT employee_id,
       first_name || ' ' || last_name AS NAME,
       job_id,
       salary
FROM employees
);

SELECT * FROM emps_view;
--���� ������ OR REPLACE �� ������ �ȴ�
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

--���պ�
--JOIN�� �̿��ؼ� �ʿ��� �����͸� ��� ������
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

--���� ����
--DROP VIEW
DROP VIEW emps_view;

--------------------------------------------------------------------------------
/*
VIEW�� ���� DML�� �����ϱ� ������, ��� ���� ������ �ִ�
1. ���� ���̸� �ȵȴ�
2. JOIN�� �̿��� ���̺��� ��쿡�� �ȵȴ�
3. ���� ���̺� NOT NULL������ �ִٸ� �ȵȴ�
*/

SELECT * FROM emps_view;
--1. �����̸� �ȵȴ� (NAME�� ����)
INSERT INTO emps_view(employee_id, name, department_name, job_title)
VALUES (1000, 'DEMO HONG', 'DEMO IT', 'DEMO IT PROG'); 
--2. JOIN�� �̿��� ���̺��� ��쿡�� �ȵȴ�
INSERT INTO emps_view(department_name) VALUES ('DEMO');
--3. �������̺� NOT NULL ������ �ִٸ� �ȵȴ�
INSERT INTO emps_view(employee_id, job_title) VALUES (300, 'TEST');

--���� �������� READ ONLY
--DML������ �並 ���ؼ��� ���� �Ұ�
CREATE OR REPLACE VIEW emps_view
AS(
    SELECT employee_id, first_name, last_name, salary
    FROM employees
) WITH READ ONLY; --�� �ڿ� �ٴ´� ( �б� ���� )






