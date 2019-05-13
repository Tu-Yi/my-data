-- select

-- 表达式
select EMPLOYEE_ID,FIRST_NAME, SALARY, (SALARY*12+100) as SALARY from EMPLOYEES
select EMPLOYEE_ID,FIRST_NAME, SALARY, (SALARY+100)*12 as SALARY from EMPLOYEES

-- 空值计算返回都是空
select EMPLOYEE_ID,FIRST_NAME, SALARY, (SALARY*12*COMMISSION_PCT) SALARY from EMPLOYEES 

-- 别名可以用as或者空格，小写自动转成大写
select EMPLOYEE_ID,FIRST_NAME, SALARY, COMMISSION_PCT comm from EMPLOYEES 
-- 别名有特殊符号，需要用双引号，不会自动转成大写
select EMPLOYEE_ID,FIRST_NAME, SALARY*12 "Annual Salary" from EMPLOYEES 

-- 连接符
select LAST_NAME || FIRST_NAME from EMPLOYEES 
select LAST_NAME || SALARY, LAST_NAME || 12*SALARY from EMPLOYEES
select LAST_NAME || JOB_ID as "Employee" from EMPLOYEES

-- 文字字符串 单引号
select LAST_NAME || ' is a ' || JOB_ID as "Employee Details" from EMPLOYEES
select LAST_NAME || 55 || JOB_ID as "Employee Details" from EMPLOYEES

-- 去除重复行
select DISTINCT DEPARTMENT_ID from EMPLOYEES
-- DISTINCT作用后面所有字段
select DISTINCT DEPARTMENT_ID,LAST_NAME from EMPLOYEES ORDER BY LAST_NAME