--서브쿼리
--SELECT문이 SELECT구문으로 들어가는 형태 : 스칼라 서브쿼리
--SELECT문이 FROM구문으로 들어가는 형태 : 인라인뷰
--SELECT문이 WHERE구문으로 들어가는 형태 : 서브쿼리
--서브쿼리는 반드시 () 안에 작성한다

--단일행 서브쿼리 - 리턴되는 행이 1개인 서브쿼리
--Nancy보다 salary가 높은 사람
SELECT * FROM employees WHERE salary > 12008;
-- 아래와 같이 작성
SELECT *
FROM employees
WHERE salary > (SELECT salary FROM employees WHERE first_name = 'Nancy');

--employee_id가 103번인 사람과 동일한 직군
SELECT job_id FROM employees WHERE employee_id = 103;

SELECT *
FROM employees
WHERE job_id = (SELECT job_id FROM employees WHERE employee_id = 103);

--주의점 : 단일행 이어야 한다, 컬럼값도 1개 여야 한다
SELECT *
FROM employees
WHERE job_id = (SELECT * FROM employees WHERE employee_id = 103); --ERROR:컬럼이 여러개

SELECT *  --ERROR : 행이 2개
FROM employees
WHERE job_id = (SELECT * FROM employees WHERE employee_id = 104 OR employee_id = 103);

--------------------------------------------------------------------------------
--다중행 서브쿼리 - 행이 여러 개라면 IN,ANY,ALL로 비교한다
SELECT salary FROM employees WHERE first_name = 'David'; --4800, 9500, 6800

--IN 동일한 값을 찾는다 = IN(4800, 6800, 9500)
SELECT *
FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE first_name = 'David');

--ANY 최소값 보다 큼, 최대값 보다 작음
SELECT *
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE first_name = 'David');--급여가 4800보다 큰 사람들

SELECT *
FROM employees
WHERE salary < ANY (SELECT salary FROM employees WHERE first_name = 'David');--급여가 9500보다 작은 사람들

--ALL 최대 값보다 큼, 최소 값보다 작음
SELECT *
FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE first_name = 'David'); --급여가 9500보다 큰 사람들

SELECT *
FROM employees
WHERE salary < ALL (SELECT salary FROM employees WHERE first_name = 'David'); --급여가 4800보다 작은 사람들

--직업이 IT_PROG인 사람들의 최소 값보다 큰 급여를 받는 사람들
SELECT *
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE job_id = 'IT_PROG');

--------------------------------------------------------------------------------
--스칼라 서브쿼리
--JOIN시 특정테이블의 컬럼 1개를 가지고 올 때, 유리하다 
SELECT first_name,
       email,
       (SELECT department_name FROM departments d WHERE d.department_id = e.department_id)
FROM employees e
ORDER BY first_name;
--JOIN문 - 위와 같은 결과
SELECT first_name,
       email,
       department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY first_name;

--각 부서의 매니저 이름을 출력
SELECT * FROM departments;
SELECT * FROM employees;
--JOIN
SELECT *
FROM departments d
LEFT JOIN employees e ON d.manager_id = e.employee_id;
--스칼라
SELECT d.*,
       (SELECT first_name FROM employees e WHERE e.employee_id = d.manager_id)
FROM departments d;

--스칼라 쿼리는 여러 번 가능
SELECT * FROM jobs; -- job_title
SELECT * FROM departments; --department_name
SELECT * FROM employees;

SELECT e.first_name,
       e.job_id,
       (SELECT job_title FROM jobs j WHERE j.job_id = e.job_id) AS job_title,
       (SELECT department_name FROM departments d WHERE d.department_id = e.department_id) AS department_name
FROM employees e;

--각 부서의 사원 수를 출력 + 부서정보
SELECT department_name,
       COUNT(*)
FROM departments d
JOIN employees e
ON e.department_id = d.department_id
GROUP BY d.department_name;
-- 위와 같은 결과 -> NVL로 NULL값을 0으로 변경했기 때문에, NULL이 0으로 나옴
SELECT d.department_name,
       NVL((SELECT COUNT(*) FROM employees e
            WHERE e.department_id = d.department_id GROUP BY department_id), 0) AS 사원수
FROM departments d;

-------------------------------------------------------------------------------
--인라인 뷰 : FROM절에 SELECT문
--가상 테이블 형태

--ROWNUM는 조회된 순서이기 때문에, ORDER와 같이 사용되는 ROWNUM이 섞이는 문제가 있다
SELECT first_name,
       salary,
       ROWNUM
FROM (SELECT *
        FROM employees
        ORDER BY salary DESC);
-- AS 사용하여 별칭 지정 (컬럼 지정) 후, 별칭.* 로 모든 요소 사용        
SELECT ROWNUM,
       A.*
FROM (SELECT first_name,
             salary
      FROM employees
      ORDER BY salary
      ) A ;

--ROWNUM은 무조건 1번째부터 조회가 가능하기 때문에 BETWEEN 11 AND 20이 불가능
SELECT first_name,
       salary,
       ROWNUM
FROM (SELECT *
        FROM employees
        ORDER BY salary DESC)
WHERE ROWNUM BETWEEN 11 AND 20;

--2번째 인라인뷰에서 ROWNUM을 RN으로 컬럼화
SELECT *
FROM (SELECT first_name, 
             salary,
             ROWNUM AS RN -- 내림차순 정렬된 컬럼에서 조회된 순서를 RN으로 컬럼화
      FROM (SELECT * -- salary 내림차순으로 정렬
            FROM employees
            ORDER BY salary DESC))
WHERE RN >= 51 AND RN <= 60; -- RN은 컬럼이기 때문에 사용가능

--인라인 뷰의 예시
SELECT TO_CHAR(REGDATE, 'YY-MM-DD') AS REGDATE, --인라인 뷰에서 만든 가상의 컬럼을 사용할 수 있다
       NAME
FROM (SELECT '홍길동' AS NAME, SYSDATE AS REGDATE FROM dual --두 테이블을 UNION으로 합쳐서, 컬럼을 생성
      UNION ALL
      SELECT '이순신', SYSDATE FROM dual);

--인라인 뷰의 응용
--부서별 사원수

SELECT D.*,
       e.TOTAL
FROM departments d
LEFT JOIN (SELECT department_id, --가상 테이블 = 인라인 뷰
                  COUNT(*) AS TOTAL 
           FROM employees
           GROUP BY department_id) e 
ON d.department_id = e.department_id;

SELECT *
FROM (SELECT department_id, COUNT(*)
      FROM employees
      GROUP BY department_id);

--정리
--단일행( 대소비교 ) vs 다중행 서브쿼리(IN, ANY, ALL)
--스칼라 쿼리 - LEFT JOIN과 같은 역할, 한번에 1개의 컬럼을 가져올 때
--인라인 뷰 - FROM에 들어가는 가상 테이블, 

--------------------------------------------------------------------------------
--문제 1.
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
--EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요
--평균보다 높은 사원
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees);
-- 사원 수
SELECT COUNT(*) AS 사원수
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees);
                
--IT_PROG 보다 높은 사원
SELECT * 
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees
                HAVING job_id = 'IT_PROG');

--문제 2.
---DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id와
--EMPLOYEES테이블에서 department_id가 일치하는 모든 사원의 정보를 검색하세요.

SELECT *
FROM employees
WHERE department_id =(SELECT department_id FROM departments WHERE manager_id = 100);

--문제 3.
---EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
---EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 갖는 모든 사원의 데이터를 출력하세요.
SELECT *
FROM employees
WHERE manager_id > (SELECT manager_id FROM employees WHERE first_name = 'Pat');

SELECT * -- = ANY 도 가능
FROM employees
WHERE manager_id IN (SELECT manager_id FROM employees WHERE first_name = 'James');

--문제 4.
---EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요
SELECT *
FROM (SELECT first_name || ' ' || last_name AS 이름,
             ROWNUM AS RN
      FROM (SELECT *
            FROM employees
            ORDER BY first_name DESC))e
WHERE RN BETWEEN 41 AND 50;
--WHERE RN >40 AND RN<=50;

--문제 5.
---EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고,
--31~40번째 데이터의 행 번호, 사원id, 이름, 번호, 입사일을 출력하세요
SELECT *
FROM (SELECT ROWNUM RN,
             e.*
      FROM (SELECT employee_id 사원ID,
                   first_name || ' ' || last_name 이름,
                   phone_number 번호,
                   hire_date 입사일
            FROM employees
            ORDER BY hire_date) e
     )
WHERE RN BETWEEN 31 AND 40;

--문제 6.
--employees테이블 departments테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
--인라인 뷰
SELECT employee_id AS 직원아이디,
       first_name || ' ' || last_name AS 이름,
       e.department_id AS 부서아이디,
       d.department_name AS 부서명
FROM employees e
LEFT JOIN (SELECT department_id, 
                  department_name
           FROM departments) d
ON e.department_id = d.department_id
ORDER BY employee_id;
--LEFT JOIN
SELECT employee_id AS 직원아이디,
       first_name || ' ' || last_name AS 이름,
       d.department_id AS 부서아이디,
       department_name AS 부서명
FROM employees e 
LEFT JOIN departments d ON d.department_id = e.department_id
ORDER BY employee_id;

--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT employee_id AS 직원아이디,
       first_name || ' ' || last_name AS 이름,
       e.department_id AS 부서아이디,
       (SELECT department_name
        FROM departments d
        WHERE d.department_id = e.department_id) AS 부서명 
FROM employees e
ORDER BY employee_id;

--문제 8.
--departments테이블 locations테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 매니저아이디, 로케이션아이디, 스트릿_어드레스, 포스트 코드, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬

--원하는 것만 뽑은 것
SELECT d.*,
       l.street_address AS 주소,
       l.postal_code AS 포스트코드,
       l.city AS 도시
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
       l.street_address AS 주소,
       l.postal_code AS 포스트코드,
       l.city AS 도시
FROM departments d
LEFT JOIN locations l
ON d.location_id = l.location_id
ORDER BY department_id;

--문제 9.
--문제 8의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT d.*,
       (SELECT street_address FROM locations l WHERE d.location_id = l.location_id) AS 주소,
       (SELECT postal_code FROM locations l WHERE d.location_id = l.location_id) AS 우편번호,
       (SELECT city FROM locations l WHERE d.location_id = l.location_id) AS 도시
FROM departments d
ORDER BY department_id;

--문제 10.
--locations테이블 countries 테이블을 left 조인하세요
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬

SELECT l.location_id AS 로케이션아이디,
       l.street_address AS 주소,
       l.city AS 시티,
       c.*
FROM locations l
LEFT JOIN (SELECT country_id,
                  country_name
           FROM countries) c
ON l.country_id = c.country_id
ORDER BY country_name;

--문제 11.
--문제 10의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT l.location_id AS 로케이션아이디,
       l.street_address AS 주소,
       l.city AS 시티,
       l.country_id,
       (SELECT country_name FROM countries c WHERE l.country_id = c.country_id)
FROM locations l;

--문제 12. 
--employees테이블, departments테이블을 left조인 hire_date를 오름차순 기준으로 1-10번째 데이터만 출력합니다
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 전화번호, 입사일, 부서아이디, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 틀어지면 안됩니다.

SELECT e.*,
       (SELECT department_name FROM departments d WHERE e.부서아이디 = d.department_id) AS 부서이름
FROM (SELECT ROWNUM AS 번호,
             employee_id AS 직원아이디,
             CONCAT(first_name, last_name) AS 이름,
             phone_number AS 전화번호,
             hire_date AS 입사일,
             department_id AS 부서아이디,
             department_name AS 부서이름
      FROM (SELECT *
            FROM employees
            ORDER BY hire_date)) e
ORDER BY 번호;

SELECT *
FROM (SELECT ROWNUM AS 번호,
             f.*
      FROM (SELECT employee_id AS 직원아이디,
                   CONCAT(first_name, last_name) AS 이름,
                   phone_number AS 전화번호,
                   hire_date AS 입사일,
                   e.department_id AS 부서아이디,
                   d.department_name AS 부서이름
            FROM employees e
            LEFT JOIN departments d
            ON e.department_id = d.department_id
            ORDER BY hire_date) f ) d
WHERE 번호 > 0 AND 번호 <=10;




--문제 13. 
--EMPLOYEES 과 DEPARTMENTS 테이블에서 JOB_ID가 SA_MAN 사원의 정보의 LAST_NAME, JOB_ID, 
--DEPARTMENT_ID,DEPARTMENT_NAME을 출력하세요
SELECT * FROM employees;
SELECT * FROM departments;

SELECT last_name,
       job_id,
       e.department_id,
       (SELECT department_name
       FROM departments d
       WHERE e.department_id = d.department_id) AS 부서명
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
FROM (SELECT * -- 먼저 WHERE 절을 실행한 후 조인
      FROM employees
      WHERE job_id = 'SA_MAN') e
JOIN departments d
ON e.department_id = d.department_id;


--문제 14
--DEPARTMENT테이블에서 각 부서의 ID, NAME, MANAGER_ID와 부서에 속한 인원수를 출력하세요.
--인원수 기준 내림차순 정렬하세요.
--사람이 없는 부서는 출력하지 뽑지 않습니다

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

-- 이런 식으로 간단하게
SELECT d.department_id,
       d.department_name,
       d.manager_id,
       e.인원수
FROM departments d
JOIN (SELECT department_id, --부서별 사원수, INNER JOIN으로 NULL값 삭제
             COUNT(*) AS 인원수
      FROM employees
      GROUP BY department_id) e
ON d.department_id = e.department_id
ORDER BY 인원수 DESC;

--반대로 employees에 JOIN하는 방식 만들어 보기


--문제 15
--부서에 대한 정보 전부와, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요
--부서별 평균이 없으면 0으로 출력하세요

SELECT d.*,
       l.street_address 주소,
       l.postal_code 우편번호,
       NVL(e.평균연봉, 0) 부서별평균연봉
FROM departments d
LEFT JOIN locations l
ON d.location_id = l.location_id
LEFT JOIN (SELECT department_id,
                  TRUNC(AVG(salary)) AS 평균연봉
           FROM employees 
           GROUP BY department_id) e
ON d.department_id = e.department_id;   

--
SELECT d.*,
       l.street_address 주소,
       l.postal_code 우편번호,
       NVL(e.salary, 0)
FROM departments d
LEFT JOIN (SELECT department_id,
                  TRUNC(AVG(salary)) AS salary
           FROM employees
           GROUP BY department_id) e
ON d.department_id = e.department_id
LEFT JOIN locations l
ON d.location_id = l.location_id;

--문제 16
--문제 15결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 ROWNUM을 붙여
--1-10데이터 까지만 출력하세요

SELECT *
FROM ( SELECT ROWNUM RN,
              X.*
       FROM (SELECT d.*,
                    l.street_address 주소,
                    l.postal_code 우편번호,
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