--Ʈ����� (���� �۾�����)

SHOW AUTOCOMMIT;
--����Ŀ�� ��
SET AUTOCOMMIT ON;
--����Ŀ�� ����
SET AUTOCOMMIT OFF;

DELETE FROM depts WHERE department_id = 10;

SAVEPOINT DELETE10; -- ���̺�����Ʈ ���

DELETE FROM depts WHERE department_id = 20;

SAVEPOINT DELETE20; -- ���̺�����Ʈ ���

SELECT * FROM depts;

ROLLBACK TO DELETE10;  -- 10�� ���̺�����Ʈ�� �ѹ� (20�� ����� ������ �ѹ�)

ROLLBACK; -- ������ Ŀ�� ����

--------------------------------------------------------------------------------
INSERT INTO depts VALUES(300, 'DEMO', NULL, 1800);

COMMIT; --Ʈ����� �ݿ�

SELECT * FROM depts;



