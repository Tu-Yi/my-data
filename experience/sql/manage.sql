-- dcl
-- mysql
create user u_sxt IDENTIFIED by 'sxt'
select user,host from mysql.user
-- 授权
grant select ON test.employees to 'u_sxt'@'%' IDENTIFIED by 'sxt'
FLUSH PRIVILEGES -- 刷新权限
drop user 'u_sxt'@'%'
-- 执行计划
EXPLAIN SELECT * from employees WHERE employee_id=100
-- 存储引擎  INNODB MyISAM查询效率快
show ENGINES
show create table employees;
ALTER TBALE tableName engine=InnoDB

-- oracle
-- 用户
create user test IDENTIFIED by q1q1q1 
create user u_niliv identified by oracle default tablespace niliv temporary tablespace temp;
drop user test cascaed;
-- 授权
GRANT CREATE SESSION to u_niliv -- 登录权限
grant create table ,create view ,create sequence ,unlimited tablespace to u_niliv;  -- 无限制使用表空间 unlimited tablespace
revoke create table from u_niliv
-- 角色
create role manager
grant create session,create table,create view,create sequence to manager
grant manager to u_niliv
revoke manager from u_niliv

