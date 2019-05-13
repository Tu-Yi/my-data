package com.bjsxt.schema;

import java.io.File;
import java.io.IOException;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.SAXException;

public class Test {
	public static void main(String[] args) throws SAXException {
		//(1)创建SchemaFactory工厂
		SchemaFactory sch=SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
		//(2)建立验证文件对象
		File schemaFile=new File("book.xsd");
		//(3)利用SchemaFactory工厂对象，接收验证的文件对象，生成Schema对象
		Schema schema=sch.newSchema(schemaFile);
		//(4)产生对此schema的验证器
		Validator validator=schema.newValidator();
		//(5)要验证的数据（准备数据源）
		Source source=new StreamSource("book.xml");
		//(6)开始验证
		try {
			validator.validate(source);
			System.out.println("成功");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("失败");
		}
	}
}
