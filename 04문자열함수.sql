-- ���ڿ� �Լ�
-- LOWER(), INITCAP(), UPPER()

--���� ���̺� : ���� �������� ���
SELECT 'HELLO', 'HELLO', 'HELLO' FROM DUAL;
--���� ���̺� : ���� �������� ���
SELECT LOWER('HELLO'), INITCAP('HELLO'), UPPER('HELLO') FROM DUAL;-- DUAL ���� ���̺�
SELECT LOWER(first_name), INITCAP(first_name), UPPER(first_name) FROM employees;
--�Լ��� WHERE������ ���� �ȴ�
SELECT first_name FROM employees WHERE UPPER(first_name) = 'STEVEN'; --�빮�ڷ� ��

--LENGTH() -����, INSTR() - ���� ã�� ( ���� ���� 0 ��ȯ )
SELECT first_name, LENGTH(first_name), INSTR(first_name, 'e') FROM employees;

--SUBSTR() - ���ڿ� �ڸ���, CONCAT() - ���ڿ� ��ġ��
SELECT first_name, SUBSTR(first_name, 1, 3) FROM employees; -- 1��° ���� 3���ڸ� �ڸ�
SELECT first_name, CONCAT(first_name, last_name), first_name || last_name FROM employees;

--LPAD() -���� ä���, RPAD() - ������ ä���
SELECT LPAD('HELLO', 10, '*') FROM DUAL; -- 10ĭ ���, ���� ���� ä��
SELECT LPAD(salary, 10, '*') FROM employees; -- *****24000
SELECT RPAD(salary, 10, '-') FROM employees; -- 24000----- ������ ���� ä��

--LTRIM() - ���� ���� ����, RTRIM() - ������ ���� ����, TRIM() - ���� ����
SELECT '   HELLO' FROM DUAL; -- ���鵵 �ϳ��� ���� '   HELLO'
SELECT LTRIM('   HELLO') FROM DUAL; -- 'HELLO' ���� ���� ����
SELECT LTRIM(first_name, 'A') FROM employees; -- ���ʿ� ó�� �߰ߵǴ� ���� A ����
SELECT RTRIM('   HELLO ') AS RESULT FROM DUAL; -- '   HELLO' ������ ���� ����
SELECT TRIM('   HELLO ') FROM DUAL; -- ���� ���� ����

--REPLACE() - ���ڿ� ����
SELECT REPLACE('HELLO WORLD', 'HELLO', 'BYE') FROM DUAL; -- BYE WORLD
--' '������ ''�� ���� -> ��� ���� ����
SELECT REPLACE('HELLO WORLD ~!', ' ', '') AS result FROM DUAL; -- HELLOWORLD~!
--��ø : REPLACE�� ���ڿ��� �ٸ� REPLACE �Լ��� �Ű������� �ִ´� 
SELECT REPLACE(REPLACE('HELLO WORLD ~!', 'HELLO', 'BYE'), ' ', '') FROM DUAL;--BYEWORLD~!

--------------------------------------------------------------------------------------
--���� ����

--���� 1.
--EMPLOYEES ���̺� ���� �̸�, �Ի����� �÷����� �����ؼ� �̸������� �������� ��� �մϴ�.
--���� 1) �̸� �÷��� first_name, last_name�� �ٿ��� ����մϴ�.
--���� 2) �Ի����� �÷��� xx/xx/xx�� ����Ǿ� �ֽ��ϴ�. xxxxxx���·� �����ؼ� ����մϴ�.
SELECT CONCAT(first_name, last_name) AS �̸�, REPLACE(hire_date, '/','') AS �Ի�����
FROM employees ORDER BY �̸�;

--���� 2.
--EMPLOYEES ���̺� ���� phone_numbe�÷��� ###.###.####���·� ����Ǿ� �ִ�
--���⼭ ó�� �� �ڸ� ���� ��� ���� ������ȣ (02)�� �ٿ� ��ȭ ��ȣ�� ����ϵ��� ������ �ۼ��ϼ���
SELECT CONCAT('(02)', SUBSTR(phone_number, INSTR(PHONE_NUMBER, '.'), LENGTH(phone_number)))
FROM employees; 
--���� 3. 
--EMPLOYEES ���̺��� JOB_ID�� it_prog�� ����� �̸�(first_name)�� �޿�(salary)�� ����ϼ���.
--���� 1) ���ϱ� ���� ���� �ҹ��ڷ� �Է��ؾ� �մϴ�.(��Ʈ : lower �̿�)
--���� 2) �̸��� �� 3���ڱ��� ����ϰ� �������� *�� ����մϴ�. 
--�� ���� �� ��Ī�� name�Դϴ�.(��Ʈ : rpad�� substr �Ǵ� substr �׸��� length �̿�)
--���� 3) �޿��� ��ü 10�ڸ��� ����ϵ� ������ �ڸ��� *�� ����մϴ�. 
--�� ���� �� ��Ī�� salary�Դϴ�.(��Ʈ : lpad �̿�)
SELECT RPAD (SUBSTR(first_name, 1, 3), LENGTH(first_name), '*') AS name,
       LPAD(salary, 10, '*') AS salary
FROM employees WHERE LOWER(job_id) = 'it_prog'; 


