using UnityEngine;
using System.Xml.Serialization;

[XmlRoot("itemsXML")]
public class ItemsXMLContainer {
	[XmlArray("items")]
 	[XmlArrayItem("item")]
	public Item[] items;
}

