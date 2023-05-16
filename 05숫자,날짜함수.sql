--숫자함수
--ROUND() - 반올림
SELECT ROUND(45.123, 2), ROUND(45.523), ROUND(45.523,-1) FROM dual; -- 45.12, 46, 50
-- 자리 수 입력 안 할시 0, -1 : 10의 자리까지 반올림

--TRUNC() - 절삭
SELECT TRUNC(45.523,2), TRUNC(45.523), TRUNC(45.523, -1) FROM dual; -- 45.52, 45, 40
-- 기본 0, -1 : 1의 자리까지 절삭

--CEIL() - 올림
SELECT CEIL(3.14) FROM dual; -- 4
--FLOOR() - 내림
SELECT FLOOR(3.14) FROM dual; -- 3

--MOD() -나머지
SELECT TRUNC(5/3) FROM dual; -- 몫 1
SELECT MOD(5,3) AS 나머지 FROM dual; -- 나머지 2

---------------------------------------------------------------------------------
--날짜함수
SELECT SYSDATE FROM dual; --년/월/일
SELECT SYSTIMESTAMP FROM dual; --시분초 밀리세컨 을 포함한 상세한 시간 타입

--날짜의 연산 --> 일(DAY)수 기준
SELECT SYSDATE + 10 FROM dual; -- +10일
SELECT SYSDATE - 10 FROM dual; -- -10일
SELECT SYSDATE - hire_date FROM employees; -- 일(DAY) 수
SELECT (SYSDATE - hire_date) / 7 AS week FROM employees; -- 7로 나누면 주 단위
SELECT (SYSDATE - hire_date) / 365 AS year FROM employees; -- 365로 나누면 년 단위
SELECT TRUNC( (SYSDATE - hire_date) / 365 ) * 12 AS month FROM employees; -- 년 단위에 *12 월 단위 소수점 TRUNC

--날짜의 반올림, 절삭
SELECT ROUND(SYSDATE) FROM dual;
SELECT ROUND(SYSDATE, 'Day') FROM dual; --해당 주(week)의 일요일
SELECT ROUND(SYSDATE, 'Month') FROM dual; -- 월에 대한 반올림 ( 23/05/16 -> 23/06/01 )
SELECT ROUND(SYSDATE, 'Year') FROM dual; -- 년에 대한 반올림 23/01/01 (6월 미만이라서)

SELECT TRUNC(SYSDATE) FROM dual;
SELECT TRUNC(SYSDATE, 'Day') FROM dual; --해당 주(week)의 일요일
SELECT TRUNC(SYSDATE, 'Month') FROM dual; -- 월에 대한 절삭 (23/05/16 -> 23/05/01)
SELECT TRUNC(SYSDATE, 'Year') FROM dual; -- 년에 대한 절삭 (23/05/16 -> 23/01/01)


