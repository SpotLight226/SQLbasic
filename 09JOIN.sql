SELECT * FROM info;
SELECT * FROM auth;

--INNER JOIN (INNER 생략가능) : 붙을 수 없는 데이터가 없으면 안 나옴
SELECT * FROM info INNER JOIN auth ON info.auth_id = auth.auth_id;

--원하는 테이블만 출력
--auth_id는 양쪽 테이블에 모두 존재하기 때문에, SELECT에서 테이블 명을 함께 적어줘야 한다
SELECT id,
       title,
       auth.auth_id, --어느 테이블의 컬럼을 출력하는지 명시 <테이블>.컬럼명
       name
FROM info INNER JOIN auth ON info.auth_id = auth.auth_id;

--테이블 엘리어스
SELECT i.id,
       i.title,
       i.auth_id,
       a.name
FROM info i
INNER JOIN auth a
ON i.auth_id = a.auth_id;

--조건
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
SELECT * FROM auth a LEFT OUTER JOIN info i ON a.auth_id = i.auth_id; --위와 동일한 결과
SELECT * FROM info i FULL OUTER JOIN auth a ON i.auth_id = a.auth_id; --양쪽 유실 없이 전부 다 나옴

--CROSS JOIN - 잘못된 JOIN의 형태
SELECT * FROM info i CROSS JOIN auth a;

-------------------------------------------------------------------------------
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM locations;
--INNER JOIN
SELECT * FROM employees e JOIN departments d ON e.department_id = d.department_id;
--LEFT JOIN
SELECT * FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id;
--JOIN은 여러번 들어갈 수 있다
SELECT * FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
                          LEFT JOIN locations l ON d.location_id = l.location_id;

--SELF JOIN
SELECT e1.*,
       e2.first_name AS 상급자
FROM employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

--------------------------------------------------------------------------------
--오라클 조인 구문
--FROM절 아래에 테이블을 나열, WHERE에 JOIN의 조건을 쓴다

--INNER JOIN
SELECT * FROM employees e, departments d
WHERE e.department_id = d.department_id;
--LEFT JOIN : 왼쪽에 붙이고자 하는 테이블에 (+)
SELECT * FROM employees e, departments d
WHERE e.department_id = d.department_id(+); 
--RIGHT JOIN 오른쪽에 붙이고자 하는 테이블에 (+)
SELECT * FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;
--FULL OUTER JOIN 은 없다
--조건이 있다면 AND로 연결해서 사용한다