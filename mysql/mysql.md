# mysql

## mysql常见数据类型

```
<1>整数型
类型      大小      范围（有符号）               范围（无符号unsigned）    用途
TINYINT   1 字节    (-128，127)                (0，255)                 小整数值
SMALLINT  2 字节    (-32768，32767)            (0，65535)               大整数值
MEDIUMINT 3 字节    (-8388608，8388607)        (0，16777215)            大整数值
INT       4 字节    (-2147483648，2147483647)  (0，4294967295)          大整数值
BIGINT    8 字节     （）                       (0，2的64次方减1)        极大整数值

<2>浮点型
 FLOAT(m,d）  4 字节    单精度浮点型  备注：m代表总个数，d代表小数位个数
 DOUBLE(m,d） 8 字节    双精度浮点型  备注：m代表总个数，d代表小数位个数
 
 <3>定点型
 DECIMAL(m,d）    依赖于M和D的值    备注：m代表总个数，d代表小数位个数
 
 <4>字符串类型 
 类型          大小              用途
 CHAR          0-255字节         定长字符串
 VARCHAR       0-65535字节       变长字符串
 TINYTEXT      0-255字节         短文本字符串
 TEXT          0-65535字节       长文本数据
 MEDIUMTEXT    0-16777215字节    中等长度文本数据
 LONGTEXT      0-4294967295字节  极大文本数据
 
 char的优缺点：存取速度比varchar更快，但是比varchar更占用空间
 varchar的优缺点：比char省空间。但是存取速度没有char快
 
 <5>时间型
 数据类型    字节数            格式                    备注
 date        3                yyyy-MM-dd              存储日期值
 time        3                HH:mm:ss                存储时分秒
 year        1                yyyy                    存储年
 datetime    8                yyyy-MM-dd HH:mm:ss     存储日期+时间
 timestamp   4                yyyy-MM-dd HH:mm:ss     存储日期+时间，可作时间戳
```

## 创建表的约束

```
comment         ----说明解释
not null        ----不为空
default         ----默认值
unsigned        ----无符号（即正数）
auto_increment  ----自增
zerofill        ----自动填充
unique key      ----唯一值
```

## 字符集

- character_set_client：客户端请求数据的字符集
- character_set_connection：客户端与服务器连接的字符集
- character_set_database：数据库服务器中某个库使用的字符集设定，如果建库时没有指明，将默认使用配置上的字符集
- character_set_results：返回给客户端的字符集(从数据库读取到的数据是什么编码的)
- character_set_server：为服务器安装时指定的默认字符集设定。
- character_set_system：系统字符集(修改不了的，就是utf8)
- character_sets_dir：mysql字符集文件的保存路径

 永久：修改配置文件my.cnf里边的 

```
[client]
default-character-set=gbk
作用于外部的显示

[mysqld]
character_set_server=gbk
作用于内部，会作用于创建库表时默认字符集
```

- 修改库的字符集编码

  ```
  alter database xiaoxiao default character set gbk;
  ```

- 修改表的字符集编码

  ```
  alter table employee default character set utf8;
  ```

## 事务

- 事务的特性（ACID）：
- 原子性(Atomicity)：事务必须是原子工作单元，一个事务中的所有语句，应该做到：要么全做，要么一个都不做；
- 一致性(Consistency):让数据保持逻辑上的“合理性”，比如：小明给小红打10000块钱，既要让小明的账户减少10000，又要让小红的账户上增加10000块钱；
- 隔离性(Isolation)：如果多个事务同时并发执行，但每个事务就像各自独立执行一样。
- 持久性(Durability)：一个事务执行成功，则对数据来说应该是一个明确的硬盘数据更改（而不仅仅是内存中的变化）。
- 你要使用事务的话，表的引擎要为innodb引擎

- 事务的开启与提交：
- 事务的开启：begin; start transaction;
- 事务的提交：commit;
- 事务的回滚：rollback;

```
创建一个账户表模拟转账
create table account (
                         id tinyint(5) zerofill auto_increment  not null comment 'id编号',
                         name varchar(20) default null comment '客户姓名',
                         money decimal(10,2) not null comment '账户金额',
                         primary key (id)
                         )engine=innodb charset=utf8;
```

- 开启autocommit（临时生效）：

  OFF（0）：表示关闭 ON （1）：表示开启

  ```
    mysql> set autocommit=0;
  ```

  ```
    Query OK, 0 rows affected (0.00 sec)
  ```

  ```
    
  ```

  ```
    mysql> show variables like 'autocommit';
  ```

  ```
    +---------------+-------+
  ```

  ```
    | Variable_name | Value |
  ```

  ```
    +---------------+-------+
  ```

  ```
    | autocommit    | OFF   |
  ```

  ```
    +---------------+-------+
  ```

  ```
    mysql> set autocommit=1;
  ```

  ```
    Query OK, 0 rows affected (0.00 sec)
  ```

  ```
    mysql> 
  ```

  ```
    mysql> show variables like 'autocommit';
  ```

  ```
    +---------------+-------+
  ```

  ```
    | Variable_name | Value |
  ```

  ```
    +---------------+-------+
  ```

  ```
    | autocommit    | ON    |
  ```

- 开启autocommit（永久生效）：

  修改配置文件：vi /etc/my.cnf 在[mysqld]下面加上：autocommit=1 记得重启服务才会生效

## 视图

```
视图（view）是一种虚拟存在的表，是一个逻辑表，它本身是不包含数据的。作为一个select语句保存在数据字典中的。
通过视图，可以展现基表（用来创建视图的表叫做基表base table）的部分数据，说白了视图的数据就是来自于基表
```

- 视图的优点是：

```
1）简单：使用视图的用户完全不需要关心后面对应的表的结构、关联条件和筛选条件，对用户来说已经是过滤好的复合条件的结果集。

2）安全：使用视图的用户只能访问他们被允许查询的结果集，对表的权限管理并不能限制到某个行某个列，但是通过视图就可以简单的实现。

3）数据独立：一旦视图的结构确定了，可以屏蔽表结构变化对用户的影响，源表增加列对视图没有影响;源表修改列名，则可以通过修改视图来解决，不会造成对访问者的影响。
　　
4）不占用空间：视图是逻辑上的表，不占用内存空间

总而言之，使用视图的大部分情况是为了保障数据安全性，提高查询效率。
```

- 视图的创建以及修改

```
创建的基本语法是：
    create view <视图名称> as select 语句;
    create view <视图名称> (字段) as select 语句;
    create or replace view <视图名称>;
修改的语法是：
alter view <视图名称> as select 语句;
视图删除语法：
drop view <视图名称> ;
```

- 视图的缺点

```
 1)性能差：sql server必须把视图查询转化成对基本表的查询，如果这个视图是由一个复杂的多表查询所定义，那么，即使是视图的一个简单查询，sql server也要把它变成一个复杂的结合体，需要花费一定的时间。
 
 2)修改限制：当用户试图修改试图的某些信息时，数据库必须把它转化为对基本表的某些信息的修改，对于简单的试图来说，这是很方便的，但是，对于比较复杂的试图，可能是不可修改的。
```

## 触发器

触发器就是监视某种情况，并触发某种操作

- 创建触发器的语法:

```
create trigger 触发器名称  after/before   insert/update/delete on 表名  
        for each row
        begin
        sql语句;
        end
            
after/before:可以设置为事件发生前或后
insert/update/delete:它们可以在执行insert、update或delete的过程中触发
for each row:每隔一行执行一次动作
```

- 删除触发器的语法：

  ```
  drop trigger 触发器名称;
  ```

- 演示：

```
创建一个员工迟到表：
 create table work_time_delay(
            empno int not null comment '雇员编号',
            ename varchar(50) comment '雇员姓名',
            status int comment '状态'
            );
delimiter // 自定义语句的结束符号

    mysql> delimiter //
    mysql> 
    mysql> create trigger trig_work after insert on work_time_delay
        -> for each row
        -> begin
        -> update employee set sal=sal-100 where empno=new.empno;
        -> end
        -> //
    Query OK, 0 rows affected (0.01 sec)

new：指的是事件发生before或者after保存的新数据
```

## 存储过程

```
存储过程就是把复杂的一系列操作，封装成一个过程。类似于shell，python脚本等。
```

- 存储过程的优缺点

```
    优点是：
        1)复杂操作，调用简单
        2)速度快
        
    缺点是：
        1）封装复杂
        2) 没有灵活性
```

- 创建存储过程语法：

```
create procedure 名称 (参数....)
        begin
         过程体;
         过程体;
         end
参数：in|out|inout 参数名称 类型（长度）
        in：表示调用者向过程传入值（传入值可以是字面量或变量）
        out：表示过程向调用者传出值(可以返回多个值)（传出值只能是变量）
        inout：既表示调用者向过程传入值，又表示过程向调用者传出值（值只能是变量）
```

- 声明变量：declare 变量名 类型(长度) default 默认值;

- 给变量赋值：set @变量名=值;

- 调用存储命令：call 名称(@变量名);
- 删除存储过程命令：drop procedure 名称;
- 查看创建的存储过程命令：

```
show create procedure 名称\G;
创建一个简单的存储过程：
    mysql> delimiter //
    mysql> create procedure  name(in n int)
        ->             begin
        ->             select * from employee limit n;
        ->             end
        -> //
    Query OK, 0 rows affected (0.00 sec)

    mysql> set @n=5;
        -> //
    Query OK, 0 rows affected (0.00 sec)

    mysql> 
    mysql> call name(@n);
  mysql>         create procedure  name()
        ->             begin
        ->             declare  n int default 6;
        ->             select * from employee limit n;
        ->             end
        -> //
    Query OK, 0 rows affected (0.00 sec)

    mysql> call name();

```

## 存储引擎

（1）什么是数据库存储引擎？

```
数据库引擎是数据库底层软件组件，不同的存储引擎提供不同的存储机制，索引技巧，锁定水平等功能，使用不同的数据库引擎，可以获得特定的功能
```

（2）如何查看引擎？

```
如何查看数据库支持的引擎
show engines;

查看当前数据的引擎：
show create table 表名\G

查看当前库所有表的引擎：
show table status\G
```

（3）建表时指定引擎

```
create table yingqin (id int,name varchar(20)) engine='InnoDB';
```

（4）修改表的引擎

```
alter table 表名 engine='MyiSAm';

修改默认引擎
•    vi /etc/my.cnf
•    [mysqld]下面
•    default-storage-engine=MyIsAM
•    记得保存后重启服务
```

（5）MyISAM与InnoDB的区别

```
MyISAM：支持全文索引（full text）;不支持事务;表级锁;保存表的具体行数;奔溃恢复不好

Innodb：支持事务;以前的版本是不支持全文索引，但在5.6之后的版本就开始支持这个功能了;行级锁（并非绝对，当执行sql语句时不能确定范围时，也会进行锁全表例如： update table set id=3 where name like 'a%';）;不保存表的具体行数;奔溃恢复好
```

（6）总结：什么时候选择什么引擎比较好

```
MyISAM：
•    一般来说MyISAM不需要用到事务的时候
•    做很多count计算

InnoDB：
•    可靠性要求高的，或者要求支持事务
•    想要用到外键约束的时候（讲外键的时候会讲）

推荐：
•    推荐用InnoDB
```

## 索引

### 普通，唯一

- 什么是普通索引？

```
普通索引（index）顾名思义就是各类索引中最为普通的索引，主要任务就是提高查询速度。其特点是允许出现相同的索引内容，允许空（null）值
```

- 什么是唯一索引？

```
唯一索引：（unique）顾名思义就是不可以出现相同的索引内容，但是可以为空（null）值
```

- 如何创建普通索引或者唯一索引？

  - 创建表的时候创建

    ```
    create table test (
    ```

    ```
                            id int(7) zerofill auto_increment not null,
    ```

    ```
                            username varchar(20),
    ```

    ```
                            servnumber varchar(30),
    ```

    ```
                            password varchar(20),
    ```

    ```
                            createtime datetime,
    ```

    ```
                            unique (id)
    ```

    ```
                      )DEFAULT CHARSET=utf8;
    ```

  - 直接为表添加索引

    ```
    语法：
    ```

    ```
         alter table 表名 add index 索引名称 (字段名称);
    ```

    ```
     eg: 
    ```

    ```
         alter table test add unique unique_username (username);
    ```

    ```
    
    ```

    ```
    注意：假如没有指定索引名称时，会以默认的字段名为索引名称
    ```

  - 直接创建索引

    ```
    语法：create index 索引 on 表名 (字段名);
    ```

    ```
    eg：create index index_createtime on test (createtime);
    ```

- 查看索引

  ```
  语法：show index from 表名\G
  ```

  ```
  eg: show index from test\G
  ```

- 如何删除索引

```
语法：drop index 索引名称 on 表名;
eg：drop index unique_username on test;
语法：alter table 表名 drop index 索引名;
eg：alter table test drop index createtime;
```

### 主键

- 什么是主键索引？

```
把主键添加索引就是主键索引，它是一种特殊的唯一索引，不允许有空值，而唯一索引（unique是允许为空值的）。指定为“PRIMARY KEY”
主键：主键是表的某一列，这一列的值是用来标志表中的每一行数据的。
注意：每一张表只能拥有一个主键
```

- 创建主键：

  ```
  1）创建表的时候创建
  ```

  ```
  
  ```

  ```
  2）直接为表添加主键索引
  ```

  ```
     语法：alter table 表名 add primary key (字段名);
  ```

  ```
     eg：alter table test add primary key (id);
  ```

- 删除主键：

```
语法：
alter table 表名 drop primary key;
eg： 
alter table test drop primary key;

注意：在有自增的情况下，必须先删除自增，才可以删除主键

删除自增：alter table test change id id int(7) unsigned zerofill not null;
```

## 全文索引

以词为单位

- 什么是全文索引？

  ```
  全文索引是将存储在数据库中的文章或者句子等任意内容信息查找出来的索引，单位是词。全文索引也是目前搜索引擎使用的一种关键技术。指定为 fulltex
  ```

- 创建练习表的sql：

  ```
  create table command (
  ```

  ```
  id int(5) unsigned primary key  auto_increment,
  ```

  ```
  name varchar(10),
  ```

  ```
  instruction varchar(60)
  ```

  ```
  )engine=MyISAM;
  ```

- 插入数据sql：

  ```
  insert into command values('1','ls','list directory contents');
  ```

  ```
  insert into command values('2','wc','print newline, word, and byte counts for each file');
  ```

  ```
  insert into command values('3','cut','remove sections from each line of files');
  ```

  ```
  insert into command values('4','sort','sort lines of text files');
  ```

  ```
  insert into command values('5','find','search for files in a directory hierarchy');
  ```

  ```
  insert into command values('6','cp','复制文件或者文件夹');
  ```

  ```
  insert into command values('7','top','display Linux processes');
  ```

  ```
  insert into command values('8','mv','修改文件名，移动');
  ```

  ```
  insert into command values('9','停止词','is,not,me,yes,no ...');
  ```

- 添加全文索引：

  - 创建表的时候创建全文索引

  - 通过alter添加

    ```
    alter table command  add fulltext(instruction);
    ```

- 使用全文索引：

  ```
  select * from 表名 where match  (字段名) against ('检索内容');
  select * from command where match(instruction) against ('sections');
  ```

- 查看匹配度：

  ```
  select * from command where match(instruction) against ('directory');
  ```

- 停止词：

  ```
  出现频率很高的词，将会使全文索引失效
  ```

- in boolean mode 模式：

  ```
  in boolean mode：意思是指定全文检索模式为布尔全文检索（简单可以理解为是检索方式）
  select * from 表名 where match (字段名) against ('检索内容' in boolean mode);
  ```

- 注意点：

  ```
  使用通配符*时，只能放在词的后边，不能放前边。
  ```

- 删除全文索引：

  ```
  alter table command drop index instruction;
  ```

- 注意点总结：

  ```
      1、一般情况下创建全文索引的字段数据类型为 char、varchar、text 。其它字段类型不可以
  ```

  ```
  
  ```

  ```
  •   2、全文索引不针对非常频繁的词做索引。比如is，no，not，you，me，yes这些，我们称之为停止词
  ```

  ```
  
  ```

  ```
  •   3、对英文检索时忽略大小写
  ```