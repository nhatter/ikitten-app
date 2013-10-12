using UnityEngine;
using System;
using System.Collections;

[Serializable]
public class iKittenNeedState {
	public string needName;
	public int need = 10;
	public int resourceLevel = 10;
	public bool isResourceRequired = false;
	public float timer = 0;
	public bool isMovingToMeetNeed = false;
	public bool isAtLocationToMeetNeed = false;
	public bool isMeetingNeed = false;
	public float needAlertTimer = 0;
}
