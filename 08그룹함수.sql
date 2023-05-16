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