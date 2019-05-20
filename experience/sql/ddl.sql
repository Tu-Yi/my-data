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


