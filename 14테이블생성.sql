--DDL문 CREATE, ALTER, DROP
--오라클 대표 데이터 타입 ( VARCHAR2() - 가변문자, CHAR - 고정문자, NUMBER() - 숫자, DATE - 날짜)

CREATE TABLE dept2 (
    DEPT_NO NUMBER(2), -- 자리수 -> 정수
    DEPT_NAME VARCHAR2(20), -- 최대 20BYTE, 가변 문자형
    DEPT_YN CHAR(1), --1BYTE 고정문자형
    DEPT_DATE DATE, -- 날짜
    DEPT_BONUS NUMBER(10, 3) -- 10자리, 소수부 3자리 -> 실수
);

DESC dept2;

INSERT INTO dept2 VALUES(99, 'SALES', 'Y', SYSDATE, 3.14);
INSERT INTO dept2 VALUES(98, 'SALES', '홍', SYSDATE, 3.14); -- 한글 = 2Byte

SELECT * FROM dept2;
COMMIT;
--------------------------------------------------------------------------------
--열 추가
ALTER TABLE dept2 ADD (DEPT_COUNT NUMBER(3) );

--열 이름 변경
ALTER TABLE dept2 RENAME COLUMN dept_count TO emp_count;

--열 수정(타입 변경)
ALTER TABLE dept2 MODIFY (emp_count NUMBER(10) );

--열 삭제
ALTER TABLE dept2 DROP COLUMN emp_count;

SELECT * FROM DEPT2;
--테이블 삭제
DROP TABLE dept2; 
-- DROP TABLE dept2 CASCADE 제약조건명; --제약조건FK도 삭제, 테이블도 삭제

--------------------------------------------------------------------------------
--제약 조건
--열 레벨 제약 조건 ( 테이블 생성 당시에 열 옆에 적습니다 )

--제약 조건 이름이 자동 생성됨
CREATE TABLE depts2 (
    dept_no NUMBER(2)       PRIMARY KEY, --CONSTRAINT 생략 가능
    dept_name VARCHAR2(20)  NOT NULL,
    dept_date DATE          DEFAULT SYSDATE, --제약조건X (컬럼의 기본값)
    dept_phone VARCHAR2(20) UNIQUE, --중복 없이, 유일해야 하는 값만 (NULL OK, 중복X)
    dept_bonus NUMBER(10)   CHECK(dept_bonus > 0), --dept_bonus는 0보다 커야 함
    loca NUMBER(4)          REFERENCES locations(location_id) --FK (외래 키)
);

--제약 조건 이름을 지정
CREATE TABLE depts2 (
    dept_no NUMBER(2)       CONSTRAINT dept2_pk PRIMARY KEY, 
    dept_name VARCHAR2(20)  CONSTRAINT dept2_name_nn NOT NULL,
    dept_date DATE          DEFAULT SYSDATE, --제약조건X (컬럼의 기본값)
    dept_phone VARCHAR2(20) CONSTRAINT dept2_phone_uk UNIQUE,
    dept_bonus NUMBER(10)   CONSTRAINT dept2_bonus_ck CHECK( dept_bonus > 0 ),
    loca NUMBER(4)          CONSTRAINT dept2_loca_fk REFERENCES locations(location_id)
);

--테이블 레벨 제약조건 (슈퍼 키, 다중 FK등 선언이 가능)
CREATE TABLE depts2 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(20) NOT NULL,
    dept_date DATE        DEFAULT SYSDATE,
    dept_phone VARCHAR2(20),
    dept_bonus NUMBER(10),
    loca NUMBER(4),
    --
    CONSTRAINT dept_pk PRIMARY KEY (dept_no /*, dept_name -- 슈퍼 키*/), 
    CONSTRAINT dept_phone_uk UNIQUE (dept_phone),
    CONSTRAINT dept_bonus_ck CHECK (dept_bonus > 0),
    CONSTRAINT dept_loca_fk FOREIGN KEY (loca) REFERENCES locations(location_id)
);

DESC depts2;
--개체 무결성 (NULL과 중복값을 허용하지 않음)
INSERT INTO depts2 VALUES(10, 'HONG', SYSDATE, '010...', 10000, 1000);
INSERT INTO depts2 VALUES(10, 'HONG', SYSDATE, '010...', 10000, 1000); --dept_no에 10이 중복

--참조 무결성 ( 참조테이블의 PK가 아닌 값이 FK에 들어갈 수 없음)
-- loca 500은 locations에 PK가 아니다
INSERT INTO depts2 VALUES(20, 'HONG', SYSDATE, '01011111111', 10000, 500); -- ERROR
--도메인 무결성 (값은 칼럼에 정의된 값이어야 한다)
INSERT INTO depts2 VALUES(30, 'HONG', SYSDATE, '01022222222', -1000, 1000);

-------------------------------------------------------------------------------
--제약 조건을 추가 OR 삭제
DROP TABLE depts2;

CREATE TABLE depts2 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(20),
    dept_date DATE        DEFAULT SYSDATE, -- 제약 조건 X (칼럼의 기본값)
    dept_phone VARCHAR2(20),
    dept_bonus NUMBER(10),
    loca NUMBER(4)
    --
--    CONSTRAINT dept_pk PRIMARY KEY (dept_no /*, dept_name -- 슈퍼 키*/), 
--    CONSTRAINT dept_phone_uk UNIQUE (dept_phone),
--    CONSTRAINT dept_bonus_ck CHECK (dept_bonus > 0),
--    CONSTRAINT dept_loca_fk FOREIGN KEY (loca) REFERENCES locations(location_id)
);

--제약 조건은 수정이 없음
ALTER TABLE depts2 ADD CONSTRAINT dept_pk PRIMARY KEY (dept_no);
ALTER TABLE depts2 ADD CONSTRAINT dept_phone_uk UNIQUE (dept_phone);
ALTER TABLE depts2 ADD CONSTRAINT dept_bonus_ck CHECK (dept_bonus > 0 );
ALTER TABLE depts2 ADD CONSTRAINT dept_loca_fk FOREIGN KEY (loca) REFERENCES locations(location_id);
--NOT NULL은 MODIFY 문으로 수정한다
ALTER TABLE depts2 MODIFY dept_name VARCHAR2(20) NOT NULL;

--제약 조건 삭제
ALTER TABLE depts2 DROP CONSTRAINT dept_loca_fk;

--------------------------------------------------------------------------------
--연습 문제
CREATE TABLE MEMBERS (
    m_name VARCHAR2(3) NOT NULL ,
    m_num NUMBER(10) CONSTRAINT mem_memnum_pk PRIMARY KEY,
    reg_date DATE NOT NULL CONSTRAINT mem_regdate_uk UNIQUE,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    loca NUMBER(4) CONSTRAINT mem_loca_loc_locid_fk REFERENCES locations(location_id)
);

SELECT * FROM user_constraints WHERE table_name = 'MEMBERS'; -- 제약 조건 확인

INSERT INTO MEMBERS VALUES ('AAA', 1, '18-07-01', 'M',1800);
INSERT INTO MEMBERS VALUES ('BBB', 2, '18-07-02', 'F',1900);
INSERT INTO MEMBERS VALUES ('CCC', 3, '18-07-03', 'M',2000);
INSERT INTO MEMBERS VALUES ('DDD', 4, SYSDATE, 'M',2000);

SELECT * FROM MEMBERS;

SELECT m_name,
       m_num,
       l.street_address,
       l.location_id
FROM members m
JOIN locations l 
ON m.loca = l.location_id
ORDER BY m_num;

COMMIT;

