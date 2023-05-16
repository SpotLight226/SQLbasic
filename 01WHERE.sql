--WHERE��
SELECT * FROM employees;
SELECT * FROM employees WHERE salary = 4800; -- salary���� 4800�� ������ ( ���� )
SELECT * FROM employees WHERE salary <> 4800; -- salary�� 4800�� �ƴ� ������ (�����ʴ�)
SELECT * FROM employees WHERE department_id >= 100; --�μ� id�� 100���� ū ������
SELECT * FROM employees WHERE department_id < 50; --�μ� id�� 50 �̸��� ������
SELECT * FROM employees WHERE job_id = 'AD_ASST'; --job_id�� AD_ASST�� ������
SELECT * FROM employees WHERE hire_date = '03/09/17'; --��¥ ��

--BETWEEN~AND, IN, LIKE
SELECT * FROM employees WHERE salary BETWEEN 6000 AND 9000; --�̻� ~ ����
SELECT * FROM employees WHERE hire_date BETWEEN '08/01/01' AND '08/12/31'; --��¥�� ����

--IN
SELECT * FROM employees WHERE department_id IN (10,20,30,40,50); --��Ȯ�� ��ġ�ϴ�
SELECT * FROM employees WHERE job_id IN ('ST_MAN', 'IT_PROG', 'HR_REP'); --���ڿ� ��ġ

--LIKE
SELECT * FROM employees WHERE job_id LIKE 'IT%'; -- job_id�� IT�� �����ϴ�
SELECT * FROM employees WHERE hire_date LIKE '03%'; --hire_date�� 03���� �����ϴ�
SELECT * FROM employees WHERE hire_date LIKE '%03'; --hire_date�� 03���� ������
SELECT * FROM employees WHERE hire_date LIKE '%12%'; --12�� �� �����͸� ���� ��
SELECT * FROM employees WHERE hire_date LIKE '___05%'; --05 �տ� _�� 3��-> 3���ڰ� �ִ�
SELECT * FROM employees WHERE email LIKE '_A%'; --email���� A�� �ι� °�� �ִ�

--NOT NULL, IS NOT NULL
SELECT * FROM employees WHERE commission_pct = NULL; -- X
SELECT * FROM employees WHERE commission_pct IS NULL; --commission_pct�� null�� 
SELECT * FROM employees WHERE commission_pct IS NOT NULL; --null�� �ƴ� ������

--NOT
SELECT * FROM employees WHERE NOT salary >= 6000; -- NOT�� <>�� ������ ǥ�� / ������ �ݴ�
-- AND�� OR���� �켱������ ����
SELECT * FROM employees WHERE job_id = 'IT_PROG' AND salary >= 6000; --���� ���� ���� ��
SELECT * FROM employees WHERE salary >= 6000 AND salary <= 12000;--BETWEEN 6000 AND 12000
-- OR
SELECT * FROM employees WHERE job_id = 'IT_PROG' OR salary >=6000; --���� ������ ���� ��
--AND, OR ����
SELECT * FROM employees WHERE job_id = 'IT_PROG'
                        OR job_id = 'FI_MGR'
                        AND salary >= 6000; --FI�� 6000�̻��� ��� OR IT_PROG
                        
SELECT * FROM employees WHERE (job_id = 'IT_PROG'
                        OR job_id = 'FI_MGR') --()�� �켱���� ����
                        AND salary >= 6000; --FI, IT�� 6000�̻��� ���             

--------------------------------------------------------------------------------
--ORDER BY �÷�(����� - �� ��Ī)
SELECT * FROM employees ORDER BY hire_date; -- ��¥ ���� ASC
SELECT * FROM employees ORDER BY hire_date DESC; --���� ���� ����

SELECT * FROM employees WHERE job_id IN('IT_PROG', 'ST_MAN'); -- ST or IT
SELECT * FROM employees WHERE job_id IN('IT_PROG', 'ST_MAN') ORDER BY first_name DESC;
SELECT * FROM employees WHERE salary BETWEEN 6000 AND 12000 ORDER BY employee_id;
--ALIAS�� ORDER���� ����� �� ����
SELECT first_name, salary * 12 AS PAY FROM employees; --salary *12�� ��Ī pay��
SELECT first_name, salary * 12 AS PAY FROM employees ORDER BY PAY ASC;
--���� ������ ,�� ����
SELECT first_name, salary, job_id FROM employees ORDER BY job_id ASC,--job_id ���� ��������
                                                 salary DESC;--������ job_id�ִٸ� ��������
                                                 