--���տ�����
--UNION -������, UNIONALL-������, INTERSECT-������, MINUS-������

--UNION - ������, �ߺ� X
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%' -- ; ����
UNION
SELECT first_name, hire_date FROM employees WHERE department_id = 20; -- �̽��� �ߺ��̱� ������, �ߺ� ����
--UNIONALL - ������, �ߺ� O
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%' 
UNION ALL
SELECT first_name, hire_date FROM employees WHERE department_id = 20; 
--INTERSECT - ������ (�ߺ��� ����)
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%' 
INTERSECT
SELECT first_name, hire_date FROM employees WHERE department_id = 20; 
--MINUS - ������ (�ߺ��� �� ����)
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%'
MINUS
SELECT first_name, hire_date FROM employees WHERE department_id = 20; 

--���� �����ڴ� �÷����� ��ġ �ؾ� �Ѵ�
SELECT first_name, hire_date, last_name FROM employees WHERE hire_date LIKE '04%'
UNION -- ERROR
SELECT first_name, hire_date FROM employees WHERE department_id = 20; -- �÷� �� ����ġ
--�÷� ���� ��ġ�Ѵٸ�, �پ��� ���·� ����� �ȴ�
SELECT 'ȫ�浿', TO_CHAR(SYSDATE) FROM dual
UNION ALL
SELECT '�̼���', '05/01/01' FROM dual
UNION ALL
SELECT 'ȫ����', '06/02/02' FROM dual
UNION ALL
SELECT last_name, TO_CHAR(hire_date) FROM employees; --�÷��� �̸�(����), ��¥(����) 2��

------------------------------------------------------------------------------
--�м��Լ� - �࿡ ���� ����� ����ϴ� ���, OVER() �� �Բ� ���ȴ�

SELECT first_name,
       salary,
       RANK() OVER(ORDER BY salary DESC) AS �ߺ�����, --RANK() - �켱���� �ߺ� O
       DENSE_RANK() OVER(ORDER BY salary DESC) AS �ߺ�����X, --DENSE_RANK() - �켱���� �ߺ� X
       ROW_NUMBER() OVER(ORDER BY salary DESC) AS �����͹�ȣ, --ROW_NUMBER -���� �����ϴ� ��� ���� ��ȣ
       COUNT(*) OVER() AS ��ü�����Ͱ���, --��ü ������ ����
       ROWNUM AS ��ȸ����-- ��ȸ�� �Ͼ ����
FROM employees;
