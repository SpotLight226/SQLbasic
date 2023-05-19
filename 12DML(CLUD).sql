--INSERT, UPDATE, DELETE ���� �ۼ��ϸ�, COMMIT������� ���� �ݿ� ó�� �۾� �ʿ�
--INSERT

--���̺� ���� Ȯ��
DESC departments;

INSERT INTO departments VALUES (300, 'DEV', NULL, 1700);
INSERT INTO departments (department_id, department_name) VALUES (310, 'SYSTEM');

SELECT * FROM departments;
ROLLBACK; --INSERT ���� ���·� ����

--�纻 ���̺� ( ���̺� ������ ���� )
CREATE TABLE EMPS AS (SELECT * FROM employees WHERE 1 = 2);

INSERT INTO EMPS (SELECT * FROM employees WHERE job_id = 'IT_PROG'); --��ü �÷��� ����

INSERT INTO EMPS (employee_id, last_name, email, hire_date, job_id)
VALUES (200,
        (SELECT last_name FROM employees WHERE employee_id = 200),
        (SELECT email FROM employees WHERE employee_id = 200),
         SYSDATE,   
        'TEST'
        );
        
SELECT * FROM EMPS;

-------------------------------------------------------------------------------
--UPDATE��
SELECT * FROM EMPS;
--UPDATE �� SELECT������ Ȯ��
SELECT * FROM EMPS WHERE employee_id = 103; 
--EX1
UPDATE EMPS
SET hire_date = SYSDATE, 
    last_name = 'HONG',
    salary = salary + 1000
WHERE employee_id = 103; --�ݵ�� �ۼ��Ͽ�, ���ϴ� ROW�� �����͸� ����(����)�Ѵ�
--EX2
UPDATE EMPS
SET commission_pct = 0.1
WHERE job_id IN ('IT_PROG', 'SA_MAN');
--EX3 : ID -200�� �޿��� 103���� �����ϰ� ����
UPDATE EMPS
SET salary = (SELECT salary FROM EMPS WHERE employee_id = 103)--�������� ��밡��
WHERE employee_id = 200;
--EX4 : 3���� �÷��� �ѹ��� ���� 
UPDATE EMPS
SET (job_id, salary, commission_pct) =
    (SELECT job_id, salary, commission_pct
     FROM EMPS
     WHERE employee_id = 103)
WHERE employee_id = 200;

COMMIT;

SELECT * FROM EMPS;

--------------------------------------------------------------------------------
--DELETE����
CREATE TABLE DEPTS AS ( SELECT * FROM departments WHERE  1 = 1); --���̺� ���� + �����ͺ���

SELECT * FROM DEPTS;
SELECT * FROM EMPS;

--EX1 : ������ ���� �� Primary Key�� �̿��Ѵ�
DELETE FROM EMPS WHERE employee_id = 200;
DELETE FROM EMPS WHERE salary >= 4000; --��� salary�� 4000�̻��̹Ƿ� ���� ����

--EX2 :
DELETE FROM EMPS WHERE department_id = (SELECT department_id
                                        FROM departments
                                        WHERE department_name = 'IT');
ROLLBACK;

--employees�� 60�� �μ��� ����ϰ� �ֱ� ������ ���� �Ұ�
DELETE FROM departments WHERE department_id = 60;

--------------------------------------------------------------------------------
--MERGE��
--�� ���̺��� ���ؼ� �����Ͱ� ������ UPDATE, ���ٸ� INSERT
SELECT * FROM emps;
SELECT * FROM employees e WHERE job_id IN ('IT_PROG', 'SA_MAN');

MERGE INTO EMPS e1
USING (SELECT * FROM employees WHERE job_id IN ('IT_PROG', 'SA_MAN')) e2
ON (e1.employee_id = e2.employee_id)    
WHEN MATCHED THEN --�����Ͱ� ������ (��ġ ��)
    UPDATE SET e1.hire_date = e2.hire_date,
               e1.salary = e2.salary,
               e1.commission_pct = e2.commission_pct
WHEN NOT MATCHED THEN --�����Ͱ� ������ (����ġ ��)
    INSERT VALUES (e2.employee_id,
                   e2.first_name,
                   e2.email,
                   e2.phone_number,
                   e2.job_id,
                   e2.salary,
                   e2.commission_pct,
                   e2.manager_id,
                   e2.department_id);

--MERGE2
SELECT * FROM EMPS;

MERGE INTO EMPS e
USING DUAL
ON (e.employee_id = 103)-- PK�� ����
WHEN MATCHED THEN
    UPDATE SET last_name = 'DEMO'
WHEN NOT MATCHED THEN
    INSERT(employee_id,
           last_name,
           email,
           hire_date,
           job_id) VALUES(1000, 'DEMO', 'DEMO', SYSDATE, 'DEMO');

--
DELETE FROM EMPS WHERE employee_id = 103;

SELECT * FROM EMPS;

--------------------------------------------------------------------------------
SELECT * FROM DEPTS;
ROLLBACK;
--���� 1.
--DEPTS���̺��� ������ �߰��ϼ���
INSERT INTO DEPTS (department_id, department_name, location_id)
VALUES (280, '����', 1800);
INSERT INTO DEPTS (department_id, department_name, location_id)
VALUES (290, 'ȸ���', 1800);
INSERT INTO DEPTS (department_id, department_name, manager_id, location_id)
VALUES (300, '����', 301, 1800);
INSERT INTO DEPTS (department_id, department_name, manager_id, location_id)
VALUES (310, '�λ�', 302, 1800);
INSERT INTO DEPTS (department_id, department_name, manager_id, location_id)
VALUES (320, '����', 303, 1700);
DELETE FROM DEPTS WHERE department_id = 320;
COMMIT;
--���� 2.
--DEPTS���̺��� �����͸� �����մϴ�
--1. department_name �� IT Support �� �������� department_name�� IT bank�� ����
--2. department_id�� 290�� �������� manager_id�� 301�� ����
--3. department_name�� IT Helpdesk�� �������� �μ����� IT Help�� ,
--�Ŵ������̵� 303����, �������̵� 1800���� �����ϼ���
--4. ����, �λ� ���� �� �Ŵ������̵� 301�� �ѹ��� �����ϼ���.
--1
SELECT * FROM DEPTS;

UPDATE DEPTS
SET department_name = 'IT Bank'
WHERE department_name = 'IT Support';
--2
UPDATE DEPTS
SET manager_id = 301
WHERE department_id = 290;
      
--3
UPDATE DEPTS
SET manager_id = 303,
    location_id = 1800,
    department_name = 'IT Help'
WHERE department_name = 'IT Helpdesk';

--4
UPDATE DEPTS
SET manager_id = 301
WHERE department_name IN ('����','�λ�','����');
      
SELECT * FROM DEPTS;
--���� 3.
--������ ������ �׻� primary key�� �մϴ�, ���⼭ primary key�� department_id��� �����մϴ�.
--1. �μ��� �����θ� ���� �ϼ���
--2. �μ��� NOC�� �����ϼ���
SELECT * FROM DEPTS;
--1
DELETE FROM DEPTS WHERE department_id = 320;
--2
DELETE FROM DEPTS WHERE department_id = 220;

--����4
--1. Depts �纻���̺��� department_id �� 200���� ū �����͸� �����ϼ���.
--2. Depts �纻���̺��� manager_id�� null�� �ƴ� �������� manager_id�� ���� 100���� �����ϼ���.
--3. Depts ���̺��� Ÿ�� ���̺� �Դϴ�.
--4. Departments���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� Depts�� ���Ͽ�
--��ġ�ϴ� ��� Depts�� �μ���, �Ŵ���ID, ����ID�� ������Ʈ �ϰ�
--�������Ե� �����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���.
--1
SELECT * FROM DEPTS;
--2 
SELECT * FROM DEPTSC;
CREATE TABLE DEPTSC AS (SELECT * FROM DEPTS WHERE 1= 1);
DELETE FROM DEPTSC WHERE department_id > 200;
--3
UPDATE DEPTS
SET manager_id = 100
WHERE manager_id IS NOT NULL;
--4
CREATE TABLE departm AS (SELECT * FROM departments WHERE 1 = 1);
SELECT * FROM departm;
SELECT * FROM DEPTS;

MERGE INTO departm d
    USING (SELECT * FROM DEPTS ) s
    ON (d.department_id = s.department_id)
WHEN MATCHED THEN
    UPDATE SET 
        d.department_name = s.department_name,
        d.manager_id = s.manager_id,
        d.location_id = s.location_id
WHEN NOT MATCHED THEN
    INSERT VALUES
        (s.department_name,
         s.manager_id,
         s.location_id);
--���� 5
--1. jobs_it �纻 ���̺��� �����ϼ��� (������ min_salary�� 6000���� ū �����͸� �����մϴ�)
--2. jobs_it ���̺� ���� �����͸� �߰��ϼ���
--3. jobs_it�� Ÿ�� ���̺� �Դϴ�
--4. jobs���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� jobs_it�� ���Ͽ�
--min_salary�÷��� 0���� ū ��� ������ �����ʹ� min_salary, max_salary�� ������Ʈ �ϰ� ���� ���Ե�
--�����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���
--1
ROLLBACK;
SELECT * FROM jobs;
CREATE TABLE jobs_it AS (SELECT * FROM jobs WHERE 1 = 1 AND min_salary > 6000);
SELECT * FROM jobs_it;
--2
INSERT INTO jobs_it VALUES ('IT_DEV', '����Ƽ������', 6000, 20000); 
INSERT INTO jobs_it VALUES ('NET_DEV', '��Ʈ��ũ������', 5000, 20000);
INSERT INTO jobs_it VALUES ('SEC_DEV', '���Ȱ�����', 6000, 19000); 
DELETE FROM jobs WHERE job_id = 'IT_DEV';
--3,4
MERGE INTO jobs_it j1
USING (SELECT * FROM jobs WHERE min_salary > 0 ) j2
ON (j1.job_id = j2.job_id)
WHEN MATCHED THEN
    UPDATE SET
        j1.min_salary = j2.min_salary,
        j1.max_salary = j2.max_salary
WHEN NOT MATCHED THEN
    INSERT VALUES ( j2.job_id,
                    j2.job_title,
                    j2.min_salary,
                    j2.max_salary);
ROLLBACK;