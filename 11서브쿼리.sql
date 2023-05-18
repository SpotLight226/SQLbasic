--��������
--SELECT���� SELECT�������� ���� ���� : ��Į�� ��������
--SELECT���� FROM�������� ���� ���� : �ζ��κ�
--SELECT���� WHERE�������� ���� ���� : ��������
--���������� �ݵ�� () �ȿ� �ۼ��Ѵ�

--������ �������� - ���ϵǴ� ���� 1���� ��������
--Nancy���� salary�� ���� ���
SELECT * FROM employees WHERE salary > 12008;
-- �Ʒ��� ���� �ۼ�
SELECT *
FROM employees
WHERE salary > (SELECT salary FROM employees WHERE first_name = 'Nancy');

--employee_id�� 103���� ����� ������ ����
SELECT job_id FROM employees WHERE employee_id = 103;

SELECT *
FROM employees
WHERE job_id = (SELECT job_id FROM employees WHERE employee_id = 103);

--������ : ������ �̾�� �Ѵ�, �÷����� 1�� ���� �Ѵ�
SELECT *
FROM employees
WHERE job_id = (SELECT * FROM employees WHERE employee_id = 103); --ERROR:�÷��� ������

SELECT *  --ERROR : ���� 2��
FROM employees
WHERE job_id = (SELECT * FROM employees WHERE employee_id = 104 OR employee_id = 103);

--------------------------------------------------------------------------------
--������ �������� - ���� ���� ����� IN,ANY,ALL�� ���Ѵ�
SELECT salary FROM employees WHERE first_name = 'David'; --4800, 9500, 6800

--IN ������ ���� ã�´� = IN(4800, 6800, 9500)
SELECT *
FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE first_name = 'David');

--ANY �ּҰ� ���� ŭ, �ִ밪 ���� ����
SELECT *
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE first_name = 'David');--�޿��� 4800���� ū �����

SELECT *
FROM employees
WHERE salary < ANY (SELECT salary FROM employees WHERE first_name = 'David');--�޿��� 9500���� ���� �����

--ALL �ִ� ������ ŭ, �ּ� ������ ����
SELECT *
FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE first_name = 'David'); --�޿��� 9500���� ū �����

SELECT *
FROM employees
WHERE salary < ALL (SELECT salary FROM employees WHERE first_name = 'David'); --�޿��� 4800���� ���� �����

--������ IT_PROG�� ������� �ּ� ������ ū �޿��� �޴� �����
SELECT *
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE job_id = 'IT_PROG');

--------------------------------------------------------------------------------
--��Į�� ��������
--JOIN�� Ư�����̺��� �÷� 1���� ������ �� ��, �����ϴ� 
SELECT first_name,
       email,
       (SELECT department_name FROM departments d WHERE d.department_id = e.department_id)
FROM employees e
ORDER BY first_name;
--JOIN�� - ���� ���� ���
SELECT first_name,
       email,
       department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY first_name;

--�� �μ��� �Ŵ��� �̸��� ���
SELECT * FROM departments;
SELECT * FROM employees;
--JOIN
SELECT *
FROM departments d
LEFT JOIN employees e ON d.manager_id = e.employee_id;
--��Į��
SELECT d.*,
       (SELECT first_name FROM employees e WHERE e.employee_id = d.manager_id)
FROM departments d;

--��Į�� ������ ���� �� ����
SELECT * FROM jobs; -- job_title
SELECT * FROM departments; --department_name
SELECT * FROM employees;

SELECT e.first_name,
       e.job_id,
       (SELECT job_title FROM jobs j WHERE j.job_id = e.job_id) AS job_title,
       (SELECT department_name FROM departments d WHERE d.department_id = e.department_id) AS department_name
FROM employees e;

--�� �μ��� ��� ���� ��� + �μ�����
SELECT department_name,
       COUNT(*)
FROM departments d
JOIN employees e
ON e.department_id = d.department_id
GROUP BY d.department_name;
-- ���� ���� ��� -> NVL�� NULL���� 0���� �����߱� ������, NULL�� 0���� ����
SELECT d.department_name,
       NVL((SELECT COUNT(*) FROM employees e
            WHERE e.department_id = d.department_id GROUP BY department_id), 0) AS �����
FROM departments d;

-------------------------------------------------------------------------------
--�ζ��� �� : FROM���� SELECT��
--���� ���̺� ����

--ROWNUM�� ��ȸ�� �����̱� ������, ORDER�� ���� ���Ǵ� ROWNUM�� ���̴� ������ �ִ�
SELECT first_name,
       salary,
       ROWNUM
FROM (SELECT *
        FROM employees
        ORDER BY salary DESC);
-- AS ����Ͽ� ��Ī ���� (�÷� ����) ��, ��Ī.* �� ��� ��� ���        
SELECT ROWNUM,
       A.*
FROM (SELECT first_name,
             salary
      FROM employees
      ORDER BY salary
      ) A ;

--ROWNUM�� ������ 1��°���� ��ȸ�� �����ϱ� ������ BETWEEN 11 AND 20�� �Ұ���
SELECT first_name,
       salary,
       ROWNUM
FROM (SELECT *
        FROM employees
        ORDER BY salary DESC)
WHERE ROWNUM BETWEEN 11 AND 20;

--2��° �ζ��κ信�� ROWNUM�� RN���� �÷�ȭ
SELECT *
FROM (SELECT first_name, 
             salary,
             ROWNUM AS RN -- �������� ���ĵ� �÷����� ��ȸ�� ������ RN���� �÷�ȭ
      FROM (SELECT * -- salary ������������ ����
            FROM employees
            ORDER BY salary DESC))
WHERE RN >= 51 AND RN <= 60; -- RN�� �÷��̱� ������ ��밡��

--�ζ��� ���� ����
SELECT TO_CHAR(REGDATE, 'YY-MM-DD') AS REGDATE, --�ζ��� �信�� ���� ������ �÷��� ����� �� �ִ�
       NAME
FROM (SELECT 'ȫ�浿' AS NAME, SYSDATE AS REGDATE FROM dual --�� ���̺��� UNION���� ���ļ�, �÷��� ����
      UNION ALL
      SELECT '�̼���', SYSDATE FROM dual);

--�ζ��� ���� ����
--�μ��� �����

SELECT D.*,
       e.TOTAL
FROM departments d
LEFT JOIN (SELECT department_id, --���� ���̺� = �ζ��� ��
                  COUNT(*) AS TOTAL 
           FROM employees
           GROUP BY department_id) e 
ON d.department_id = e.department_id;

SELECT *
FROM (SELECT department_id, COUNT(*)
      FROM employees
      GROUP BY department_id);

--����
--������( ��Һ� ) vs ������ ��������(IN, ANY, ALL)
--��Į�� ���� - LEFT JOIN�� ���� ����, �ѹ��� 1���� �÷��� ������ ��
--�ζ��� �� - FROM�� ���� ���� ���̺�, 

--------------------------------------------------------------------------------
--���� 1.
--EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� ( AVG(�÷�) ���)
--EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
--EMPLOYEES ���̺��� job_id�� IT_PFOG�� ������� ��ձ޿����� ���� ������� �����͸� ����ϼ���
--��պ��� ���� ���
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees
                GROUP BY ROLLUP(first_name)
                HAVING first_name IS NULL);
-- ��� ��
SELECT COUNT(*) AS �����
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees
                GROUP BY ROLLUP(first_name)
                HAVING first_name IS NULL);
                
--IT_PROG ���� ���� ���
SELECT * 
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees
                GROUP BY ROLLUP(job_id)
                HAVING job_id = 'IT_PROG');

--���� 2.
---DEPARTMENTS���̺��� manager_id�� 100�� ����� department_id��
--EMPLOYEES���̺��� department_id�� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.
SELECT * FROM departments;
SELECT * FROM employees;

SELECT *
FROM employees
WHERE department_id =(SELECT department_id FROM departments WHERE manager_id = 100);

--���� 3.
---EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���
---EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
SELECT *
FROM employees
WHERE manager_id > (SELECT manager_id FROM employees WHERE first_name = 'Pat');

SELECT *
FROM employees
WHERE manager_id = ANY (SELECT manager_id FROM employees WHERE first_name = 'James');

--���� 4.
---EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���
SELECT *
FROM (SELECT first_name,
             ROWNUM AS RN
      FROM (SELECT *
            FROM employees
            ORDER BY first_name DESC))
WHERE RN BETWEEN 41 AND 50;

--���� 5.
---EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ, 
--�Ի����� ����ϼ���
SELECT *
FROM (SELECT ROWNUM AS RN,
             employee_id,
             first_name,
             phone_number,
             hire_date
      FROM (SELECT *
            FROM employees
            ORDER BY hire_date))
WHERE RN BETWEEN 31 AND 40;

--���� 6.
--employees���̺� departments���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����

SELECT employee_id AS �������̵�,
       CONCAT(first_name, last_name) AS �̸�,
       e.department_id AS �μ����̵�,
       d.department_name AS �μ���
FROM employees e
LEFT JOIN (SELECT department_id, 
                  department_name
           FROM departments) d
ON e.department_id = d.department_id
ORDER BY employee_id;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT employee_id AS �������̵�,
       CONCAT(first_name, last_name) AS �̸�,
       e.department_id AS �μ����̵�,
       (SELECT department_name FROM departments d WHERE d.department_id = e.department_id) AS �μ��� 
FROM employees e
ORDER BY employee_id;

--���� 8.
--departments���̺� locations���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����
SELECT * FROM departments;
SELECT * FROM locations;

SELECT d.*,
       l.street_address AS �ּ�,
       l.postal_code AS ����Ʈ�ڵ�,
       l.city AS ����
FROM departments d
LEFT JOIN (SELECT location_id,
                  street_address,
                  postal_code,
                  city
           FROM locations) l
ON d.location_id = l.location_id
ORDER BY department_id;

--���� 9.
--���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT d.*,
       (SELECT street_address FROM locations l WHERE d.location_id = l.location_id) AS �ּ�,
       (SELECT postal_code FROM locations l WHERE d.location_id = l.location_id) AS �����ȣ,
       (SELECT city FROM locations l WHERE d.location_id = l.location_id) AS ����
FROM departments d;

--���� 10.
--locations���̺� countries ���̺��� left �����ϼ���
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����
SELECT * FROM locations;
SELECT * FROM countries;

SELECT l.location_id AS �����̼Ǿ��̵�,
       l.street_address AS �ּ�,
       l.city AS ��Ƽ,
       c.*
FROM locations l
LEFT JOIN (SELECT country_id,
                  country_name
           FROM countries) c
ON l.country_id = c.country_id;

--���� 11.
--���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT l.location_id AS �����̼Ǿ��̵�,
       l.street_address AS �ּ�,
       l.city AS ��Ƽ,
       (SELECT country_id FROM countries c WHERE l.country_id = c.country_id),
       (SELECT country_name FROM countries c WHERE l.country_id = c.country_id)
FROM locations l;

--���� 12. 
--employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 1-10��° �����͸� ����մϴ�
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, �μ����̵�, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.
SELECT * FROM employees;
SELECT * FROM departments;

--���� 13. 
--EMPLOYEES �� DEPARTMENTS ���̺��� JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID, 
--DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���