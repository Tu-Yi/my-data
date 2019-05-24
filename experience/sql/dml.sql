-- DML INSERT UPDATE DELETE

-- mysql
-- insert
INSERT INTO departments(department_name,location_id) VALUES('readyea',1)
-- 主键 自增列占位 DEFAULT null 0
insert into departments VALUES(default,"development",2) 
insert into departments VALUES(null,"development1",3) 
insert into departments VALUES(0,"teaching",4) 
-- 默认值
CREATE TABLE emp3(emp_id int PRIMARY KEY auto_increment, name VARCHAR(30), address VARCHAR(50) DEFAULT "unknown")
alter table emp3 add COLUMN job_id int DEFAULT 0
INSERT INTO emp3(name) VALUES("admin")
insert into emp3 values(DEFAULT,"lu1",DEFAULT,DEFAULT)
-- updata
update emp3 set address = "cd" where emp_id=1
update emp3 e,(select address from emp3 where emp_id=1) t set e.address=t.address  where e.emp_id=2
update emp3 e set e.address = (select t1.address from (select emp_id, address from emp3) t1 where t1.emp_id=1)  where e.emp_id=2
-- delete
DELETE from emp3 where emp_id=1
TRUNCATE table emp3  --自增列会从1开始

-- 事务
START TRANSACTION
insert into emp3 values(DEFAULT,"lu2",DEFAULT,DEFAULT)
COMMIT



-- oracle
-- INSERT
INSERT INTO DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) VALUES(280,'teaching',180,2000)
INSERT INTO DEPARTMENTS VALUES(290,'readyea',149,2000) 
INSERT into DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) VALUES(310,'B',null,null)
insert into 
EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
VALUES(300,'Old','Lu','123@123.com','13690890987',SYSDATE,'AD_PRES',23432,null,149,290)
-- oracle默认日期格式 01/may/2019
insert into 
EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
VALUES(301,'Old','Lu','1231@123.com','13690890987','01/may/2019','AD_PRES',23432,null,149,290)
insert into 
EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
VALUES(302,'Old','Lu','12311@123.com','13690890987',TO_DATE('2019-03-01', 'yyyy-mm-dd'),'AD_PRES',23432,null,149,290)
-- 从另一个表复制行
INSERT INTO EMP(ID,NAME,SALARY,COMMISSION) SELECT EMPLOYEE_ID,LAST_NAME,SALARY,COMMISSION_PCT FROM EMPLOYEES where JOB_ID like '%REP%'
INSERT INTO EMP SELECT EMPLOYEE_ID,LAST_NAME,SALARY,COMMISSION_PCT FROM EMPLOYEES where JOB_ID like '%IT%'
-- 默认值
INSERT INTO EMP(ID,NAME,SALARY,COMMISSION) VALUES(300,'olblu',DEFAULT,NULL)  --自动默认值
INSERT INTO EMP(ID,NAME) VALUES(302,'kevin')  --自动默认值

-- UPDATE
UPDATE EMP set name='olblu', SALARY=20000  where id=170
-- 更新=查询结果
update emp e set e.SALARY = (select SALARY from emp WHERE id=156) where e.id=165

-- DELETE
delete from emp where id=302
delete from emp where SALARY in (select DISTINCT SALARY from EMPLOYEES where JOB_ID='IT_PROG')
delete emp;
select * from EMPLOYEES 

select * from EMP where id=302

autocommit oFF

-- TCL 事务 commit rollback savepoint

INSERT INTO EMP(ID,NAME,SALARY,COMMISSION) VALUES(301,'olblu',DEFAULT,NULL)












