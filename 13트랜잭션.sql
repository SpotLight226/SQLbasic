--트랜잭션 (논리적 작업단위)

SHOW AUTOCOMMIT;
--오토커밋 온
SET AUTOCOMMIT ON;
--오토커밋 오프
SET AUTOCOMMIT OFF;

DELETE FROM depts WHERE department_id = 10;

SAVEPOINT DELETE10; -- 세이브포인트 기록

DELETE FROM depts WHERE department_id = 20;

SAVEPOINT DELETE20; -- 세이브포인트 기록

SELECT * FROM depts;

ROLLBACK TO DELETE10;  -- 10번 세이브포인트로 롤백 (20을 지우기 전까지 롤백)

ROLLBACK; -- 마지막 커밋 시점

--------------------------------------------------------------------------------
INSERT INTO depts VALUES(300, 'DEMO', NULL, 1800);

COMMIT; --트랜잭션 반영

SELECT * FROM depts;



