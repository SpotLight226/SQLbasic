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

-------------------------------------------------------------------------------
-- GROUP BY�� ���� SELECT���� �ۼ��� �־�� �Ѵ�
SELECT department_id, AVG(salary), SUM(salary), COUNT(*) --�׷��Լ��� �Բ� ��� ����
FROM employees
GROUP BY department_id;
--������ : �׷����� ����� �÷���, SELECT���� ����Ѵ�
SELECT department_id, first_name 
FROM employees
GROUP BY department_id; --ERROR
--2�� �̻��� �׷�ȭ
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;
--�׷��Լ��� WHERE���� ������ �� ����
SELECT job_id, AVG(salary)
FROM employees
--WHERE AVG(salary) >= 10000 -- ERROR : group function is not allowed here
GROUP BY job_id;
-------------------------------------------------------------------------------
--�׷��� ������ HAVING���� ����Ѵ�
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id
HAVING AVG(salary) >= 10000; --salary ����� 10000 �̻��� job_id��

SELECT department_id, COUNT(*) --COUNT(*) ���� �� 
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 30;

SELECT job_id, SUM(salary), SUM( NVL(commission_pct, 0) ) --NVL : NULL�� ��ǥ������ ����
FROM employees
WHERE job_id NOT IN ('IT_PROG') --IT_PROG ����
GROUP BY job_id -- job_id�� �׷�ȭ
HAVING SUM(salary) >= 20000 --salary�հ谡 20000�̻�
ORDER BY SUM(salary) DESC; --�������� ����
--�μ����̵� 50�� �̻��� �μ��� �׷�ȭ ��Ű�� �׷���ձ޿� 5000�̻� ���
SELECT department_id, AVG(salary)
FROM employees
WHERE department_id >= 50
GROUP BY department_id
HAVING AVG(salary) >= 5000
ORDER BY department_id;
--------------------------------------------------------------------------------
--ROLLUP - �� �׷��� �Ѱ踦 �Ʒ��� ���
SELECT department_id, TRUNC(AVG(salary))
FROM employees
GROUP BY ROLLUP(department_id);

SELECT department_id, job_id, TRUNC(AVG(salary))
FROM employees
GROUP BY ROLLUP(department_id, job_id);

--CUBE : ���� �׷쿡 ���� �÷� ���
SELECT department_id, job_id, TRUNC(AVG(salary)), COUNT(*)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

--GROUPING() - �׷����� �����Ǹ� 0��ȯ, ROLLUP or CUBE�� �����Ǹ� 1��ȯ
SELECT department_id,
       job_id,
       DECODE(GROUPING(job_id), 1, '�Ұ�', job_id), --1�̸� '�Ұ�' �ƴϸ� job_id
       GROUPING(job_id),
       SUM(salary),
       COUNT(*)
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id;

-------------------------------------------------------------------------------
--��������
--���� 1.
--��� ���̺��� JOB_ID�� ��� ���� ���ϼ���.
--��� ���̺��� JOB_ID�� ������ ����� ���ϼ���. ������ ��� ������ �������� �����ϼ���
SELECT job_id,
       COUNT(*) AS �����,
       AVG(salary) AS �޿����
FROM employees
GROUP BY job_id
ORDER BY �޿���� DESC; 

--���� 2.
--��� ���̺��� �Ի� �⵵ �� ��� ���� ���ϼ���.
SELECT TO_CHAR(hire_date, 'YY') AS �Ի�⵵,
       COUNT(*) AS �����     
FROM employees
GROUP BY TO_CHAR(hire_date, 'YY');

--���� 3.
--�޿��� 1000 �̻��� ������� �μ��� ��� �޿��� ����ϼ���.
--��, �μ� ��� �޿��� 2000�̻��� �μ��� ���
SELECT department_id,
       TRUNC(AVG(salary)) AS ��ձ޿�
FROM employees
WHERE salary >= 1000
GROUP BY department_id
HAVING AVG(salary) >= 2000;

--���� 4.
--��� ���̺��� commission_pct(Ŀ�̼�) �÷��� null�� �ƴ� �������
--department_id(�μ���) salary(����)�� ���, �հ�, count�� ���մϴ�.
--���� 1) ������ ����� Ŀ�̼��� �����Ų �����Դϴ�.
--���� 2) ����� �Ҽ� 2° �ڸ����� ���� �ϼ���.
SELECT department_id,
       TRUNC(AVG(salary + salary * commission_pct), 2) AS �޿����, --Ŀ�̼� ����
       SUM(salary + salary * commission_pct) AS �޿��հ�,
       COUNT(*) AS �����
FROM employees
WHERE commission_pct IS NOT NULL --NULL�� IS or IS NOT �� ��
GROUP BY department_id;

--���� 5.
--������ ������, ���հ踦 ����ϼ���
SELECT DECODE(GROUPING(job_id), 1, '�հ�', job_id) AS job_id,
       SUM(salary) AS ������
FROM employees
GROUP BY ROLLUP(job_id)
ORDER BY job_id;

--���� 6.
--�μ���, JOB_ID�� �׷��� �Ͽ� ��Ż, �հ踦 ����ϼ���.
--GROUPING() �� �̿��Ͽ� �Ұ� �հ踦 ǥ���ϼ���
SELECT DECODE(GROUPING(department_id), 1, '�հ�', department_id) AS department_id,
       DECODE(GROUPING(job_id), 1, '�Ұ�', job_id) AS job_id,
       COUNT(*) AS TOTAL,
       SUM(salary) AS SUM
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY SUM; --ORDER BY���� AS�� ���� ��Ī ��� ����


