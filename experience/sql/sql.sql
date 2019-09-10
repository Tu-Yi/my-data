-- 1. 每个员工的所有信息
SELECT * FROM EMPLOYEES
-- 2. 每个人的部门编号，姓名，薪水
SELECT DEPARTMENT_ID,LAST_NAME,SALARY FROM EMPLOYEES
-- 3. 每个人的年薪
SELECT SALARY*12 FROM EMPLOYEES
-- 4. 求每个人的年薪，列的别名：“年薪”
SELECT SALARY*12 "年薪" FROM EMPLOYEES
-- 5. 求 10 这个部门的所有员工
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=10
-- 6. 求名字是 KING 的这个人的信息
SELECT * FROM EMPLOYEES WHERE UPPER(LAST_NAME)='KING'
-- 7. 求薪水大于 2000 的员工信息
SELECT * FROM EMPLOYEES WHERE SALARY > 2000
-- 8. 求部门不是 10 的员工信息
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID <> 10
-- 9. 求薪水在 800 和 1500 之间的员工信息(包含 800 和 1500)
SELECT * FROM EMPLOYEES WHERE SALARY BETWEEN 800 AND 1500
-- 10. 列出 deptno 为 10 或者 30，并且工资>2000 的所有人
SELECT * FROM EMPLOYEES WHERE SALARY>2000 and DEPARTMENT_ID in (10,30)
-- 11. 利用 in 操作符，列出部门 10 和 20 的人员
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID in (10,20)
-- 12. 利用 like 操作符，查处名字中含有"H"的人员
SELECT * FROM EMPLOYEES WHERE LAST_NAME LIKE '%H%'
-- 13. 分别利用 like 操作符和正则表达式，查处名字中含有"S"或者"M"的人员
SELECT * FROM EMPLOYEES WHERE LAST_NAME LIKE '%S%' OR LAST_NAME LIKE '%M%'
-- 14. 计算 emp 表中的所有人员的平均薪水
SELECT AVG(SALARY) FROM EMPLOYEES
-- 15. 计算 emp 表中最高薪水
SELECT MAX(SALARY) FROM EMPLOYEES
-- 16. 计算 emp 表中最低薪水
SELECT MIN(SALARY) FROM EMPLOYEES
-- 17. 计算 emp 表中薪水大于 1000 的人员的个数
SELECT COUNT(*) FROM EMPLOYEES WHERE SALARY>1000
-- 18. 计算 emp 表中薪水的总和
SELECT SUM(SALARY) FROM EMPLOYEES
-- 19. 计算 emp 表中薪水和津贴的总和
SELECT SUM(SALARY)+SUM(COMMISSION_PCT) FROM EMPLOYEES
-- 20. 求各部门最高薪水
SELECT DEPARTMENT_ID, MAX(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID
-- 21. 按照部门和职位分组，分别求最高薪水，该组人员个数
SELECT DEPARTMENT_ID,JOB_ID,MAX(SALARY),COUNT(*) FROM EMPLOYEES GROUP BY DEPARTMENT_ID,JOB_ID ORDER BY DEPARTMENT_ID, MAX(SALARY) DESC
-- 22. 求薪水最高的员工姓名
SELECT FIRST_NAME || ' ' || LAST_NAME FROM EMPLOYEES e WHERE e.SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES)
-- 23. 求平均薪水是 2000 以上的部门
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID HAVING AVG(SALARY)>2000
-- 24. 求每个部门的平均薪水，并按照薪水降序排列
SELECT DEPARTMENT_ID, AVG(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID ORDER BY AVG(SALARY) DESC
-- 25. 求每个部门薪水在 1200 以上的雇员的平均薪水、最高薪水，并且分组结果中只包含平均薪水大于 1500 的部门，排序按照部门平均薪水倒序排列
SELECT
	AVG( SALARY ),
	MAX( SALARY ) 
FROM
	EMPLOYEES 
WHERE
	SALARY > 1200 
GROUP BY
	DEPARTMENT_ID 
HAVING
	AVG( SALARY ) > 1500 
ORDER BY
	AVG( SALARY ) DESC
-- 26. 把雇员按部门分组， 求最高薪水， 部门号， 过滤掉名字中第二个字母是'A'的， 要求分组后的平均薪水>1500， 按照部门编号倒序排列
SELECT
	MAX( SALARY ),
	DEPARTMENT_ID 
FROM
	EMPLOYEES 
WHERE
	LAST_NAME NOT LIKE '__A%' 
GROUP BY
	DEPARTMENT_ID 
HAVING
	AVG( SALARY ) > 1500 
ORDER BY
	DEPARTMENT_ID DESC
-- 27. 求平均薪水最高的部门的部门编号
SELECT
	DEPARTMENT_ID,
	AVG( SALARY ) 
FROM
	EMPLOYEES 
GROUP BY
	DEPARTMENT_ID 
HAVING
	AVG( SALARY ) = (
	SELECT
		MAX(
		AVG( SALARY )) 
	FROM
		EMPLOYEES 
	GROUP BY
	DEPARTMENT_ID)
-- 28. 求出 emp 表中哪些人是经理人，打印出名字和编号
SELECT e.LAST_NAME,e.EMPLOYEE_ID FROM EMPLOYEES e,EMPLOYEES em WHERE e.MANAGER_ID = em.EMPLOYEE_ID
-- 29. 求比普通员工的最高薪水还要高的经理人名称
SELECT
	e.LAST_NAME 
FROM
	EMPLOYEES e,
	EMPLOYEES em 
WHERE
	e.MANAGER_ID = em.EMPLOYEE_ID 
	AND e.SALARY > (
	SELECT
		MAX( SALARY ) 
	FROM
		EMPLOYEES 
	WHERE
	EMPLOYEE_ID NOT IN ( SELECT e.EMPLOYEE_ID FROM EMPLOYEES e, EMPLOYEES em WHERE e.MANAGER_ID = em.EMPLOYEE_ID ))
-- 30. 每个部门平均薪水的等级(需要用到表的连接)
SELECT
	e.DEPARTMENT_ID,
	e.sal,
	s.gra 
FROM
	( SELECT DEPARTMENT_ID, AVG( SALARY ) AS sal FROM EMPLOYEES GROUP BY DEPARTMENT_ID ) e
	INNER JOIN GRADES s ON e.sal BETWEEN s.lowest_sal 
	AND s.highest_sal
-- 31. 求部门经理人中平均薪水最低的部门名称
SELECT
	d.DEPARTMENT_NAME 
FROM
	(
	SELECT
		DEPARTMENT_ID,
		AVG( SALARY ) 
	FROM
		EMPLOYEES 
	WHERE
		LAST_NAME IN ( SELECT e.LAST_NAME FROM EMPLOYEES e, EMPLOYEES em WHERE e.MANAGER_ID = em.EMPLOYEE_ID ) 
	GROUP BY
		DEPARTMENT_ID 
	ORDER BY
	AVG( SALARY )) e
	NATURAL JOIN DEPARTMENTS d 
WHERE
	ROWNUM =1
-- 32. 求薪水最高的前 5 名雇员
SELECT ROWNUM, e.* FROM  (SELECT ROWNUM,LAST_NAME, SALARY FROM EMPLOYEES ORDER BY SALARY DESC) e WHERE ROWNUM<6
-- 33. 求薪水最高的第 6 到第 10 名雇员
SELECT
	em.* 
FROM
	( SELECT ROWNUM AS rn, e.* FROM ( SELECT ROWNUM, LAST_NAME, SALARY FROM EMPLOYEES ORDER BY SALARY DESC ) e ) em 
WHERE
	em.rn BETWEEN 6 
	AND 10











