SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM job_history;
SELECT * FROM locations;
--���� 1.
--EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
--EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ�
--���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� Ȯ��)
SELECT * FROM employees e JOIN departments d ON e.department_id = d.department_id;
SELECT * FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id;
SELECT * FROM employees e RIGHT JOIN departments d ON e.department_id = d.department_id;
SELECT * FROM employees e FULL JOIN departments d ON e.department_id = d.department_id;

--���� 2.
--EMPLOYEES, DEPARTMENTS ���̺��� INNER JOIN�ϼ���
--����)employee_id�� 200�� ����� �̸�, department_id�� ����ϼ���
--����)�̸� �÷��� first_name�� last_name�� ���ļ� ����մϴ�
SELECT first_name || ' ' || last_name AS �̸�,
       e.department_id
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE employee_id = 200;

--���� 3.
--EMPLOYEES, JOBS���̺��� INNER JOIN�ϼ���
--����) ��� ����� �̸��� �������̵�, ���� Ÿ��Ʋ�� ����ϰ�, �̸� �������� �������� ����
--HINT) � �÷����� ���� ����� �ִ��� Ȯ��
SELECT first_name || ' ' || last_name AS �̸�,
       e.job_id,
       job_title
FROM employees e JOIN jobs j ON e.job_id = j.job_id
ORDER BY �̸�;

--���� 4.
--JOBS���̺�� JOB_HISTORY���̺��� LEFT_OUTER JOIN �ϼ���.
SELECT * FROM jobs js LEFT JOIN job_history jh ON js.job_id = jh.job_id;

--���� 5.
--Steven King�� �μ����� ����ϼ���.
SELECT first_name || ' ' || last_name AS �̸�, department_name as �μ���
FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
WHERE first_name = 'Steven' AND last_name = 'King';

--���� 6.
--EMPLOYEES ���̺�� DEPARTMENTS ���̺��� Cartesian Product(Cross join)ó���ϼ���
SELECT * FROM employees CROSS JOIN departments;

--���� 7.
--EMPLOYEES ���̺�� DEPARTMENTS ���̺��� �μ���ȣ�� �����ϰ� SA_MAN ������� �����ȣ, �̸�, 
--�޿�, �μ���, �ٹ����� ����ϼ���. (Alias�� ���)
SELECT e.employee_id AS �����ȣ,
       e.first_name || ' ' || last_name AS �̸�,
       e.salary AS �޿�,
       d.department_name AS �μ���,
       l.street_address AS �ٹ���
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id
WHERE job_id = 'SA_MAN';

--���� 8.
-- employees, jobs ���̺��� ���� �����ϰ� job_title��
--'Stock Manager', 'Stock Clerk'�� ���� ������ ����ϼ���.
SELECT e.*,
       job_title
FROM employees e JOIN jobs j ON e.job_id = j.job_id
WHERE job_title LIKE 'Stock%';

--���� 9.
-- departments ���̺��� ������ ���� �μ��� ã�� ����ϼ���. LEFT OUTER JOIN ���
SELECT department_name
FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id
WHERE first_name IS NULL;

--���� 10. 
---join�� �̿��ؼ� ����� �̸��� �� ����� �Ŵ��� �̸��� ����ϼ���
--��Ʈ) EMPLOYEES ���̺�� EMPLOYEES ���̺��� �����ϼ���.
SELECT e1.employee_id,
       e1.first_name || ' ' || e1.last_name AS ���,
       e2.first_name || ' ' || e2.last_name AS �Ŵ���
FROM employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

--���� 11. 
--6. EMPLOYEES ���̺��� left join�Ͽ�
--������(�Ŵ���)��, �Ŵ����� �̸�, �Ŵ����� �޿� ���� ����ϼ���
--�Ŵ��� ���̵� ���� ����� �����ϰ� �޿��� �������� ����ϼ���
SELECT  e1.first_name AS ����̸�,
        e1.salary AS ����޿�,
        e2.employee_id AS �Ŵ������̵�,
        e2.first_name AS �Ŵ����̸�,
        e2.salary AS �Ŵ����޿�
FROM employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IS NOT NULL
ORDER BY e1.salary DESC;
