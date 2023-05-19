--INSERT, UPDATE, DELETE 문을 작성하면, COMMIT명령으로 실제 반영 처리 작업 필요
--INSERT

--테이블 구조 확인
DESC departments;

INSERT INTO departments VALUES (300, 'DEV', NULL, 1700);
INSERT INTO departments (department_id, department_name) VALUES (310, 'SYSTEM');

SELECT * FROM departments;
ROLLBACK; --INSERT 전의 상태로 복구

--사본 테이블 ( 테이블 구조만 복사 )
CREATE TABLE EMPS AS (SELECT * FROM employees WHERE 1 = 2);

INSERT INTO EMPS (SELECT * FROM employees WHERE job_id = 'IT_PROG'); --전체 컬럼을 맞춤

INSERT INTO EMPS (employee_id, last_name, email, hire_date, job_id)
VALUES (200,
        (SELECT last_name FROM employees WHERE employee_id = 200),
        (SELECT email FROM employees WHERE employee_id = 200),
         SYSDATE,   
        'TEST'
        );
        
SELECT * FROM EMPS;

-------------------------------------------------------------------------------
--UPDATE문
SELECT * FROM EMPS;
--UPDATE 전 SELECT문으로 확인
SELECT * FROM EMPS WHERE employee_id = 103; 
--EX1
UPDATE EMPS
SET hire_date = SYSDATE, 
    last_name = 'HONG',
    salary = salary + 1000
WHERE employee_id = 103; --반드시 작성하여, 원하는 ROW의 데이터를 갱신(변경)한다
--EX2
UPDATE EMPS
SET commission_pct = 0.1
WHERE job_id IN ('IT_PROG', 'SA_MAN');
--EX3 : ID -200의 급여를 103번과 동일하게 변경
UPDATE EMPS
SET salary = (SELECT salary FROM EMPS WHERE employee_id = 103)--서브쿼리 사용가능
WHERE employee_id = 200;
--EX4 : 3개의 컬럼을 한번에 변경 
UPDATE EMPS
SET (job_id, salary, commission_pct) =
    (SELECT job_id, salary, commission_pct
     FROM EMPS
     WHERE employee_id = 103)
WHERE employee_id = 200;

COMMIT;

SELECT * FROM EMPS;

--------------------------------------------------------------------------------
--DELETE구문
CREATE TABLE DEPTS AS ( SELECT * FROM departments WHERE  1 = 1); --테이블 복사 + 데이터복사

SELECT * FROM DEPTS;
SELECT * FROM EMPS;

--EX1 : 삭제할 때는 꼭 Primary Key를 이용한다
DELETE FROM EMPS WHERE employee_id = 200;
DELETE FROM EMPS WHERE salary >= 4000; --모든 salary가 4000이상이므로 전부 삭제

--EX2 :
DELETE FROM EMPS WHERE department_id = (SELECT department_id
                                        FROM departments
                                        WHERE department_name = 'IT');
ROLLBACK;

--employees가 60번 부서를 사용하고 있기 때문에 삭제 불가
DELETE FROM departments WHERE department_id = 60;

--------------------------------------------------------------------------------
--MERGE문
--두 테이블을 비교해서 데이터가 있으면 UPDATE, 없다면 INSERT
SELECT * FROM emps;
SELECT * FROM employees e WHERE job_id IN ('IT_PROG', 'SA_MAN');

MERGE INTO EMPS e1
USING (SELECT * FROM employees WHERE job_id IN ('IT_PROG', 'SA_MAN')) e2
ON (e1.employee_id = e2.employee_id)    
WHEN MATCHED THEN --데이터가 있으면 (일치 시)
    UPDATE SET e1.hire_date = e2.hire_date,
               e1.salary = e2.salary,
               e1.commission_pct = e2.commission_pct
WHEN NOT MATCHED THEN --데이터가 없으면 (불일치 시)
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
ON (e.employee_id = 103)-- PK만 가능
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
--문제 1.
--DEPTS테이블의 다음을 추가하세요
INSERT INTO DEPTS (department_id, department_name, location_id)
VALUES (280, '개발', 1800);
INSERT INTO DEPTS (department_id, department_name, location_id)
VALUES (290, '회계부', 1800);
INSERT INTO DEPTS (department_id, department_name, manager_id, location_id)
VALUES (300, '재정', 301, 1800);
INSERT INTO DEPTS (department_id, department_name, manager_id, location_id)
VALUES (310, '인사', 302, 1800);
INSERT INTO DEPTS (department_id, department_name, manager_id, location_id)
VALUES (320, '영업', 303, 1700);
DELETE FROM DEPTS WHERE department_id = 320;
COMMIT;
--문제 2.
--DEPTS테이블의 데이터를 수정합니다
--1. department_name 이 IT Support 인 데이터의 department_name을 IT bank로 변경
--2. department_id가 290인 데이터의 manager_id를 301로 변경
--3. department_name이 IT Helpdesk인 데이터의 부서명을 IT Help로 ,
--매니저아이디를 303으로, 지역아이디를 1800으로 변경하세요
--4. 재정, 인사 영업 의 매니저아이디를 301로 한번에 변경하세요.
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
WHERE department_name IN ('재정','인사','영업');
      
SELECT * FROM DEPTS;
--문제 3.
--삭제의 조건은 항상 primary key로 합니다, 여기서 primary key는 department_id라고 가정합니다.
--1. 부서명 영업부를 삭제 하세요
--2. 부서명 NOC를 삭제하세요
SELECT * FROM DEPTS;
--1
DELETE FROM DEPTS WHERE department_id = 320;
--2
DELETE FROM DEPTS WHERE department_id = 220;

--문제4
--1. Depts 사본테이블에서 department_id 가 200보다 큰 데이터를 삭제하세요.
--2. Depts 사본테이블의 manager_id가 null이 아닌 데이터의 manager_id를 전부 100으로 변경하세요.
--3. Depts 테이블은 타겟 테이블 입니다.
--4. Departments테이블은 매번 수정이 일어나는 테이블이라고 가정하고 Depts와 비교하여
--일치하는 경우 Depts의 부서명, 매니저ID, 지역ID를 업데이트 하고
--새로유입된 데이터는 그대로 추가해주는 merge문을 작성하세요.
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
--문제 5
--1. jobs_it 사본 테이블을 생성하세요 (조건은 min_salary가 6000보다 큰 데이터만 복사합니다)
--2. jobs_it 테이블에 다음 데이터를 추가하세요
--3. jobs_it은 타겟 테이블 입니다
--4. jobs테이블은 매번 수정이 일어나는 테이블이라고 가정하고 jobs_it과 비교하여
--min_salary컬럼이 0보다 큰 경우 기존의 데이터는 min_salary, max_salary를 업데이트 하고 새로 유입된
--데이터는 그대로 추가해주는 merge문을 작성하세요
--1
ROLLBACK;
SELECT * FROM jobs;
CREATE TABLE jobs_it AS (SELECT * FROM jobs WHERE 1 = 1 AND min_salary > 6000);
SELECT * FROM jobs_it;
--2
INSERT INTO jobs_it VALUES ('IT_DEV', '아이티개발팀', 6000, 20000); 
INSERT INTO jobs_it VALUES ('NET_DEV', '네트워크개발팀', 5000, 20000);
INSERT INTO jobs_it VALUES ('SEC_DEV', '보안개발팀', 6000, 19000); 
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