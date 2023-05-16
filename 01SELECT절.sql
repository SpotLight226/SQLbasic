-- 오라클 주석문
/*
여러줄 주석
오라클은 대소문자 구분 X - 일반적으로 문법은 대문자, 데이터 종류는 소문자
실행 : ctrl + enter
이전 실행 문장 커서 위치 변경으로 다시 실행 가능
*/
SELECT * FROM employees;
SELECT first_name, email, hire_date FROM employees;
SELECT job_id, salary, department_id FROM employees;

SELECT * FROM departments;

--연산
--컬럼을 조회하는 위치에서 * / + -
SELECT first_name, salary FROM employees;
SELECT first_name, salary, salary + salary * 0.1 FROM employees;

--NULL
SELECT first_name, commission_pct FROM employees;

--엘리어스 AS : 별칭 설정 // 생략 가능 
SELECT first_name AS 이름,
       last_name AS 성,
       salary 급여,
       salary + salary * 0.1 총급여
FROM employees; -- 키워드 별, 컬럼 별로 줄을 바꿔서 작성

--문자열의 연결 ||
--오라클은 문자를 ''로 표현한다
SELECT first_name || ' ' || last_name FROM employees; -- 문자열 더하기
-- 숫자 리터럴은 '' 사용 X, '를 하나만 쓰고 싶다면 ''' 처럼 '' 사이에 넣는다
SELECT first_name || ' ' || last_name || '''s salary $' || salary FROM employees;
SELECT first_name || ' ' || last_name || '''s salary $' || salary AS 급여내역
FROM employees;

--DISTINCT 중복행 제거
SELECT first_name, department_id FROM employees; -- 중복 있음
SELECT DISTINCT department_id FROM employees; -- 부서명 중복 제거
SELECT DISTINCT first_name, department_id FROM employees; -- 이름, 부서명이 동일한 중복행 제거

--ROWID(데이터의 주소), ROWNUM(조회된 순서)
SELECT ROWNUM, ROWID, employee_id, first_name FROM employees;