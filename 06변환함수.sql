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

---------------------------------------------------------------------------------
--NULL���� ���� ��ȯ
--NVL(�÷�, NULL�� ��� ó��)
SELECT NVL(NULL,0) FROM dual;
SELECT first_name, commission_pct* 100 FROM employees; --NULL ������ => NULL
SELECT first_name, NVL(commission_pct,0) * 100 FROM employees; --NULL�� ��, 0���� ó��

--NVL2(�÷�, NULL�� �ƴѰ�� ó��, NULL�� ��� ó��)
SELECT NVL2(NULL, '���� �ƴմϴ�','���Դϴ�') FROM dual; --�Է��� NULL�̹Ƿ� '���Դϴ�'
SELECT first_name,
       salary,
       commission_pct,   
       NVL2(commission_pct, salary + (salary * commission_pct) , salary) AS �޿�
FROM employees; -- �ѱ޿� �� �ΰ�

--DECODE() - ELSE IF ���� ��ü�ϴ� �Լ�
SELECT DECODE('C', 'A', 'A�Դϴ�', --'�÷�|��' '�� ��' '���'
                   'B', 'B�Դϴ�',
                   'C', 'C�Դϴ�',
                   'ABC�� �ƴմϴ�') FROM dual; --C �Դϴ�/ ������'ABC �ƴմϴ�'��� OK
                   
SELECT job_id, 
       DECODE(job_id, 'IT_PROG', salary * 0.3,
                      'FI_MGR', salary * 0.2,
                                       salary)
FROM employees; --it_prog, fi_mgr �� ���� �����Ѵ�

--CASE WHEN THEN ELSE
--1st 
SELECT job_id,
       CASE job_id WHEN 'IT_PROG' THEN salary * 0.3
                   WHEN 'FI_MGR'  THEN salary * 0.2
                   ELSE salary
       END 
FROM employees;
--2nd ( ��� �� OR �ٸ� �÷��� �� ����)
SELECT job_id,
       CASE WHEN job_id = 'IT_PROG' THEN salary * 0.3
            WHEN job_id = 'FI_MGR'  THEN salary * 0.2
            ELSE salary
       END
FROM employees;

--COALESCE(A, B) - NVL�� ���� (NULL�� ��쿡 0(��ǥ ��)���� ġȯ)
SELECT COALESCE( commission_pct, 0) FROM employees;

--------------------------------------------------------------------------------
--���� 1.
--�������ڸ� �������� EMPLOYEE���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 10�� �̻���
--����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��� ������.
SELECT employee_id AS �����ȣ,
       first_name ||' ' || last_name AS �����,
       hire_date AS �Ի�����,
       TRUNC((SYSDATE - hire_date) / 365) AS �ټӳ�� -- HERE���� �ɷ��� ���� �ټӳ���� ����
FROM employees
WHERE TRUNC((SYSDATE - hire_date) / 365) >= 10 --WHERE ������ ���� ���� ����
ORDER BY �ټӳ�� DESC;

--���� 2.
--EMPLOYEE ���̺��� manager_id�÷��� Ȯ���Ͽ� first_name, manager_id, ������ ����մϴ�.
--100�̶�� �������, 
--120�̶�� �����ӡ�
--121�̶�� ���븮��
--122��� �����塯
--�������� ���ӿ��� ���� ����մϴ�.
--���� 1) department_id�� 50�� ������� ������θ� ��ȸ�մϴ�
SELECT first_name, manager_id,
       CASE manager_id WHEN 100 THEN '���'
                       WHEN 120 THEN '����'
                       WHEN 121 THEN '�븮'
                       WHEN 122 THEN '����'
                       ELSE '�ӿ�'
       END AS ����
FROM employees
WHERE department_id = 50; --department_id �� 50�� ����� ���