--����ȯ �Լ�
--�ڵ� ����ȯ
SELECT * FROM employees WHERE department_id = '30'; --�ڵ�����ȯ -���� -> ����
SELECT SYSDATE -5, SYSDATE - '5' FROM employees; --�ڵ�����ȯ -����->���� //��� ����

--���� ����ȯ
--TO_CHAR(��¥, ��¥����)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM dual; --��¥ -> ����
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD HH24/MI/SS') FROM dual; --��¥ -> ���� (�ð��� 24�ð� ����)
SELECT TO_CHAR(SYSDATE, 'YYYY��MM��DD��') FROM dual; --���˹��ڰ� �ƴѰ��� ""�� �����ش�
SELECT TO_CHAR(SYSDATE, 'YYYY"��"MM"��"DD"��"') FROM dual;
SELECT TO_CHAR(hire_date, 'YYYY-MM-DD') FROM employees; --hire_date�� ���ڷ�

--TO_CHAR(����, ��������)
SELECT TO_CHAR(200000, '$999,999,999') FROM dual; --9�ڸ� ���ڷ� ��ȯ
SELECT TO_CHAR(200000.1234, '999999.999') FROM dual; --�Ҽ��� 3�ڸ�������
SELECT TO_CHAR(salary * 1300, 'L999,999,999') FROM employees; --L : ����ȭ���ȣ
SELECT TO_CHAR(salary * 1300, 'L0999,999,999') FROM employees; -- 0: ���� �ڸ��� 0���� ä��

--TO_NUMBER(����, ��������)
SELECT '3.14' + 2000 FROM dual; --�ڵ� ����ȯ
SELECT TO_NUMBER('3.14') + 2000 FROM dual; --����� ����ȯ 
SELECT '$3,000' + 2000 FROM dual; --$3,000�� �ڵ� ����ȯ �� �� // ����
SELECT TO_NUMBER('$3,300', '$999,999') + 2000 FROM dual; --����� ����ȯ, $ : ��ȣ ����, 999,999 �ڸ���

--TO_DATE(����, ��¥����)
SELECT SYSDATE - '2023-05-16' FROM dual; --ERROR '����' - ��¥ ���� �Ұ�
SELECT SYSDATE- TO_DATE('2023-05-16', 'YYYY-MM-DD') FROM dual;--���ڸ� ��¥ �������� �ٲپ� ����
SELECT SYSDATE - TO_DATE('2023/05/16 11:31:23', 'YYYY/MM/DD HH:MI:SS') FROM dual;

--�Ʒ� ���� YYYY��MM��DD�� ���·� ���
SELECT '20050105' FROM dual;
SELECT TO_CHAR(TO_DATE('20050105', 'YYYYMMDD'), 'YYYY"��"MM"��"DD"��"') FROM dual;

--�Ʒ� ���� ���� ��¥�� �� �� ���̸� ���϶�
SELECT '20005��01��05��' FROM dual;
SELECT SYSDATE - TO_DATE('2005��01��05��', 'YYYY"��"MM"��"DD"��"') FROM dual;
