using UnityEngine;
using System.Collections.Generic;
using System.Xml; 
using System.Xml.Serialization; 
using System.IO;
using System;
 
 public class XMLManager
 {
 	public static void Save<T>(object obj, string path)
 	{
 		XmlSerializer serializer = new XmlSerializer(typeof(T));
 		Stream stream = new FileStream(path, FileMode.Create);
 		serializer.Serialize(stream, obj);
 		stream.Close();
 	}
 
 	public static T Load<T>(string path) 
 	{
 		XmlSerializer serializer = new XmlSerializer(typeof(T));
 		Stream stream = new FileStream(path, FileMode.Open);
 		T result = (T) serializer.Deserialize(stream);
 		stream.Close();
 		return result;
 	}
 
    public static T LoadFromText<T>(string text)
    {
 		XmlSerializer serializer = new XmlSerializer(typeof(T));
 		return (T) serializer.Deserialize(new StringReader(text));
 	}
	
	public static T getObjectsFromXML<T>(string xmlFile) {
		TextAsset textAsset = (TextAsset) Resources.Load(xmlFile, typeof(TextAsset));
		return XMLManager.LoadFromText<T>(textAsset.text);
	}
 }