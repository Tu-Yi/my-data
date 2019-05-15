--ORACLE

-- 字符函数
-- 大小写 UPPER LOWER INITCAP(首字母大写)
select ' The job id for ' || upper(LAST_NAME) || ' is ' || LOWER(JOB_ID) as "Employee details" from EMPLOYEES
SELECT EMPLOYEE_ID,LAST_NAME,DEPARTMENT_ID from EMPLOYEES where LAST_NAME = INITCAP('higgins')
--字符处理 CONCAT SUBSTR LENGTH INSTR LPAD RPAD TRIM REPLACE
-- CONCAT
SELECT  CONCAT('HELLO', 'WORLD') FROM dual
select concat('bjsxt',concat('hello','world')) from dual
-- SUBSTR
SELECT SUBSTR('helloworld', 1, 5) from dual
SELECT SUBSTR('helloworld', -1, 5) from dual
SELECT SUBSTR('helloworld', -5, 5) from dual
SELECT SUBSTR('helloworld', -5) from dual
SELECT SUBSTR('helloworld', 6) from dual
-- LENGTH
SELECT LENGTH('helloworld') from dual
-- INSTR
SELECT INSTR('helloworld', 'w') from dual
select INSTR('helloworld', 'l',1,1) from dual --(父串，子串，开始位置，出现几次)
-- LPAD
SELECT LPAD('hello', 10, '*') from dual --左侧填充
-- RPAD
SELECT RPAD('hello', 10, '*') from dual --右侧填充
-- TRIM
select TRIM('h' FROM 'helloworld') from dual
select TRIM('h' FROM 'helloworldh') from dual
select TRIM(both 'h' FROM 'helloworldh') from dual
select TRIM(leading 'h' FROM 'helloworldh') from dual --去掉头
select TRIM(trailing 'h' FROM 'helloworldh') from dual --去掉尾
-- REPLACE
select REPLACE('helloworld', 'll', 'aa') from dual
-- 练习
SELECT CONCAT(FIRST_NAME, LAST_NAME), LENGTH(LAST_NAME), INSTR(LAST_NAME, 'a') from EMPLOYEES WHERE SUBSTR(JOB_ID, 4)='REP'
SELECT CONCAT(FIRST_NAME, LAST_NAME), LENGTH(LAST_NAME), INSTR(LAST_NAME, 'a') from EMPLOYEES WHERE SUBSTR(LAST_NAME, -1) = 'n'
SELECT REPLACE('18021870033', SUBSTR('18021870033', 4, 4), '****') from dual


-- 数字函数 ROUND TRUNC MOD
--  ROUND 四舍五入保留小数位数
SELECT ROUND(45.926, 1) from dual
SELECT ROUND(45.926, -1) from dual --50
SELECT ROUND(45.926, 0) from dual --46
--  ROUND 保留小数位数
SELECT TRUNC(45.926, 2) from dual
SELECT TRUNC(45.926, 0) from dual --45
-- MOD 取余
SELECT MOD(1600, 300) from dual
-- 练习
select LAST_NAME,SALARY,MOD(SALARY, 5000) from EMPLOYEES WHERE JOB_ID = 'SA_REP'


-- 日期函数
-- SYSDATE
select SYSDATE from dual --系统当前时间
-- 日期计算
-- data +- num ？(日+-1)
select SYSDATE+1 from dual
-- data - data 天数
SELECT ROUND(SYSDATE - HIRE_DATE, 2)  from EMPLOYEES
-- data + num/24 加天数
SELECT SYSDATE + 24/24 from dual
-- 练习
select LAST_NAME, (SYSDATE-HIRE_DATE)/7 from EMPLOYEES where DEPARTMENT_ID=90
-- MONTHS_BETWEEN(date1, date2) 计算月数
select MONTHS_BETWEEN(SYSDATE, HIRE_DATE) from EMPLOYEES
-- ADD_MONTHS(date, int)
SELECT ADD_MONTHS(SYSDATE, 2) from dual
SELECT ADD_MONTHS(SYSDATE, -1) from dual
-- NEXT_DAY(date, ch) 下周周几的日期 1-星期日
select NEXT_DAY(SYSDATE,1) from dual
-- LAST_DAY(date) 日期的月的最后一天的日期
SELECT LAST_DAY(SYSDATE) from dual
-- ROUND(date, fmt) 四舍五入-上午下午
select ROUND(SYSDATE) from dual
select ROUND(SYSDATE,'yyyy') from dual --2019-01-01 00:00:00  对年做四舍五入
select ROUND(SYSDATE,'mm') from dual --2019-05-01 00:00:00  对月做四舍五入
-- TRUNC(date, fmt)
-- 练习
SELECT EMPLOYEE_ID,MONTHS_BETWEEN(SYSDATE, HIRE_DATE),ADD_MONTHS(HIRE_DATE, 6),NEXT_DAY(HIRE_DATE, 6),LAST_DAY(HIRE_DATE) from EMPLOYEES WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) < 180
SELECT ROUND(HIRE_DATE, 'mm'),TRUNC(HIRE_DATE, 'mm') from EMPLOYEES WHERE HIRE_DATE like '%02'


-- 数据类型转换
-- 隐式转换 会导致索引无效 尽量不要用隐式转换
-- VARCHAR2 --- NUMBER
SELECT EMPLOYEE_ID from EMPLOYEES WHERE EMPLOYEE_ID='206'
-- 显示转换
-- TO_CHAR(x) 日期或数字转成字符
-- 日期转字符 YYYY YEAR MM MONTH MON 星期 DY DAY 月天 DD AM PM HH HH12 HH24 MI SS SSSSS
SELECT TO_CHAR(SYSDATE,'yyyy') from dual
SELECT TO_CHAR(SYSDATE,'mon') from dual --may
SELECT TO_CHAR(SYSDATE,'day') from dual --wednesday
SELECT TO_CHAR(SYSDATE,'dd') from dual --15
SELECT TO_CHAR(SYSDATE,'am') from dual
SELECT TO_CHAR(SYSDATE,'MI') from dual
SELECT TO_CHAR(SYSDATE,'SS') from dual
SELECT TO_CHAR(SYSDATE,'HH:MI:SS am') from dual --12:22:00 pm
SELECT TO_CHAR(SYSDATE,'yyyy-mm-dd') from dual --2019-05-15
--常量
SELECT TO_CHAR(SYSDATE,'dd "of" MM') from dual --15 of 05
SELECT TO_CHAR(SYSDATE,'yyyy"年"mm"月"dd"日"') from dual --2019年05月15日
-- ddspth
SELECT TO_CHAR(SYSDATE,'ddspth') from dual --fifteenth
-- 练习
SELECT LAST_NAME, TO_CHAR(HIRE_DATE,'yyyy-mm-dd HH:MI:SS AM'),HIRE_DATE from EMPLOYEES
-- 数字转字符 9 0 L fm
SELECT TO_CHAR(346.555,'999,999.99') from dual
SELECT TO_CHAR(1231231346.555,'999,999.99') from dual --###########
SELECT TO_CHAR(346.555,'$999,999.99') from dual --$346.56
SELECT TO_CHAR(346.555,'L999,999.99') from dual --$346.56
SELECT TO_CHAR(346.555,'fm999,999.99') from dual
-- 练习
SELECT LAST_NAME, TO_CHAR(SALARY,'fmL999,999,999.00') from EMPLOYEES WHERE LAST_NAME='Whalen'
-- TO_NUMBER(expr, fmt) 必须是数字
SELECT TO_NUMBER('$456.84', '$999,999,999.99') from dual
-- TO_DATE(ch, fmt)
select TO_DATE('2019-03-09', 'yyyy-mm-dd') from dual
select TO_DATE('2019-03-09 11:57', 'yyyy-mm-dd hh:mi') from dual


-- 函数嵌套
select  TO_CHAR(NEXT_DAY(ADD_MONTHS(HIRE_DATE, 6), 6), 'day,mm,dd,yyyy') AS "Next 6 Month Review" from EMPLOYEES ORDER BY HIRE_DATE


-- 通用函数 
-- NVL(expr1, expr2) expr1 ? expr1 : expr2
select LAST_NAME, SALARY*12*NVL(COMMISSION_PCT, 1)  from EMPLOYEES
select LAST_NAME,SALARY,COMMISSION_PCT,12*SALARY+12*SALARY*NVL(COMMISSION_PCT, 0) from EMPLOYEES
-- NVL2(expr1, expr2, expr3) expr1?expr2:expr3  3个参数类型最好保持一致 而且最好显示类型转换
select NVL2(TO_CHAR(COMMISSION_PCT), 'SALCOMM', 'SAL') from EMPLOYEES
-- NULLIF(expr1, expr2)  expr1==expr2 ？ null： expr1
select LENGTH(FIRST_NAME) as expr1,LENGTH(LAST_NAME) as expr2, NULLIF(LENGTH(FIRST_NAME), LENGTH(LAST_NAME)) as resault from EMPLOYEES
-- COALESCE(expr1, ... exprn) expr1 || expr2 || expr3 || expr4
SELECT LAST_NAME, COALESCE(COMMISSION_PCT,SALARY,10) from EMPLOYEES


-- 条件表达式 IF-THEN-ELSE
-- CASE
SELECT LAST_NAME,JOB_ID,SALARY,
CASE JOB_ID
	WHEN 'IT_PROG' THEN
		SALARY * 1.1
	WHEN 'ST_CLERK' THEN
		SALARY * 1.15
	WHEN 'SA_REP' THEN
		SALARY * 1.2
END 
FROM EMPLOYEES 
-- DECODE
SELECT LAST_NAME,JOB_ID,SALARY,
DECODE(JOB_ID, 
'IT_PROG',SALARY * 1.1, 
'ST_CLERK',SALARY * 1.15, 
'SA_REP',SALARY * 1.2) 
from EMPLOYEES














