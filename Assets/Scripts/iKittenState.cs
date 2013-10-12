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
	public iKittenNeed satiation 	= new iKittenNeed("Satiation", "Eat", 10, true);
	public iKittenNeed sleep 		= new iKittenNeed("Sleep", "Sleep", 10);
	public iKittenNeed love 		= new iKittenNeed("Love", "Purr", 10);
	public iKittenNeed exercise 	= new iKittenNeed("Exercise", 10);
	public iKittenNeed fun 			= new iKittenNeed("Fun", 10);
	public iKittenNeed hygiene 		= new iKittenNeed("Hygiene", "Clean", 10);
	public iKittenNeed environment 	= new iKittenNeed("Environment", "Eat", 10);
}