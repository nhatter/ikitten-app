using UnityEngine;
using System.Collections;

using System;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

[Serializable]
public class iKittenState {
	public string name = "iKitten";
	public string materialName = "American_Wirehair.mat";
	public int satiation = 10;
	public int sleep = 10;
	public int love = 5;
	public int exercise = 5;
	public int fun = 5;
	public int warmth = 5;
	public int hygiene = 5;
	public int environment = 5;
	public int training = 5;
	public int health = 5;
}