-- 문자열 함수
-- LOWER(), INITCAP(), UPPER()

--가상 테이블 : 가상 모형으로 출력
SELECT 'HELLO', 'HELLO', 'HELLO' FROM DUAL;
--가상 테이블 : 가상 모형으로 출력
SELECT LOWER('HELLO'), INITCAP('HELLO'), UPPER('HELLO') FROM DUAL;-- DUAL 가상 테이블
SELECT LOWER(first_name), INITCAP(first_name), UPPER(first_name) FROM employees;
--함수는 WHERE절에도 적용 된다
SELECT first_name FROM employees WHERE UPPER(first_name) = 'STEVEN'; --대문자로 비교

--LENGTH() -길이, INSTR() - 문자 찾기 ( 없을 때는 0 반환 )
SELECT first_name, LENGTH(first_name), INSTR(first_name, 'e') FROM employees;

--SUBSTR() - 문자열 자르기, CONCAT() - 문자열 합치기
SELECT first_name, SUBSTR(first_name, 1, 3) FROM employees; -- 1번째 에서 3글자를 자름
SELECT first_name, CONCAT(first_name, last_name), first_name || last_name FROM employees;

--LPAD() -왼쪽 채우기, RPAD() - 오른쪽 채우기
SELECT LPAD('HELLO', 10, '*') FROM DUAL; -- 10칸 잡고, 왼쪽 부터 채움
SELECT LPAD(salary, 10, '*') FROM employees; -- *****24000
SELECT RPAD(salary, 10, '-') FROM employees; -- 24000----- 오른쪽 부터 채움

--LTRIM() - 왼쪽 공백 제거, RTRIM() - 오른쪽 공백 제거, TRIM() - 양쪽 제거
SELECT '   HELLO' FROM DUAL; -- 공백도 하나의 문자 '   HELLO'
SELECT LTRIM('   HELLO') FROM DUAL; -- 'HELLO' 왼쪽 공백 제거
SELECT LTRIM(first_name, 'A') FROM employees; -- 왼쪽에 처음 발견되는 문자 A 제거
SELECT RTRIM('   HELLO ') AS RESULT FROM DUAL; -- '   HELLO' 오른쪽 공백 제거
SELECT TRIM('   HELLO ') FROM DUAL; -- 양쪽 공백 제거

--REPLACE() - 문자열 변경
SELECT REPLACE('HELLO WORLD', 'HELLO', 'BYE') FROM DUAL; -- BYE WORLD
--' '공백을 ''로 변경 -> 모든 공백 제거
SELECT REPLACE('HELLO WORLD ~!', ' ', '') AS result FROM DUAL; -- HELLOWORLD~!
--중첩 : REPLACE한 문자열을 다른 REPLACE 함수에 매개변수로 넣는다 
SELECT REPLACE(REPLACE('HELLO WORLD ~!', 'HELLO', 'BYE'), ' ', '') FROM DUAL;--BYEWORLD~!

--------------------------------------------------------------------------------------
--연습 문제

--문제 1.
--EMPLOYEES 테이블 에서 이름, 입사일자 컬럼으로 변경해서 이름순으로 오름차순 출력 합니다.
--조건 1) 이름 컬럼은 first_name, last_name을 붙여서 출력합니다.
--조건 2) 입사일자 컬럼은 xx/xx/xx로 저장되어 있습니다. xxxxxx형태로 변경해서 출력합니다.
SELECT CONCAT(first_name, last_name) AS 이름, REPLACE(hire_date, '/','') AS 입사일자
FROM employees ORDER BY 이름;

--문제 2.
--EMPLOYEES 테이블 에서 phone_numbe컬럼은 ###.###.####형태로 저장되어 있다
--여기서 처음 세 자리 숫자 대신 서울 지역변호 (02)를 붙여 전화 번호를 출력하도록 쿼리를 작성하세요
SELECT CONCAT('(02)', SUBSTR(phone_number, INSTR(PHONE_NUMBER, '.'), LENGTH(phone_number)))
FROM employees; 
--문제 3. 
--EMPLOYEES 테이블에서 JOB_ID가 it_prog인 사원의 이름(first_name)과 급여(salary)를 출력하세요.
--조건 1) 비교하기 위한 값은 소문자로 입력해야 합니다.(힌트 : lower 이용)
--조건 2) 이름은 앞 3문자까지 출력하고 나머지는 *로 출력합니다. 
--이 열의 열 별칭은 name입니다.(힌트 : rpad와 substr 또는 substr 그리고 length 이용)
--조건 3) 급여는 전체 10자리로 출력하되 나머지 자리는 *로 출력합니다. 
--이 열의 열 별칭은 salary입니다.(힌트 : lpad 이용)
SELECT RPAD (SUBSTR(first_name, 1, 3), LENGTH(first_name), '*') AS name,
       LPAD(salary, 10, '*') AS salary
FROM employees WHERE LOWER(job_id) = 'it_prog'; 


