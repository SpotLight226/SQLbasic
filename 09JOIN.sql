SELECT * FROM info;
SELECT * FROM auth;

--INNER JOIN (INNER ��������) : ���� �� ���� �����Ͱ� ������ �� ����
SELECT * FROM info INNER JOIN auth ON info.auth_id = auth.auth_id;

--���ϴ� ���̺� ���
--auth_id�� ���� ���̺� ��� �����ϱ� ������, SELECT���� ���̺� ���� �Բ� ������� �Ѵ�
SELECT id,
       title,
       auth.auth_id, --��� ���̺��� �÷��� ����ϴ��� ��� <���̺�>.�÷���
       name
FROM info INNER JOIN auth ON info.auth_id = auth.auth_id;

--���̺� �����
SELECT i.id,
       i.title,
       i.auth_id,
       a.name
FROM info i
INNER JOIN auth a
ON i.auth_id = a.auth_id;

--����
SELECT *
FROM info i
INNER JOIN auth a
ON i.auth_id = a.auth_id
WHERE id IN (1,2,3)
ORDER BY id DESC;

--INNER JOIN USING
SELECT *
FROM info
INNER JOIN auth
USING (auth_id);

-------------------------------------------------------------------------------
--OUTER JOIN
--LEFT OUTER JOIN
SELECT * FROM info i LEFT OUTER JOIN auth a ON i.auth_id = a.auth_id;
SELECT * FROM info i RIGHT OUTER JOIN auth a ON i.auth_id = a.auth_id;
SELECT * FROM auth a LEFT OUTER JOIN info i ON a.auth_id = i.auth_id; --���� ������ ���
SELECT * FROM info i FULL OUTER JOIN auth a ON i.auth_id = a.auth_id; --���� ���� ���� ���� �� ����

--CROSS JOIN - �߸��� JOIN�� ����
SELECT * FROM info i CROSS JOIN auth a;

-------------------------------------------------------------------------------
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM locations;
--INNER JOIN
SELECT * FROM employees e JOIN departments d ON e.department_id = d.department_id;
--LEFT JOIN
SELECT * FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id;
--JOIN�� ������ �� �� �ִ�
SELECT * FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
                          LEFT JOIN locations l ON d.location_id = l.location_id;

--SELF JOIN
SELECT e1.*,
       e2.first_name AS �����
FROM employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

--------------------------------------------------------------------------------
--����Ŭ ���� ����
--FROM�� �Ʒ��� ���̺��� ����, WHERE�� JOIN�� ������ ����

--INNER JOIN
SELECT * FROM employees e, departments d
WHERE e.department_id = d.department_id;
--LEFT JOIN : ���ʿ� ���̰��� �ϴ� ���̺� (+)
SELECT * FROM employees e, departments d
WHERE e.department_id = d.department_id(+); 
--RIGHT JOIN �����ʿ� ���̰��� �ϴ� ���̺� (+)
SELECT * FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;
--FULL OUTER JOIN �� ����
--������ �ִٸ� AND�� �����ؼ� ����Ѵ�