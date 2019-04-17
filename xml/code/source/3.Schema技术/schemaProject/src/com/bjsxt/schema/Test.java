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
		//(1)����SchemaFactory����
		SchemaFactory sch=SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
		//(2)������֤�ļ�����
		File schemaFile=new File("book.xsd");
		//(3)����SchemaFactory�������󣬽�����֤���ļ���������Schema����
		Schema schema=sch.newSchema(schemaFile);
		//(4)�����Դ�schema����֤��
		Validator validator=schema.newValidator();
		//(5)Ҫ��֤�����ݣ�׼������Դ��
		Source source=new StreamSource("book.xml");
		//(6)��ʼ��֤
		try {
			validator.validate(source);
			System.out.println("�ɹ�");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("ʧ��");
		}
	}
}
