--형변환 함수
--자동 형변환
SELECT * FROM employees WHERE department_id = '30'; --자동형변환 -문자 -> 숫자
SELECT SYSDATE -5, SYSDATE - '5' FROM employees; --자동형변환 -문자->숫자 //결과 같음

--강제 형변환
--TO_CHAR(날짜, 날짜포맷)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM dual; --날짜 -> 문자
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD HH24/MI/SS') FROM dual; --날짜 -> 문자 (시간이 24시간 형식)
SELECT TO_CHAR(SYSDATE, 'YYYY년MM월DD일') FROM dual; --포맷문자가 아닌경우는 ""로 묶어준다
SELECT TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일"') FROM dual;
SELECT TO_CHAR(hire_date, 'YYYY-MM-DD') FROM employees; --hire_date를 문자로

--TO_CHAR(숫자, 숫자포맷)
SELECT TO_CHAR(200000, '$999,999,999') FROM dual; --9자리 문자로 변환
SELECT TO_CHAR(200000.1234, '999999.999') FROM dual; --소수점 3자리까지만
SELECT TO_CHAR(salary * 1300, 'L999,999,999') FROM employees; --L : 지역화폐기호
SELECT TO_CHAR(salary * 1300, 'L0999,999,999') FROM employees; -- 0: 남는 자리를 0으로 채움

--TO_NUMBER(문자, 숫자포맷)
SELECT '3.14' + 2000 FROM dual; --자동 형변환
SELECT TO_NUMBER('3.14') + 2000 FROM dual; --명시적 형변환 
SELECT '$3,000' + 2000 FROM dual; --$3,000은 자동 형변환 못 함 // 에러
SELECT TO_NUMBER('$3,300', '$999,999') + 2000 FROM dual; --명시적 형변환, $ : 기호 제거, 999,999 자리수

--TO_DATE(문자, 날짜포맷)
SELECT SYSDATE - '2023-05-16' FROM dual; --ERROR '문자' - 날짜 연산 불가
SELECT SYSDATE- TO_DATE('2023-05-16', 'YYYY-MM-DD') FROM dual;--문자를 날짜 형식으로 바꾸어 연산
SELECT SYSDATE - TO_DATE('2023/05/16 11:31:23', 'YYYY/MM/DD HH:MI:SS') FROM dual;

--아래 값을 YYYY년MM월DD일 형태로 출력
SELECT '20050105' FROM dual;
SELECT TO_CHAR(TO_DATE('20050105', 'YYYYMMDD'), 'YYYY"년"MM"월"DD"일"') FROM dual;

--아래 값과 현재 날짜의 일 수 차이를 구하라
SELECT '20005년01월05일' FROM dual;
SELECT SYSDATE - TO_DATE('2005년01월05일', 'YYYY"년"MM"월"DD"일"') FROM dual;

---------------------------------------------------------------------------------
--NULL값에 대한 변환
--NVL(컬럼, NULL일 경우 처리)
SELECT NVL(NULL,0) FROM dual;
SELECT first_name, commission_pct* 100 FROM employees; --NULL 연산자 => NULL
SELECT first_name, NVL(commission_pct,0) * 100 FROM employees; --NULL일 시, 0으로 처리

--NVL2(컬럼, NULL이 아닌경우 처리, NULL인 경우 처리)
SELECT NVL2(NULL, '널이 아닙니다','널입니다') FROM dual; --입력이 NULL이므로 '널입니다'
SELECT first_name,
       salary,
       commission_pct,   
       NVL2(commission_pct, salary + (salary * commission_pct) , salary) AS 급여
FROM employees; -- 총급여 얼마 인가

--DECODE() - ELSE IF 문을 대체하는 함수
SELECT DECODE('C', 'A', 'A입니다', --'컬럼|값' '비교 값' '결과'
                   'B', 'B입니다',
                   'C', 'C입니다',
                   'ABC가 아닙니다') FROM dual; --C 입니다/ 마지막'ABC 아닙니다'없어도 OK
                   
SELECT job_id, 
       DECODE(job_id, 'IT_PROG', salary * 0.3,
                      'FI_MGR', salary * 0.2,
                                       salary)
FROM employees; --it_prog, fi_mgr 일 때만 연산한다

--CASE WHEN THEN ELSE
--1st 
SELECT job_id,
       CASE job_id WHEN 'IT_PROG' THEN salary * 0.3
                   WHEN 'FI_MGR'  THEN salary * 0.2
                   ELSE salary
       END 
FROM employees;
--2nd ( 대소 비교 OR 다른 컬럼의 비교 가능)
SELECT job_id,
       CASE WHEN job_id = 'IT_PROG' THEN salary * 0.3
            WHEN job_id = 'FI_MGR'  THEN salary * 0.2
            ELSE salary
       END
FROM employees;

--COALESCE(A, B) - NVL과 유사 (NULL일 경우에 0(목표 값)으로 치환)
SELECT COALESCE( commission_pct, 0) FROM employees;

--------------------------------------------------------------------------------
--문제 1.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요.
SELECT employee_id AS 사원번호,
       first_name ||' ' || last_name AS 사원명,
       hire_date AS 입사일자,
       TRUNC((SYSDATE - hire_date) / 365) AS 근속년수 -- HERE에서 걸러낸 것을 근속년수로 만듦
FROM employees
WHERE TRUNC((SYSDATE - hire_date) / 365) >= 10 --WHERE 조건이 가장 먼저 실행
ORDER BY 근속년수 DESC;

--문제 2.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘사원’, 
--120이라면 ‘주임’
--121이라면 ‘대리’
--122라면 ‘과장’
--나머지는 ‘임원’ 으로 출력합니다.
--조건 1) department_id가 50인 사람들을 대상으로만 조회합니다
SELECT first_name, manager_id,
       CASE manager_id WHEN 100 THEN '사원'
                       WHEN 120 THEN '주임'
                       WHEN 121 THEN '대리'
                       WHEN 122 THEN '과장'
                       ELSE '임원'
       END AS 직급
FROM employees
WHERE department_id = 50; --department_id 가 50인 사람들 대상