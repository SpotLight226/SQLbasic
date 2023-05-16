-- ����Ŭ �ּ���
/*
������ �ּ�
����Ŭ�� ��ҹ��� ���� X - �Ϲ������� ������ �빮��, ������ ������ �ҹ���
���� : ctrl + enter
���� ���� ���� Ŀ�� ��ġ �������� �ٽ� ���� ����
*/
SELECT * FROM employees;
SELECT first_name, email, hire_date FROM employees;
SELECT job_id, salary, department_id FROM employees;

SELECT * FROM departments;

--����
--�÷��� ��ȸ�ϴ� ��ġ���� * / + -
SELECT first_name, salary FROM employees;
SELECT first_name, salary, salary + salary * 0.1 FROM employees;

--NULL
SELECT first_name, commission_pct FROM employees;

--����� AS : ��Ī ���� // ���� ���� 
SELECT first_name AS �̸�,
       last_name AS ��,
       salary �޿�,
       salary + salary * 0.1 �ѱ޿�
FROM employees; -- Ű���� ��, �÷� ���� ���� �ٲ㼭 �ۼ�

--���ڿ��� ���� ||
--����Ŭ�� ���ڸ� ''�� ǥ���Ѵ�
SELECT first_name || ' ' || last_name FROM employees; -- ���ڿ� ���ϱ�
-- ���� ���ͷ��� '' ��� X, '�� �ϳ��� ���� �ʹٸ� ''' ó�� '' ���̿� �ִ´�
SELECT first_name || ' ' || last_name || '''s salary $' || salary FROM employees;
SELECT first_name || ' ' || last_name || '''s salary $' || salary AS �޿�����
FROM employees;

--DISTINCT �ߺ��� ����
SELECT first_name, department_id FROM employees; -- �ߺ� ����
SELECT DISTINCT department_id FROM employees; -- �μ��� �ߺ� ����
SELECT DISTINCT first_name, department_id FROM employees; -- �̸�, �μ����� ������ �ߺ��� ����

--ROWID(�������� �ּ�), ROWNUM(��ȸ�� ����)
SELECT ROWNUM, ROWID, employee_id, first_name FROM employees;