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
