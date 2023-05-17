--그룹함수 : 여러 행에 대하여 집계 출력
--AVG, SUM, MIN, MAX, COUNT
SELECT AVG(salary), SUM(salary), MIN(salary), MAX(salary), COUNT(salary) FROM employees;
SELECT MIN(hire_date), MAX(hire_date) FROM employees; --날짜 형식도 MIN, MAX 사용가능
SELECT MIN(first_name), MAX(first_name) FROM employees; --문자 형식 MIN, MAX

--COUNT(컬럼) : NULL이 아닌 데이터 개수
SELECT COUNT(first_name) FROM employees;
SELECT COUNT(department_id) FROM employees; -- 106 (NULL 제외)
SELECT COUNT(commission_pct) FROM employees; -- 35 (NULL 제외)
SELECT COUNT(*) FROM employees; -- NULL포함 한 전체 행의 개수    

--그룹함수 : 그룹함수와 일반컬럼을 동시에 출력할 수 없다 (오라클만)
SELECT first_name, SUM(salary) FROM employees;

-------------------------------------------------------------------------------
-- GROUP BY한 것은 SELECT절에 작성해 주어야 한다
SELECT department_id, AVG(salary), SUM(salary), COUNT(*) --그룹함수와 함께 사용 가능
FROM employees
GROUP BY department_id;
--주의점 : 그룹절에 사용할 컬럼만, SELECT절에 사용한다
SELECT department_id, first_name 
FROM employees
GROUP BY department_id; --ERROR
--2개 이상의 그룹화
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;
--그룹함수는 WHERE절에 적용할 수 없다
SELECT job_id, AVG(salary)
FROM employees
--WHERE AVG(salary) >= 10000 -- ERROR : group function is not allowed here
GROUP BY job_id;
-------------------------------------------------------------------------------
--그룹의 조건은 HAVING절을 사용한다
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id
HAVING AVG(salary) >= 10000; --salary 평균이 10000 이상인 job_id만

SELECT department_id, COUNT(*) --COUNT(*) 행의 수 
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 30;

SELECT job_id, SUM(salary), SUM( NVL(commission_pct, 0) ) --NVL : NULL을 목표값으로 변경
FROM employees
WHERE job_id NOT IN ('IT_PROG') --IT_PROG 제외
GROUP BY job_id -- job_id로 그룹화
HAVING SUM(salary) >= 20000 --salary합계가 20000이상
ORDER BY SUM(salary) DESC; --내림차순 정렬
--부서아이디가 50번 이상인 부서를 그룹화 시키고 그룹평균급여 5000이상만 출력
SELECT department_id, AVG(salary)
FROM employees
WHERE department_id >= 50
GROUP BY department_id
HAVING AVG(salary) >= 5000
ORDER BY department_id;
--------------------------------------------------------------------------------
--ROLLUP - 각 그룹의 총계를 아래에 출력
SELECT department_id, TRUNC(AVG(salary))
FROM employees
GROUP BY ROLLUP(department_id);

SELECT department_id, job_id, TRUNC(AVG(salary))
FROM employees
GROUP BY ROLLUP(department_id, job_id);

--CUBE : 서브 그룹에 대한 컬럼 출력
SELECT department_id, job_id, TRUNC(AVG(salary)), COUNT(*)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

--GROUPING() - 그룹절로 생성되면 0반환, ROLLUP or CUBE로 생성되면 1반환
SELECT department_id,
       job_id,
       DECODE(GROUPING(job_id), 1, '소계', job_id), --1이면 '소계' 아니면 job_id
       GROUPING(job_id),
       SUM(salary),
       COUNT(*)
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id;

-------------------------------------------------------------------------------
--연습문제
--문제 1.
--사원 테이블에서 JOB_ID별 사원 수를 구하세요.
--사원 테이블에서 JOB_ID별 월급의 평균을 구하세요. 월급의 평균 순으로 내림차순 정렬하세요
SELECT job_id,
       COUNT(*) AS 사원수,
       AVG(salary) AS 급여평균
FROM employees
GROUP BY job_id
ORDER BY 급여평균 DESC; 

--문제 2.
--사원 테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT TO_CHAR(hire_date, 'YY') AS 입사년도,
       COUNT(*) AS 사원수     
FROM employees
GROUP BY TO_CHAR(hire_date, 'YY');

--문제 3.
--급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요.
--단, 부서 평균 급여가 2000이상인 부서만 출력
SELECT department_id,
       TRUNC(AVG(salary)) AS 평균급여
FROM employees
WHERE salary >= 1000
GROUP BY department_id
HAVING AVG(salary) >= 2000;

--문제 4.
--사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
--department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
--조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
--조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT department_id,
       TRUNC(AVG(salary + salary * commission_pct), 2) AS 급여평균, --커미션 적용
       SUM(salary + salary * commission_pct) AS 급여합계,
       COUNT(*) AS 사원수
FROM employees
WHERE commission_pct IS NOT NULL --NULL은 IS or IS NOT 로 비교
GROUP BY department_id;

--문제 5.
--직업별 월급합, 총합계를 출력하세요
SELECT DECODE(GROUPING(job_id), 1, '합계', job_id) AS job_id,
       SUM(salary) AS 월급합
FROM employees
GROUP BY ROLLUP(job_id)
ORDER BY job_id;

--문제 6.
--부서별, JOB_ID를 그룹핑 하여 토탈, 합계를 출력하세요.
--GROUPING() 을 이용하여 소계 합계를 표현하세요
SELECT DECODE(GROUPING(department_id), 1, '합계', department_id) AS department_id,
       DECODE(GROUPING(job_id), 1, '소계', job_id) AS job_id,
       COUNT(*) AS TOTAL,
       SUM(salary) AS SUM
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY SUM; --ORDER BY절에 AS로 만든 별칭 사용 가능


