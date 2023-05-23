--시퀀스 ( 순차적으로 증가하는 값 ) - PK에 많이 사용됨

SELECT * FROM user_sequences;

--사용자 시퀀스 생성
CREATE SEQUENCE depts_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10
    MINVALUE 1
    NOCYCLE
    NOCACHE;
    
--시퀀스 삭제 ( 단, 사용되고 있는 스퀀스라면 주의 )
DROP SEQUENCE depts_seq;

DROP TABLE depts;
CREATE TABLE depts AS (SELECT * FROM departments WHERE 1=2); --테이블 생성
ALTER TABLE depts ADD CONSTRAINT depts_pk PRIMARY KEY (department_id); -- PK

SELECT * FROM depts;
--시퀀스 사용
SELECT depts_seq.NEXTVAL FROM dual; --시퀀스의 다음값 ( 공유 )
SELECT depts_seq.CURRVAL FROM dual; --시퀀스의 현재값 
--X 10번(시퀀스의 최대 값에 도달하면 더이상 사용할 수 없다)
INSERT INTO depts VALUES (depts_seq.NEXTVAL, 'TEST', 100, 1000); 

--시퀀스 수정
ALTER SEQUENCE depts_seq MAXVALUE 99999; --최대 값을 99999로
ALTER SEQUENCE depts_seq INCREMENT BY 10; --10씩 증가한다

--시퀀스 빠른 생성
CREATE SEQUENCE depts2_seq NOCACHE;
SELECT * FROM USER_SEQUENCES;
DROP SEQUENCE depts2_seq;

--시퀀스 초기화(시퀀스가 테이블에서 사용되고 있는 경우, 시퀀스를 DROP하면 안된다)
--1.현재 시퀀스
SELECT depts_seq.CURRVAL FROM dual; -- 현재 40
--2.증가 값을 음수로 변경
ALTER SEQUENCE depts_seq INCREMENT BY -39; -- 증가 값 = -39
--3.시퀀스 실행
SELECT depts_seq.NEXTVAL FROM dual;
--4.시퀀스 증가값을 다시 1로 변경
ALTER SEQUENCE depts_seq INCREMENT BY 1;
--이후 부터 시퀀스는 2에서 시작...

--시퀀스 VS 년별로 시퀀스 VS 랜덤한 문자열
--202230523-00001 - 상품번호
CREATE TABLE depts3 (
    dept_no VARCHAR2(30) PRIMARY KEY,
    dept_name VARCHAR2(30)
);

CREATE SEQUENCE depts3_seq NOCACHE;
--TO_CHAR(SYSDATE, 'YYYYMMDD'), LPAD(자리수, '채울 값')
INSERT INTO depts3
VALUES (TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'|| LPAD(depts_seq.NEXTVAL,5,0)
        , 'TEST');

SELECT * FROM depts3;

-------------------------------------------------------------------------------
--INDEX
--인덱스는 PK, UK에서 자동생성되는 UNIQUE인덱스가 있다
--인덱스의 역할은 조회를 빠르게 해주는 HINT역할 이다
--많이 변경되지 않는 일반 컬럼에 인덱스를 적용할 수 있다

-- 복사해 올 시, 인덱스는 복사해 오지 않는다
CREATE TABLE emps_it AS ( SELECT * FROM employees WHERE 1=1);
--인덱스가 없을 때 조회 VS 인덱스 생성 후 조회
SELECT * FROM emps_it WHERE first_name = 'Allan'; 
--인덱스 생성 ( 인덱스는 조회를 빠르게 하긴 하지만, 무작위하게 많이 생성하면, 오히려 성능이 떨어질 수 있다)
CREATE INDEX emps_it_idx ON emps_it (first_name);
CREATE UNIQUE INDEX emps_id_idx ON emps_it (first_name); --유니크 인덱스(컬럼 값이 유니크해야 한다)
--인덱스 삭제
DROP INDEX emps_it_idx;
--인덱스는 (결합 인덱스) 여러 컬럼을 지정할 수 있다
CREATE INDEX emps_it_idx ON emps_it (first_name, last_name);
SELECT * FROM emps_it WHERE first_name = 'Allan'; -- 인덱스 적용됨
SELECT * FROM emps_it WHERE first_name = 'Allan' AND last_name = 'McEwen'; -- 인덱스 적용됨

--firts_name 기준으로 순서
--인덱스를 기준으로 힌트를 주는 방법
SELECT *
FROM ( SELECT /*+ INDEX_DESC (e emps_it_idx) */
              ROWNUM RN,
              e.*
       FROM emps_it e
       ORDER BY first_name DESC)
WHERE RN > 10 AND RN <= 20;









