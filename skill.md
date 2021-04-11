# 技巧

## 链接

[mysql开发规范](https://www.studytime.xin/php/2019/01/02/Mysql-specification.html)

[表分区详解](https://www.jianshu.com/p/1cdd3e3c5b3c)

[mysql影响性能的因素](https://blog.csdn.net/Kangshuo2471781030/article/details/79315577)

[mysql优化知乎](https://www.zhihu.com/question/19719997)

[mysql字符集](https://my.oschina.net/xsh1208/blog/1052781)

[mysql-java字段对应](https://www.cnblogs.com/jembai/archive/2009/08/20/1550683.html)

## 规范

### 数据库设计规范

所有数据库对象名称必须使用小写字母并用下划线分割

所有数据库对象名称禁止使用mysql保留关键字

数据库对象命名要见名知义，不要超过32个字符

临时表必须以tmp为前缀，日期为后缀

备份库表必须以bak为前缀，日期为后缀

所有存储相同数据的列名和列类型必须一致

所有表和字段都要添加注释

所有表必须使用Innodb存储引擎

数据库和表的字符集统一使用UTF8

尽量控制单表数据量控制在500W以内

谨慎使用MySql分区表，避免跨分区查询，建议采用物理分表方式管理大数据

尽量做到冷热数据分离，减小表的宽度，减少IO，保证热数据内存缓存命中率，经常一起使用的列放到一个表中

禁止在表中建立预留无用字段

禁止存储图片，文件等二进制数据

禁止在线上做数据库压力测试

禁止从开发环境、测试环境直连生产环境数据库

 建议普通表使用utf8， 如果这个表需要支持emoji就使用utf8mb4

新建数据 库时排序规则一般选用utf8_general_ci就可以了

### 索引设计规范

限制索引数量，单张表索引不超过5个，索引会降低插入和更新的效率

每个Innodb表必须有一个主键，使用自增ID，不使用更新频繁、多列、UUID、MD5、HASH、字符串作为主键

建立索引的列：WHERE从句中的列、ORDER BY/GROUP BY/DISTINCT中的字段、夺标JOIN的关联列

联合索引：区分度最大的放在联合索引最左侧、字段长度小的放在最左侧、使用最频繁的列放在最左侧

使用多列索引时主意顺序和查询条件保持一致，同时删除不必要的单列索引

避免建立冗余和重复的索引 `index(a,b,c) index(a,b) index(a)`

对于频繁查询优先考虑使用覆盖索引，减少二次查找

尽量避免使用外键，会影响写操作降低性能，建议在业务端实现

MyySql只对以下操作符才使用索引 `< <= = > >= between in *%`

避免在WHERE子句中对字段进行NULL值判断，否则将导致引擎放弃使用索引而进行全表扫描

值分布很稀少的字段不适合建索引，例如"性别"这种只有两三个值的字段

尽量不用UNIQUE，由程序保证约束

### 字段设计规范

- 优先选择符合存储需要最小的数据类型

  - 将字符串转为数字类型 

    `INET_ATON('255.255.255.255')=4294967295`  `INET_NTOA(4294967295`)='255.255.255.255'`

  - 对于非负型的数据来说，优先使用无符号整型来存储 `UNSING INT 0-4294967295`

  - 尽量使用INT而非BIGINT，如果非负则加上UNSIGNED（这样数值容量会扩大一倍），当然能使用TINYINT、SMALLINT、MEDIUM_INT更好

  - VARCHAR(N)的N代表字符数，不是字节数，N个汉字

  - 使用UTF8存储汉字varchar(255)=765字节

  - 过大的长度会消耗更多的内存

- 尽量避免使用TEXT、BLOB数据类型，一定要使用，分离到单独表中

- 避免使用ENUM数据类型，禁止使用数值作为ENUM的枚举值

- 尽可能把所有列定义为NOT NULL，NULL值会增大空间，推荐默认数字0代替null

- 使用TIMESTAMP或DATETIME类型存储时间，会超出2038年的时间用DATETIME

- 同财务相关的金额类数据，必须使用decimal类型，计算时不丢失精度，可以保存很大的数据

- 单表不要有太多字段，建议在20以内

- 字符字段最好不要做主键

- char固定长度  varchar可变长度 前者效率高

### SQL规范

建议预编译语句进行数据库操作

避免数据类型的隐式转换，会导致索引失效 `where id =='111'

使用同类型进行比较，比如用'123'和'123'比，123和123比

避免使用 `a like '%123%'` `a like '%123'`，后置百分号可以利用到索引

联合索引中的某一列经常会有范围查找，要放到最右侧

使用left join或not exists来优化not in 操作

程序连接不同的数据库使用不同的账号，禁止垮裤查询

禁止使用 `select *`

禁止使用不含字段列表的insert语句，必须要带字段名 `insert into user(a,b,c) values(1,2,3)`

避免使用子查询，可以把子查询优化为join，子查询无法使用索引，还会使用临时表

避免使用JOIN关联太多的表，每join一个表就多一部分内存，会产生临时表，建议不超过5个

减少同数据库的交互次数，数据库更适合批量操作，提高效率，主要针对查询操作

尽量不要使用 or

使用 in 代替 or，in可以利用到索引，in的个数建议控制在200以内

禁止使用`order by rand()`进行随机排序，推荐程序中随机值，再获取数据

WHERE中禁止对列进行函数转换和计算，无法使用到索引

在明显不会有重复值时使用UNION ALL 而不是UNION，因为UNION会有去重操作

拆分复杂的大SQL为多个小SQL，并行执行提高效率

可通过开启慢查询日志来找出较慢的SQL

不用函数和触发器，在应用程序实现

尽量避免在WHERE子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描

对于连续数值，使用BETWEEN不用IN：`SELECT id FROM t WHERE num BETWEEN 1 AND 5`

### 数据库操作行为规范

超过100W数据批量写操作，要分批多次进行操作，针对写操作，会造成主从延迟，避免大事务操作

对于大表使用 pt-online-schema-change修改表结构，否则会锁表，会主从延迟

禁止为程序使用的账号赋予super权限

对于程序连接数据库账号，遵循权限最小原则，程序账号不准有drop权限，程序使用账号不能跨库

### 第三范式

不存在函数的传递依赖关系，比如用户积分->用户等级->用户名

尽量做到冷热分离，减小表的宽度

## 分区表

**分区表的键必须包含在主键范围内**

https://www.iteye.com/blog/like-eagle-689030

**分区表的索引**

https://www.cnblogs.com/duanxz/p/6519187.html



1. MySQL分区中如果存在主键或唯一键，则分区列必须包含在其中。
2. 对于原生的RANGE分区，LIST分区，HASH分区，分区对象返回的只能是整数值。
3. 分区字段不能为NULL，要不然怎么确定分区范围呢，所以尽量NOT NULL



`show plugins;` 查看是否支持分区

逻辑上是一个表，物理上存储在多个文件中

### HASH分区

根据取模的值把数据存储到不同的分区中

数据可以平均的分布在各个分区中

HASH分区的键值必须是INT类型或是通过函数可以转为INT的值

`PARTITION BY HASH(customer_id)  PARTITIONS 4`

函数

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-14-27.png)

### RANGE分区

根据键值的范围把数据存储在不同的分区中

多个分区范围要连续，不能重叠

默认情况下使用 `VALUES LESS THAN`属性，即每个分区不包括最大值

适用于日期或是时间类型

查询中都要包括分区键，避免跨分区扫描

适合定期清理历史数据的情况下

`PARTITION BY RANGE(customer_id)`

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-19-18.png)

### List分区

按分区键取值的列表进行分区

列表值不能重复

每一行数据必须能找到对应的分区列表，否则数据插入失败

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-22-51.png)

### 实践

建立分区

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-42-29.png)

增加新的分区

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-43-47.png)

删除分区

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-44-25.png)

分区归档，归档后还要删除分区，归档表只读不能写

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-46-00.png)

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_10-44-25.png)

避免跨分区查询

WHERE从句中包含分区键

具有主键或唯一索引的表，主键或唯一索引必须是分区键的一部分

分区表适合建立在myslam引擎上

## 执行计划（EXPLAIN）

### 参数解释

id：select的顺序

select_type

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-08-13.png)

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-08-45.png)



table：表的别名

PARTITIONS：显示分区ID，非分区表显示为NULL

TYPE

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-12-14.png)



Extra

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-14-10.png)

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-14-44.png)



POSSIBLE_KEY：指出mysql使用哪些索引来优化查询

KEY：实际所使用的索引，没有索引，显示为NULL，覆盖索引只显示在KEY中

KEY_Len：表示索引字段最大可能长度

Rows：读取的行数，统计抽样结果，不十分准群

Filtered：表示返回结果的行数占需读取行数的百分比，越大越好，也是抽样

无法对存储过程分析

### 优化分页查询

**索引**

对where中的列做联合索引，区分度越接近1越好，放在左边

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-21-10.png)



**改写**

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_11-25-18.png)

## 慢查询日志

![](https://niliv-technology-1252830662.cos.ap-chengdu.myqcloud.com/sql/Snipaste_2019-10-18_12-10-27.png)



## 备份

**定时备份**

https://www.cnblogs.com/letcafe/p/mysqlautodump.html

**定时备份上传到七牛云**

https://shockerli.net/post/mysqldump-put-qiniu/

**全量备份 增量备份 定时备份 docker**

https://juejin.im/entry/5b8f53876fb9a05d2c4384a8

## 主从复制

 https://juejin.im/post/5b0f91ab518825153749b1db 

## 问题集锦

**mysql 初始化 timestamp，提示 Invalid default value for 'xxx'**

https://blog.csdn.net/cuiaamay/article/details/53896623

**存储url的类型**

https://oomake.com/question/373990

**timestamp当前时间**

https://www.itread01.com/content/1548699307.html

**decimal**

decimal(5,2)5是定点精度，2是小数位数。decimal(a,b)a指定指定小数点左边和右边可以存储的十进制数字的最大个数，最大精度38。b指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 a之间的值。默认小数位数是 0

**替代模糊查询的方法**

 https://blog.csdn.net/zuihongyan518/article/details/81131042 





















