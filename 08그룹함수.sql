--�׷��Լ� : ���� �࿡ ���Ͽ� ���� ���
--AVG, SUM, MIN, MAX, COUNT
SELECT AVG(salary), SUM(salary), MIN(salary), MAX(salary), COUNT(salary) FROM employees;
SELECT MIN(hire_date), MAX(hire_date) FROM employees; --��¥ ���ĵ� MIN, MAX ��밡��
SELECT MIN(first_name), MAX(first_name) FROM employees; --���� ���� MIN, MAX

--COUNT(�÷�) : NULL�� �ƴ� ������ ����
SELECT COUNT(first_name) FROM employees;
SELECT COUNT(department_id) FROM employees; -- 106 (NULL ����)
SELECT COUNT(commission_pct) FROM employees; -- 35 (NULL ����)
SELECT COUNT(*) FROM employees; -- NULL���� �� ��ü ���� ����    

--�׷��Լ� : �׷��Լ��� �Ϲ��÷��� ���ÿ� ����� �� ���� (����Ŭ��)
SELECT first_name, SUM(salary) FROM employees;