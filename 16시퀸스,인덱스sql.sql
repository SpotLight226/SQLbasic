--������ ( ���������� �����ϴ� �� ) - PK�� ���� ����

SELECT * FROM user_sequences;

--����� ������ ����
CREATE SEQUENCE depts_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10
    MINVALUE 1
    NOCYCLE
    NOCACHE;
    
--������ ���� ( ��, ���ǰ� �ִ� ��������� ���� )
DROP SEQUENCE depts_seq;

DROP TABLE depts;
CREATE TABLE depts AS (SELECT * FROM departments WHERE 1=2); --���̺� ����
ALTER TABLE depts ADD CONSTRAINT depts_pk PRIMARY KEY (department_id); -- PK

SELECT * FROM depts;
--������ ���
SELECT depts_seq.NEXTVAL FROM dual; --�������� ������ ( ���� )
SELECT depts_seq.CURRVAL FROM dual; --�������� ���簪 
--X 10��(�������� �ִ� ���� �����ϸ� ���̻� ����� �� ����)
INSERT INTO depts VALUES (depts_seq.NEXTVAL, 'TEST', 100, 1000); 

--������ ����
ALTER SEQUENCE depts_seq MAXVALUE 99999; --�ִ� ���� 99999��
ALTER SEQUENCE depts_seq INCREMENT BY 10; --10�� �����Ѵ�

--������ ���� ����
CREATE SEQUENCE depts2_seq NOCACHE;
SELECT * FROM USER_SEQUENCES;
DROP SEQUENCE depts2_seq;

--������ �ʱ�ȭ(�������� ���̺��� ���ǰ� �ִ� ���, �������� DROP�ϸ� �ȵȴ�)
--1.���� ������
SELECT depts_seq.CURRVAL FROM dual; -- ���� 40
--2.���� ���� ������ ����
ALTER SEQUENCE depts_seq INCREMENT BY -39; -- ���� �� = -39
--3.������ ����
SELECT depts_seq.NEXTVAL FROM dual;
--4.������ �������� �ٽ� 1�� ����
ALTER SEQUENCE depts_seq INCREMENT BY 1;
--���� ���� �������� 2���� ����...

--������ VS �⺰�� ������ VS ������ ���ڿ�
--202230523-00001 - ��ǰ��ȣ
CREATE TABLE depts3 (
    dept_no VARCHAR2(30) PRIMARY KEY,
    dept_name VARCHAR2(30)
);

CREATE SEQUENCE depts3_seq NOCACHE;
--TO_CHAR(SYSDATE, 'YYYYMMDD'), LPAD(�ڸ���, 'ä�� ��')
INSERT INTO depts3
VALUES (TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'|| LPAD(depts_seq.NEXTVAL,5,0)
        , 'TEST');

SELECT * FROM depts3;

-------------------------------------------------------------------------------
--INDEX
--�ε����� PK, UK���� �ڵ������Ǵ� UNIQUE�ε����� �ִ�
--�ε����� ������ ��ȸ�� ������ ���ִ� HINT���� �̴�
--���� ������� �ʴ� �Ϲ� �÷��� �ε����� ������ �� �ִ�

-- ������ �� ��, �ε����� ������ ���� �ʴ´�
CREATE TABLE emps_it AS ( SELECT * FROM employees WHERE 1=1);
--�ε����� ���� �� ��ȸ VS �ε��� ���� �� ��ȸ
SELECT * FROM emps_it WHERE first_name = 'Allan'; 
--�ε��� ���� ( �ε����� ��ȸ�� ������ �ϱ� ������, �������ϰ� ���� �����ϸ�, ������ ������ ������ �� �ִ�)
CREATE INDEX emps_it_idx ON emps_it (first_name);
CREATE UNIQUE INDEX emps_id_idx ON emps_it (first_name); --����ũ �ε���(�÷� ���� ����ũ�ؾ� �Ѵ�)
--�ε��� ����
DROP INDEX emps_it_idx;
--�ε����� (���� �ε���) ���� �÷��� ������ �� �ִ�
CREATE INDEX emps_it_idx ON emps_it (first_name, last_name);
SELECT * FROM emps_it WHERE first_name = 'Allan'; -- �ε��� �����
SELECT * FROM emps_it WHERE first_name = 'Allan' AND last_name = 'McEwen'; -- �ε��� �����

--firts_name �������� ����
--�ε����� �������� ��Ʈ�� �ִ� ���
SELECT *
FROM ( SELECT /*+ INDEX_DESC (e emps_it_idx) */
              ROWNUM RN,
              e.*
       FROM emps_it e
       ORDER BY first_name DESC)
WHERE RN > 10 AND RN <= 20;









