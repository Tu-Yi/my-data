-- DDL
-- TABLE
CREATE TABLE dept(deptno NUMBER(2),dname VARCHAR2(14),loc VARCHAR2(14))
CREATE TABLE readyea as select EMPLOYEE_ID,LAST_NAME,SALARY from EMPLOYEES where DEPARTMENT_ID=80
alter table dept add(SALARY NUMBER(8,2));
alter table dept MODIFY(DNAME,VARCHAR2(40))
alter table dept MODIFY(SALARY NUMBER(8,2) DEFAULT 1000);
alter table dept MODIFY(SALARY NUMBER(8,2) DEFAULT NULL);
alter table dept rename COLUMN dname to name
alter table dept DROP COLUMN salary;
rename dept to dept1;
truncate table dept;  --删除所有数据保留表，截断表时不能给条件,截断表隐式事务
drop table readyea;  --隐式事务

-- 约束 not NULL UNIQUE primary key  foreign key check
-- NOT NULL
create table dept80(id number,name varchar2(20) not null, salary number constraint dept80_notn not null);
alter table dept80 add(location_id NUMBER)
alter table dept80 MODIFY location_id not null
-- UNIQUE
create table dept90(id number UNIQUE,name varchar2(20) not null, salary number constraint dept90_salary_u UNIQUE);
alter table dept90 MODIFY(name UNIQUE)
-- primary key
create table dept70(id number constraint dept70_pk primary key);
alter table dept60 modify(id constraint dept60_pk primary key);
create table dept50(id NUMBER, name VARCHAR2(20), constraint dept_50_pk  primary key(id,name))
-- foreign key
create table dept40(id NUMBER, d_id NUMBER, constraint dept40_fk foreign key(d_id) references dept70(id)) --不能用于复合主键
alter table dept50 add(d_id NUMBER)
ALTER TABLE dept50 add constraint dept50_fk foreign key(d_id) references dept70(id)
-- CHECK
create table dept30(id NUMBER,salary NUMBER(8,2) constraint dept30_ck CHECK(salary>1000))
alter table dept50 add(salary number(8,2))
alter table dept50 add constraint dept50_ck CHECK(salary>1000) 
-- 启用禁用约束
select constraint_name,constraint_type,search_condition from user_constraints where table_name = 'DEPT40';
alter TABLE dept40 disable constraint dept40_fk
alter TABLE dept70 disable constraint dept70_pk cascade;  --有外键参照这个，需要加cascade才能禁用
alter table dept70 enable constraint dept70_pk


-- VIEW
CREATE VIEW emp50 as select EMPLOYEE_ID id_number,LAST_NAME name,12*SALARY annsalary  from EMPLOYEES where DEPARTMENT_ID=50
select id_number,annsalary from EMP50
-- 函数必须有别名
CREATE VIEW dept_name as 
select d.DEPARTMENT_NAME,min(e.SALARY) min,AVG(e.salary) avg from EMPLOYEES e INNER JOIN DEPARTMENTS d on e.DEPARTMENT_ID = d.DEPARTMENT_ID GROUP BY d.DEPARTMENT_NAME
-- 指定别名
CREATE VIEW dept_name1(name,min,avg) as 
select d.DEPARTMENT_NAME,min(e.SALARY) min,AVG(e.salary) avg from EMPLOYEES e INNER JOIN DEPARTMENTS d on e.DEPARTMENT_ID = d.DEPARTMENT_ID GROUP BY d.DEPARTMENT_NAME
-- 删除数据就是删除表中数据
delete from emp80 e where e.employee_id=190
-- 禁止视图修改
CREATE VIEW emptest as SELECT * from EMPLOYEES with read only
DROP VIEW test
-- 内建视图
SELECT e.LAST_NAME,e.salary,e.DEPARTMENT_ID,ee.ess from EMPLOYEES e, (select DEPARTMENT_ID, max(salary) ess from EMPLOYEES GROUP BY DEPARTMENT_ID) ee where e.DEPARTMENT_ID = ee.DEPARTMENT_ID and e.salary < ee.ess

-- topN  ROWNUM跟着where走
select ROWNUM,LAST_NAME,SALARY from (select  ROWNUM , LAST_NAME,salary from EMPLOYEES ORDER BY SALARY desc) where ROWNUM<=3
select ROWNUM,LAST_NAME,HIRE_DATE from (select LAST_NAME, HIRE_DATE from EMPLOYEES order by HIRE_DATE) where ROWNUM<=3
-- topN只能小于，不能取大于，放到子查询里就可以了
select ROWNUM as rown, e.rn,e.* from (select ROWNUM as rn，ee.* from EMPLOYEES ee ORDER BY SALARY) e where ROWNUM BETWEEN 11 and 20
-- 分页 排序查询
SELECT * FROM   
(  
SELECT A.*, ROWNUM RN   
FROM (SELECT * FROM EMPLOYEES ORDER BY SALARY) A   
WHERE ROWNUM <= 40  
)  
WHERE RN >= 21


-- 序列
create sequence dept_seq INCREMENT by 10 start WITH 120 maxvalue 9999 nocache nocycle
select * from user_sequences
select dept_seq.nextval from dual;
select dept_seq.currval from dual;
alter sequence dept_seq INCREMENT by 10 start WITH 120 maxvalue 9999 nocache nocycle
drop sequence dept_seq
INSERT INTO DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME,LOCATION_ID) VALUES(dept_seq.nextval,'support',2500)
-- 创建自增列 https://www.cnblogs.com/0201zcr/p/4681780.html


-- 索引
-- 使用索引
-- 一个列包含大范围的值 
-- 一个列包含很多空值
-- 列经常在where或链接条件中
-- 表很大，但取回数据少于2%-4%的
-- 不使用索引
-- 表很小
-- 不经常作为条件的列
-- 表经常被更新
-- 经常取回数据大于4%
-- 被索引的列作为表达式的一部分不索引  运算，比较等
create INDEX emp_index on EMPLOYEES(LAST_NAME)
CREATE INDEX dept_man_loc on DEPARTMENTS(MANAGER_ID,location_id)  
SELECT * from DEPARTMENTS where MANAGER_ID=1 and LOCATION_ID=1000 -- 查询的时候MANAGER_ID要在前面
create index dept_upper on DEPARTMENTS(UPPER(DEPARTMENT_NAME))
select * from DEPARTMENTS where UPPER((DEPARTMENT_NAME)) =''
-- 对一张表来说,如果有一个复合索引 on (col1,col2),就没有必要同时建立一个单索引 on col1;
-- 如果查询条件需要,可以在已有单索引 on col1的情况下,添加复合索引on (col1,col2),对于效率有一定的提高


-- 同义词
create synonym em for EMPLOYEES
drop synonym em
