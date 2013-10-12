using UnityEngine;
using System.Collections;

using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

[Serializable]
public class iKittenState {
	public string name = "iKitten";
	public string materialName = "American_Wirehair";
	public iKittenNeedState[] needs;
}