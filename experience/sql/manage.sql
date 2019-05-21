-- dcl

-- 用户
create user test IDENTIFIED by q1q1q1 
create user u_niliv identified by oracle default tablespace niliv temporary tablespace temp;
drop user test cascaed;
-- 授权
GRANT CREATE SESSION to u_niliv --登录权限
grant create table ,create view ,create sequence ,unlimited tablespace to u_niliv;  --无限制使用表空间 unlimited tablespace
revoke create table from u_niliv
-- 角色
create role manager
grant create session,create table,create view,create sequence to manager
grant manager to u_niliv
revoke manager from u_niliv

