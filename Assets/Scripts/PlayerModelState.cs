using UnityEngine;
using System;
using System.Collections;

[Serializable]
public class PlayerModelState {
	public string username = "Hatman";
	public string sessionId;
	public bool hasSelectedKitten = false;
	public int happyPoints = 0;
	public int money = 0;
	public bool hasFinishedTutorial = false;
}
