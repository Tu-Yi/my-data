# XML

## XML  的基本语法

- 有且只有一个根元素
-  XML 文档声明必须放在文档的第一行
- 所有标签必须成对出现
- XML 的标签严格区分大小写
- XML 必须正确嵌套
- XML 中的属性值必须加引号
- XML 中，一些特殊字符需要使用“实体”
- XML 中可以应用适当的注释



## XML  命名规则

- 名称可以包含字母、数字及其他字符
- 名称不能以数字或者标点符号开始
- 名称不能以字母 xml 开始
- 名称不能包含空格



## Schema

[XmlSchema标准参考手册](code/XmlSchema标准参考手册.chm)

验证xml是否有效

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--  <!DOCTYPE books [
	<!ELEMENT books (book*)>
	<!ELEMENT book (name,author,price)>
	<!ELEMENT name (#PCDATA)>
	<!ELEMENT author (#PCDATA)>
	<!ELEMENT price (#PCDATA)>
	<!ATTLIST book id CDATA #REQUIRED>
]>-->
<books xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:noNamespaceSchemaLocation="{book.xsd}">
	<book id="1001">
		<name>java开发实战</name>
		<author>张小三</author>
		<price>98.5</price>
	</book>
	<book id="1002">
		<name>mysql从删库到跑路</name>
		<author>王一一</author>
		<price>89.7</price>
	</book>
</books>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" >
	<xs:element name="books">
		<xs:complexType>
			<xs:sequence>
			<xs:element name="book" maxOccurs="unbounded">
				<xs:complexType>
					<xs:sequence>
						<xs:element name="name" type="xs:string"></xs:element>
						<xs:element name="author" type="xs:string"></xs:element>
						<xs:element name="price" type="xs:double"></xs:element>
					</xs:sequence>
					<xs:attribute name="id" type="xs:positiveInteger" use="required"></xs:attribute>
				</xs:complexType>
			</xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>
```

```java
SchemaFactory schemaFactory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
File sf = new File("book.xsd");
Schema schema = schemaFactory.newSchema(sf);
Validator validator = schema.newValidator();
Source source =new StreamSource("book.xml");
try {
    validator.validate(source);
    System.err.println("成功");
} catch (Exception e) {
    // TODO: handle exception
    e.printStackTrace();
    System.out.println("失败");
}
```

## 解析XML

- DOM 解析 (java 官方提供)
- SAX 解析(java 官方提供)
- JDOM 解析(第三方提供)
- DOM4J 解析(第三方提供)

### DOM

- 创建一个 DocumentBuilderFactory 的对象
- 创建一个 DocumentBuilder 对象
- 通过DocumentBuilder的parse(...)方法得到Document对象
- 通过 getElementsByTagName(...)方法获取到节点的列表
- 通过 for 循环遍历每一个节点
- 得到每个节点的属性和属性值
- 得到每个节点的节点名和节点值

```java
//	1)	创建一个DocumentBuilderFactory的对象
DocumentBuilderFactory dbf=DocumentBuilderFactory.newInstance();
//	2) 创建一个DocumentBuilder对象
DocumentBuilder db=dbf.newDocumentBuilder();
//	3)	通过DocumentBuilder的parse(...)方法得到Document对象
Document doc=db.parse("book.xml");
//	4)	通过getElementsByTagName(...)方法获取到节点的列表
NodeList bookList=doc.getElementsByTagName("book");
//System.out.println(bookList.getLength());
//	5)	通过for循环遍历每一个节点  
for(int i=0;i<bookList.getLength();i++){
    //	6)	得到每个节点的属性和属性值
    Node book=bookList.item(i);
    NamedNodeMap attrs=book.getAttributes(); //得到了属性的集合
    //循环遍历每一个属性
    for(int j=0;j<attrs.getLength();j++){
        //得到每一个属性
        Node id=attrs.item(j);
        System.out.println("属性的名称:"+id.getNodeName()+"\t"+id.getNodeValue());
    }
}
System.out.println("\n每个节点的名和节点的值");
//	7)	得到每个节点的节点名和节点值
for(int i=0;i<bookList.getLength();i++){
    //得到每一个book节点
    Node book=bookList.item(i);
    NodeList subNode=book.getChildNodes();
    System.out.println("子节点的个数:"+subNode.getLength());
    //使用for循环遍历每一book的子节点
    for(int j=0;j<subNode.getLength();j++){
        Node childNode=subNode.item(j);
        //System.out.println(childNode.getNodeName());
        short type=childNode.getNodeType(); //获取节点的类型
        if(type==Node.ELEMENT_NODE){
            System.out.println("节点的名称:"+childNode.getNodeName()+"\t"+childNode.getTextContent());
        }
    }
}
```

## SAX

SAX，全称 Simple API for XML，是一种以事件驱动的XMl API,SAX 与 DOM 不同的是它边扫描边解析，自顶向下
依次解析，由于边扫描边解析，所以它解析 XML 具有速度快，占用内存少的优点

- 创建 SAXParserFactory 的对象
- 创建 SAXParser 对象 (解析器)
- 创建一个 DefaultHandler 的子类
- 调用 parse 方法

[parse](code/sax/TestSAXParse.java)  [handle](code/sax/BookDeaultHandler.java)

## JDOM

JDOM是一种解析XML的Java工具包，它基于树型结构，利用纯Java的技术对XML文档实现解析。所以中适合于Java语言

```java
//		1)	创建一个SAXBuilder对象
SAXBuilder sb=new SAXBuilder();
//	2)	调用build方法，得到Document对象(通过IO流)
Document doc=sb.build(new FileInputStream("book.xml"));
//	3)	获取根节点
Element root=doc.getRootElement(); //books元素
//	4)	获取根节点的直接子节点的集合
List<Element> bookEle=root.getChildren();//book，2个book
//	5)	遍历集合,得到book的每一个子节点（子元素）
for(int i=0;i<bookEle.size();i++){
    Element book=bookEle.get(i);
    //得到属性集合
    List<Attribute> attList=book.getAttributes();
    //遍历属性的集合得到每一个属性
    for (Attribute attr : attList) {
        System.out.println(attr.getName()+"\t"+attr.getValue());
    }
}
//得到每一个子节点
System.out.println("\n-----------------------");
for(int i=0;i<bookEle.size();i++){
    Element book=bookEle.get(i);//得到每一个book节点
    List<Element> subBook=book.getChildren();
    //遍历每一个节点，获取节点名称节点值
    for (Element ele : subBook) {
        System.out.println(ele.getName()+"\t"+ele.getValue());
    }
    System.out.println("=========================================");
}
```

## DOM4J

现在最流行

DOM4J 是一个 Java 的 XML API，是 JDOM 的升级品，用来读写 XML 文件的

- 创建 SAXReader 对象
- 调用 read 方法
- 获取根元素
- 通过迭代器遍历直接节点

[dom4j](code/dom4j/TestDOM4J.java)   [book](code/dom4j/Book.java)

## 特点

- DOM  解析:
  形成了树结构，有助于更好的理解、掌握，且代码容易编写。
  解析过程中，树结构保存在内存中，方便修改。
- SAX  解析:
  采用事件驱动模式，对内存耗费比较小。
  适用于只处理 XML 文件中的数据时
- JDOM  解析:
  仅使用具体类，而不使用接口。
  API 大量使用了 Collections 类。
- DOM4J  解析:
  JDOM 的一种智能分支，它合并了许多超出基本 XML 文档表示的功能。
  它使用接口和抽象基本类方法。
  具有性能优异、灵活性好、功能强大和极端易用的特点。
  是一个开放源码的文件

## XPATH

[xpathTutorial](code/XPathTutorial.chm)

```java
//(1)SAXReader对象
SAXReader reader=new SAXReader();
//(2)读取XML文件
Document doc=reader.read("book.xml");
//得到第一个author节点
Node node=doc.selectSingleNode("//author");
System.out.println("节点的名称:"+node.getName()+"\t"+node.getText());
//获取所有的author
System.out.println("\n-----------------------");
List<Node> list=doc.selectNodes("//author");
for (Node n : list) {
    System.out.println("节点名称:"+n.getName()+"\t"+n.getText());
}
//选择有id属性的book元素
List<Attribute> attList=doc.selectNodes("//book/@id");
for (Attribute att : attList) {
    System.out.println("属性的名称:"+att.getName()+"\t"+att.getText());
}
```

