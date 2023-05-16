--WHERE절
SELECT * FROM employees;
SELECT * FROM employees WHERE salary = 4800; -- salary값이 4800인 데이터 ( 같다 )
SELECT * FROM employees WHERE salary <> 4800; -- salary가 4800이 아닌 데이터 (같지않다)
SELECT * FROM employees WHERE department_id >= 100; --부서 id가 100보다 큰 데이터
SELECT * FROM employees WHERE department_id < 50; --부서 id가 50 미만인 데이터
SELECT * FROM employees WHERE job_id = 'AD_ASST'; --job_id가 AD_ASST인 데이터
SELECT * FROM employees WHERE hire_date = '03/09/17'; --날짜 비교

--BETWEEN~AND, IN, LIKE
SELECT * FROM employees WHERE salary BETWEEN 6000 AND 9000; --이상 ~ 이하
SELECT * FROM employees WHERE hire_date BETWEEN '08/01/01' AND '08/12/31'; --날짜도 동일

--IN
SELECT * FROM employees WHERE department_id IN (10,20,30,40,50); --정확히 일치하는
SELECT * FROM employees WHERE job_id IN ('ST_MAN', 'IT_PROG', 'HR_REP'); --문자열 일치

--LIKE
SELECT * FROM employees WHERE job_id LIKE 'IT%'; -- job_id가 IT로 시작하는
SELECT * FROM employees WHERE hire_date LIKE '03%'; --hire_date가 03으로 시작하는
SELECT * FROM employees WHERE hire_date LIKE '%03'; --hire_date가 03으로 끝나는
SELECT * FROM employees WHERE hire_date LIKE '%12%'; --12가 들어간 데이터를 전부 다
SELECT * FROM employees WHERE hire_date LIKE '___05%'; --05 앞에 _가 3개-> 3글자가 있는
SELECT * FROM employees WHERE email LIKE '_A%'; --email에서 A가 두번 째에 있는

--NOT NULL, IS NOT NULL
SELECT * FROM employees WHERE commission_pct = NULL; -- X
SELECT * FROM employees WHERE commission_pct IS NULL; --commission_pct가 null인 
SELECT * FROM employees WHERE commission_pct IS NOT NULL; --null이 아닌 데이터

--NOT
SELECT * FROM employees WHERE NOT salary >= 6000; -- NOT은 <>와 동일한 표현 / 조건의 반대
-- AND가 OR보다 우선순위가 높다
SELECT * FROM employees WHERE job_id = 'IT_PROG' AND salary >= 6000; --양쪽 조건 참일 때
SELECT * FROM employees WHERE salary >= 6000 AND salary <= 12000;--BETWEEN 6000 AND 12000
-- OR
SELECT * FROM employees WHERE job_id = 'IT_PROG' OR salary >=6000; --한쪽 조건이 참일 때
--AND, OR 같이
SELECT * FROM employees WHERE job_id = 'IT_PROG'
                        OR job_id = 'FI_MGR'
                        AND salary >= 6000; --FI중 6000이상인 사람 OR IT_PROG
                        
SELECT * FROM employees WHERE (job_id = 'IT_PROG'
                        OR job_id = 'FI_MGR') --()로 우선순위 설정
                        AND salary >= 6000; --FI, IT중 6000이상인 사람             

--------------------------------------------------------------------------------
--ORDER BY 컬럼(엘리어스 - 열 별칭)
SELECT * FROM employees ORDER BY hire_date; -- 날짜 기준 ASC
SELECT * FROM employees ORDER BY hire_date DESC; --내림 차순 정렬

SELECT * FROM employees WHERE job_id IN('IT_PROG', 'ST_MAN'); -- ST or IT
SELECT * FROM employees WHERE job_id IN('IT_PROG', 'ST_MAN') ORDER BY first_name DESC;
SELECT * FROM employees WHERE salary BETWEEN 6000 AND 12000 ORDER BY employee_id;
--ALIAS도 ORDER절에 사용할 수 있음
SELECT first_name, salary * 12 AS PAY FROM employees; --salary *12를 별칭 pay로
SELECT first_name, salary * 12 AS PAY FROM employees ORDER BY PAY ASC;
--정렬 여러개 ,로 나열
SELECT first_name, salary, job_id FROM employees ORDER BY job_id ASC,--job_id 기준 오름차순
                                                 salary DESC;--동일한 job_id있다면 내림차순
                                                 