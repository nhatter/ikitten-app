using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

[Serializable]
public class SerialisableDictionary<Key, Value> : Dictionary<Key, Value>, IXmlSerializable {
	public XmlSchema GetSchema()
	{
		return null;
	}

	public void ReadXml(XmlReader reader)
	{
		bool hasKeys = true;
		
		if(reader.IsEmptyElement) {
			return;
		}
		
		reader.Read ();
		while(reader.NodeType != System.Xml.XmlNodeType.EndElement) {
			try {
				reader.ReadStartElement("Key");
					Key key = (Key) reader.ReadElementContentAs(typeof(Key), null);
				reader.ReadEndElement();
				
				reader.ReadStartElement("Value");
				Value val;
					// Serialise 
					if(!reader.IsStartElement("string")) {
						XmlRootAttribute xRoot = new XmlRootAttribute();
						xRoot.ElementName = typeof(Value).FullName;
						XmlSerializer serializer = new XmlSerializer(typeof(Value), xRoot);
						val = (Value) serializer.Deserialize(reader);
					} else {
						val = (Value) reader.ReadElementContentAs(typeof(Value), null);
					}
				reader.ReadEndElement();

				reader.MoveToContent();
				
				this.Add (key, val);
			} catch (XmlException xmlException) {
				// Something went wrong - break out of the loop
				Debug.Log ("XML parsing of SerialisableDictionary failed. Reason: "+xmlException);
				return;
			}
		}
	}

	public void WriteXml (XmlWriter writer)
	{
		
		foreach(KeyValuePair<Key, Value> keyValue in this) {
			XmlSerializer serializer = new XmlSerializer(typeof(Key));
			writer.WriteStartElement("Key");
				serializer.Serialize(writer, keyValue.Key);
			writer.WriteEndElement();
		
			if(typeof(Value).IsPrimitive) {
				serializer = new XmlSerializer(typeof(string));
			} else {
				serializer = new XmlSerializer(typeof(Value));
			}
			writer.WriteStartElement("Value");
				serializer.Serialize(writer, keyValue.Value);
			writer.WriteEndElement();
		}
	}
}
