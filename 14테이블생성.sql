--DDL�� CREATE, ALTER, DROP
--����Ŭ ��ǥ ������ Ÿ�� ( VARCHAR2() - ��������, CHAR - ��������, NUMBER() - ����, DATE - ��¥)

CREATE TABLE dept2 (
    DEPT_NO NUMBER(2), -- �ڸ��� -> ����
    DEPT_NAME VARCHAR2(20), -- �ִ� 20BYTE, ���� ������
    DEPT_YN CHAR(1), --1BYTE ����������
    DEPT_DATE DATE, -- ��¥
    DEPT_BONUS NUMBER(10, 3) -- 10�ڸ�, �Ҽ��� 3�ڸ� -> �Ǽ�
);

DESC dept2;

INSERT INTO dept2 VALUES(99, 'SALES', 'Y', SYSDATE, 3.14);
INSERT INTO dept2 VALUES(98, 'SALES', 'ȫ', SYSDATE, 3.14); -- �ѱ� = 2Byte

SELECT * FROM dept2;
COMMIT;
--------------------------------------------------------------------------------
--�� �߰�
ALTER TABLE dept2 ADD (DEPT_COUNT NUMBER(3) );

--�� �̸� ����
ALTER TABLE dept2 RENAME COLUMN dept_count TO emp_count;

--�� ����(Ÿ�� ����)
ALTER TABLE dept2 MODIFY (emp_count NUMBER(10) );

--�� ����
ALTER TABLE dept2 DROP COLUMN emp_count;

SELECT * FROM DEPT2;
--���̺� ����
DROP TABLE dept2; 
-- DROP TABLE dept2 CASCADE �������Ǹ�; --��������FK�� ����, ���̺� ����

--------------------------------------------------------------------------------
--���� ����
--�� ���� ���� ���� ( ���̺� ���� ��ÿ� �� ���� �����ϴ� )

--���� ���� �̸��� �ڵ� ������
CREATE TABLE depts2 (
    dept_no NUMBER(2)       PRIMARY KEY, --CONSTRAINT ���� ����
    dept_name VARCHAR2(20)  NOT NULL,
    dept_date DATE          DEFAULT SYSDATE, --��������X (�÷��� �⺻��)
    dept_phone VARCHAR2(20) UNIQUE, --�ߺ� ����, �����ؾ� �ϴ� ���� (NULL OK, �ߺ�X)
    dept_bonus NUMBER(10)   CHECK(dept_bonus > 0), --dept_bonus�� 0���� Ŀ�� ��
    loca NUMBER(4)          REFERENCES locations(location_id) --FK (�ܷ� Ű)
);

--���� ���� �̸��� ����
CREATE TABLE depts2 (
    dept_no NUMBER(2)       CONSTRAINT dept2_pk PRIMARY KEY, 
    dept_name VARCHAR2(20)  CONSTRAINT dept2_name_nn NOT NULL,
    dept_date DATE          DEFAULT SYSDATE, --��������X (�÷��� �⺻��)
    dept_phone VARCHAR2(20) CONSTRAINT dept2_phone_uk UNIQUE,
    dept_bonus NUMBER(10)   CONSTRAINT dept2_bonus_ck CHECK( dept_bonus > 0 ),
    loca NUMBER(4)          CONSTRAINT dept2_loca_fk REFERENCES locations(location_id)
);

--���̺� ���� �������� (���� Ű, ���� FK�� ������ ����)
CREATE TABLE depts2 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(20) NOT NULL,
    dept_date DATE        DEFAULT SYSDATE,
    dept_phone VARCHAR2(20),
    dept_bonus NUMBER(10),
    loca NUMBER(4),
    --
    CONSTRAINT dept_pk PRIMARY KEY (dept_no /*, dept_name -- ���� Ű*/), 
    CONSTRAINT dept_phone_uk UNIQUE (dept_phone),
    CONSTRAINT dept_bonus_ck CHECK (dept_bonus > 0),
    CONSTRAINT dept_loca_fk FOREIGN KEY (loca) REFERENCES locations(location_id)
);

DESC depts2;
--��ü ���Ἲ (NULL�� �ߺ����� ������� ����)
INSERT INTO depts2 VALUES(10, 'HONG', SYSDATE, '010...', 10000, 1000);
INSERT INTO depts2 VALUES(10, 'HONG', SYSDATE, '010...', 10000, 1000); --dept_no�� 10�� �ߺ�

--���� ���Ἲ ( �������̺��� PK�� �ƴ� ���� FK�� �� �� ����)
-- loca 500�� locations�� PK�� �ƴϴ�
INSERT INTO depts2 VALUES(20, 'HONG', SYSDATE, '01011111111', 10000, 500); -- ERROR
--������ ���Ἲ (���� Į���� ���ǵ� ���̾�� �Ѵ�)
INSERT INTO depts2 VALUES(30, 'HONG', SYSDATE, '01022222222', -1000, 1000);

-------------------------------------------------------------------------------
--���� ������ �߰� OR ����
DROP TABLE depts2;

CREATE TABLE depts2 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(20),
    dept_date DATE        DEFAULT SYSDATE, -- ���� ���� X (Į���� �⺻��)
    dept_phone VARCHAR2(20),
    dept_bonus NUMBER(10),
    loca NUMBER(4)
    --
--    CONSTRAINT dept_pk PRIMARY KEY (dept_no /*, dept_name -- ���� Ű*/), 
--    CONSTRAINT dept_phone_uk UNIQUE (dept_phone),
--    CONSTRAINT dept_bonus_ck CHECK (dept_bonus > 0),
--    CONSTRAINT dept_loca_fk FOREIGN KEY (loca) REFERENCES locations(location_id)
);

--���� ������ ������ ����
ALTER TABLE depts2 ADD CONSTRAINT dept_pk PRIMARY KEY (dept_no);
ALTER TABLE depts2 ADD CONSTRAINT dept_phone_uk UNIQUE (dept_phone);
ALTER TABLE depts2 ADD CONSTRAINT dept_bonus_ck CHECK (dept_bonus > 0 );
ALTER TABLE depts2 ADD CONSTRAINT dept_loca_fk FOREIGN KEY (loca) REFERENCES locations(location_id);
--NOT NULL�� MODIFY ������ �����Ѵ�
ALTER TABLE depts2 MODIFY dept_name VARCHAR2(20) NOT NULL;

--���� ���� ����
ALTER TABLE depts2 DROP CONSTRAINT dept_loca_fk;

--------------------------------------------------------------------------------
--���� ����
CREATE TABLE MEMBERS (
    m_name VARCHAR2(3) NOT NULL ,
    m_num NUMBER(10) CONSTRAINT mem_memnum_pk PRIMARY KEY,
    reg_date DATE NOT NULL CONSTRAINT mem_regdate_uk UNIQUE,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    loca NUMBER(4) CONSTRAINT mem_loca_loc_locid_fk REFERENCES locations(location_id)
);

SELECT * FROM user_constraints WHERE table_name = 'MEMBERS'; -- ���� ���� Ȯ��

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

