--�����Լ�
--ROUND() - �ݿø�
SELECT ROUND(45.123, 2), ROUND(45.523), ROUND(45.523,-1) FROM dual; -- 45.12, 46, 50
-- �ڸ� �� �Է� �� �ҽ� 0, -1 : 10�� �ڸ����� �ݿø�

--TRUNC() - ����
SELECT TRUNC(45.523,2), TRUNC(45.523), TRUNC(45.523, -1) FROM dual; -- 45.52, 45, 40
-- �⺻ 0, -1 : 1�� �ڸ����� ����

--CEIL() - �ø�
SELECT CEIL(3.14) FROM dual; -- 4
--FLOOR() - ����
SELECT FLOOR(3.14) FROM dual; -- 3

--MOD() -������
SELECT TRUNC(5/3) FROM dual; -- �� 1
SELECT MOD(5,3) AS ������ FROM dual; -- ������ 2

---------------------------------------------------------------------------------
--��¥�Լ�
SELECT SYSDATE FROM dual; --��/��/��
SELECT SYSTIMESTAMP FROM dual; --�ú��� �и����� �� ������ ���� �ð� Ÿ��

--��¥�� ���� --> ��(DAY)�� ����
SELECT SYSDATE + 10 FROM dual; -- +10��
SELECT SYSDATE - 10 FROM dual; -- -10��
SELECT SYSDATE - hire_date FROM employees; -- ��(DAY) ��
SELECT (SYSDATE - hire_date) / 7 AS week FROM employees; -- 7�� ������ �� ����
SELECT (SYSDATE - hire_date) / 365 AS year FROM employees; -- 365�� ������ �� ����
SELECT TRUNC( (SYSDATE - hire_date) / 365 ) * 12 AS month FROM employees; -- �� ������ *12 �� ���� �Ҽ��� TRUNC

--��¥�� �ݿø�, ����
SELECT ROUND(SYSDATE) FROM dual;
SELECT ROUND(SYSDATE, 'Day') FROM dual; --�ش� ��(week)�� �Ͽ���
SELECT ROUND(SYSDATE, 'Month') FROM dual; -- ���� ���� �ݿø� ( 23/05/16 -> 23/06/01 )
SELECT ROUND(SYSDATE, 'Year') FROM dual; -- �⿡ ���� �ݿø� 23/01/01 (6�� �̸��̶�)

SELECT TRUNC(SYSDATE) FROM dual;
SELECT TRUNC(SYSDATE, 'Day') FROM dual; --�ش� ��(week)�� �Ͽ���
SELECT TRUNC(SYSDATE, 'Month') FROM dual; -- ���� ���� ���� (23/05/16 -> 23/05/01)
SELECT TRUNC(SYSDATE, 'Year') FROM dual; -- �⿡ ���� ���� (23/05/16 -> 23/01/01)


