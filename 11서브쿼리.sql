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
                FROM employees);
-- ��� ��
SELECT COUNT(*) AS �����
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees);
                
--IT_PROG ���� ���� ���
SELECT * 
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees
                HAVING job_id = 'IT_PROG');

--���� 2.
---DEPARTMENTS���̺��� manager_id�� 100�� ����� department_id��
--EMPLOYEES���̺��� department_id�� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.

SELECT *
FROM employees
WHERE department_id =(SELECT department_id FROM departments WHERE manager_id = 100);

--���� 3.
---EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���
---EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
SELECT *
FROM employees
WHERE manager_id > (SELECT manager_id FROM employees WHERE first_name = 'Pat');

SELECT * -- = ANY �� ����
FROM employees
WHERE manager_id IN (SELECT manager_id FROM employees WHERE first_name = 'James');

--���� 4.
---EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���
SELECT *
FROM (SELECT first_name || ' ' || last_name AS �̸�,
             ROWNUM AS RN
      FROM (SELECT *
            FROM employees
            ORDER BY first_name DESC))e
WHERE RN BETWEEN 41 AND 50;
--WHERE RN >40 AND RN<=50;

--���� 5.
---EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�,
--31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ, �Ի����� ����ϼ���
SELECT *
FROM (SELECT ROWNUM RN,
             e.*
      FROM (SELECT employee_id ���ID,
                   first_name || ' ' || last_name �̸�,
                   phone_number ��ȣ,
                   hire_date �Ի���
            FROM employees
            ORDER BY hire_date) e
     )
WHERE RN BETWEEN 31 AND 40;

--���� 6.
--employees���̺� departments���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����
--�ζ��� ��
SELECT employee_id AS �������̵�,
       first_name || ' ' || last_name AS �̸�,
       e.department_id AS �μ����̵�,
       d.department_name AS �μ���
FROM employees e
LEFT JOIN (SELECT department_id, 
                  department_name
           FROM departments) d
ON e.department_id = d.department_id
ORDER BY employee_id;
--LEFT JOIN
SELECT employee_id AS �������̵�,
       first_name || ' ' || last_name AS �̸�,
       d.department_id AS �μ����̵�,
       department_name AS �μ���
FROM employees e 
LEFT JOIN departments d ON d.department_id = e.department_id
ORDER BY employee_id;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT employee_id AS �������̵�,
       first_name || ' ' || last_name AS �̸�,
       e.department_id AS �μ����̵�,
       (SELECT department_name
        FROM departments d
        WHERE d.department_id = e.department_id) AS �μ��� 
FROM employees e
ORDER BY employee_id;

--���� 8.
--departments���̺� locations���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����

--���ϴ� �͸� ���� ��
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

--LEFT JOIN
SELECT d.*,
       l.street_address AS �ּ�,
       l.postal_code AS ����Ʈ�ڵ�,
       l.city AS ����
FROM departments d
LEFT JOIN locations l
ON d.location_id = l.location_id
ORDER BY department_id;

--���� 9.
--���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT d.*,
       (SELECT street_address FROM locations l WHERE d.location_id = l.location_id) AS �ּ�,
       (SELECT postal_code FROM locations l WHERE d.location_id = l.location_id) AS �����ȣ,
       (SELECT city FROM locations l WHERE d.location_id = l.location_id) AS ����
FROM departments d
ORDER BY department_id;

--���� 10.
--locations���̺� countries ���̺��� left �����ϼ���
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����

SELECT l.location_id AS �����̼Ǿ��̵�,
       l.street_address AS �ּ�,
       l.city AS ��Ƽ,
       c.*
FROM locations l
LEFT JOIN (SELECT country_id,
                  country_name
           FROM countries) c
ON l.country_id = c.country_id
ORDER BY country_name;

--���� 11.
--���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT l.location_id AS �����̼Ǿ��̵�,
       l.street_address AS �ּ�,
       l.city AS ��Ƽ,
       l.country_id,
       (SELECT country_name FROM countries c WHERE l.country_id = c.country_id)
FROM locations l;

--���� 12. 
--employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 1-10��° �����͸� ����մϴ�
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, �μ����̵�, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.

SELECT e.*,
       (SELECT department_name FROM departments d WHERE e.�μ����̵� = d.department_id) AS �μ��̸�
FROM (SELECT ROWNUM AS ��ȣ,
             employee_id AS �������̵�,
             CONCAT(first_name, last_name) AS �̸�,
             phone_number AS ��ȭ��ȣ,
             hire_date AS �Ի���,
             department_id AS �μ����̵�,
             department_name AS �μ��̸�
      FROM (SELECT *
            FROM employees
            ORDER BY hire_date)) e
ORDER BY ��ȣ;

SELECT *
FROM (SELECT ROWNUM AS ��ȣ,
             f.*
      FROM (SELECT employee_id AS �������̵�,
                   CONCAT(first_name, last_name) AS �̸�,
                   phone_number AS ��ȭ��ȣ,
                   hire_date AS �Ի���,
                   e.department_id AS �μ����̵�,
                   d.department_name AS �μ��̸�
            FROM employees e
            LEFT JOIN departments d
            ON e.department_id = d.department_id
            ORDER BY hire_date) f ) d
WHERE ��ȣ > 0 AND ��ȣ <=10;




--���� 13. 
--EMPLOYEES �� DEPARTMENTS ���̺��� JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID, 
--DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���
SELECT * FROM employees;
SELECT * FROM departments;

SELECT last_name,
       job_id,
       e.department_id,
       (SELECT department_name
       FROM departments d
       WHERE e.department_id = d.department_id) AS �μ���
FROM employees e
WHERE job_id = 'SA_MAN';

--LEFT JOIN
SELECT *
FROM (SELECT e.last_name,
             e.job_id,
             e.department_id,
             d.department_name
      FROM employees e
      LEFT JOIN departments d
      ON e.department_id = d.department_id
      WHERE job_id = 'SA_MAN');
--
SELECT e.last_name,
       e.job_id,
       e.department_id,
       d.department_name
FROM (SELECT * -- ���� WHERE ���� ������ �� ����
      FROM employees
      WHERE job_id = 'SA_MAN') e
JOIN departments d
ON e.department_id = d.department_id;


--���� 14
--DEPARTMENT���̺��� �� �μ��� ID, NAME, MANAGER_ID�� �μ��� ���� �ο����� ����ϼ���.
--�ο��� ���� �������� �����ϼ���.
--����� ���� �μ��� ������� ���� �ʽ��ϴ�

SELECT s.*,
       COUNT(*)
FROM (SELECT d.department_id,
             d.department_name,
             d.manager_id
      FROM employees e
      JOIN departments d
      ON e.department_id = d.department_id) s
GROUP BY (s.department_name,s.department_id,s.manager_id)
ORDER BY COUNT(*) DESC;

-- �̷� ������ �����ϰ�
SELECT d.department_id,
       d.department_name,
       d.manager_id,
       e.�ο���
FROM departments d
JOIN (SELECT department_id, --�μ��� �����, INNER JOIN���� NULL�� ����
             COUNT(*) AS �ο���
      FROM employees
      GROUP BY department_id) e
ON d.department_id = e.department_id
ORDER BY �ο��� DESC;

--�ݴ�� employees�� JOIN�ϴ� ��� ����� ����


--���� 15
--�μ��� ���� ���� ���ο�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���
--�μ��� ����� ������ 0���� ����ϼ���

SELECT d.*,
       l.street_address �ּ�,
       l.postal_code �����ȣ,
       NVL(e.��տ���, 0) �μ�����տ���
FROM departments d
LEFT JOIN locations l
ON d.location_id = l.location_id
LEFT JOIN (SELECT department_id,
                  TRUNC(AVG(salary)) AS ��տ���
           FROM employees 
           GROUP BY department_id) e
ON d.department_id = e.department_id;   

--
SELECT d.*,
       l.street_address �ּ�,
       l.postal_code �����ȣ,
       NVL(e.salary, 0)
FROM departments d
LEFT JOIN (SELECT department_id,
                  TRUNC(AVG(salary)) AS salary
           FROM employees
           GROUP BY department_id) e
ON d.department_id = e.department_id
LEFT JOIN locations l
ON d.location_id = l.location_id;

--���� 16
--���� 15����� ���� DEPARTMENT_ID�������� �������� �����ؼ� ROWNUM�� �ٿ�
--1-10������ ������ ����ϼ���

SELECT *
FROM ( SELECT ROWNUM RN,
              X.*
       FROM (SELECT d.*,
                    l.street_address �ּ�,
                    l.postal_code �����ȣ,
                    NVL(e.salary, 0)
             FROM departments d
             LEFT JOIN (SELECT department_id,
                        TRUNC(AVG(salary)) AS salary
                        FROM employees
                        GROUP BY department_id) e
             ON d.department_id = e.department_id
             LEFT JOIN locations l
             ON d.location_id = l.location_id
             ORDER BY d.department_id DESC
             ) x
    )
WHERE RN BETWEEN 1 AND 10;