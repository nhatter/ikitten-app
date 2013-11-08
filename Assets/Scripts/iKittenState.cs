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
	public static string[] ANIMATION_STATES = {"Meow", "Eat", "Lick", "Idle", "Run", "Stroke", "Sleep", "Jump"}; 
	public string name = "iKitten";
	public string materialName = "American_Wirehair";
	public string animationState = "Idle";
	public string itemEquipped = "";
	public Vector3 position = new Vector3(0,0,0); 
	public iKittenNeedState[] needs;
}