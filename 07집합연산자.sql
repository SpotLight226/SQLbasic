--집합연산자
--UNION -합집합, UNIONALL-합집합, INTERSECT-교집합, MINUS-차집합

--UNION - 합집합, 중복 X
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%' -- ; 빠짐
UNION
SELECT first_name, hire_date FROM employees WHERE department_id = 20; -- 미쉘이 중복이기 때문에, 중복 제거
--UNIONALL - 합집합, 중복 O
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%' 
UNION ALL
SELECT first_name, hire_date FROM employees WHERE department_id = 20; 
--INTERSECT - 교집합 (중복된 값만)
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%' 
INTERSECT
SELECT first_name, hire_date FROM employees WHERE department_id = 20; 
--MINUS - 차집합 (중복된 값 제거)
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '04%'
MINUS
SELECT first_name, hire_date FROM employees WHERE department_id = 20; 

--집합 연산자는 컬럼수가 일치 해야 한다
SELECT first_name, hire_date, last_name FROM employees WHERE hire_date LIKE '04%'
UNION -- ERROR
SELECT first_name, hire_date FROM employees WHERE department_id = 20; -- 컬럼 수 불일치
--컬럼 수가 일치한다면, 다양한 형태로 사용이 된다
SELECT '홍길동', TO_CHAR(SYSDATE) FROM dual
UNION ALL
SELECT '이순신', '05/01/01' FROM dual
UNION ALL
SELECT '홍길자', '06/02/02' FROM dual
UNION ALL
SELECT last_name, TO_CHAR(hire_date) FROM employees; --컬럼이 이름(문자), 날짜(문자) 2개

------------------------------------------------------------------------------
--분석함수 - 행에 대한 결과를 출력하는 기능, OVER() 와 함께 사용된다

SELECT first_name,
       salary,
       RANK() OVER(ORDER BY salary DESC) AS 중복순서, --RANK() - 우선순위 중복 O
       DENSE_RANK() OVER(ORDER BY salary DESC) AS 중복순서X, --DENSE_RANK() - 우선순위 중복 X
       ROW_NUMBER() OVER(ORDER BY salary DESC) AS 데이터번호, --ROW_NUMBER -조건 만족하는 모든 행의 번호
       COUNT(*) OVER() AS 전체데이터개수, --전체 데이터 개수
       ROWNUM AS 조회순서-- 조회가 일어난 순서
FROM employees;
