using UnityEngine;
using System;
using System.Collections;

public class MainSystem : MonoBehaviour {
	static GameObject systemObject = null;
	
	void Start() {
		DontDestroyOnLoad(this);
		systemObject = this.gameObject;
		Screen.orientation = ScreenOrientation.LandscapeLeft;
	}

	public static void load() {
		Debug.Log("Initialising system...");
		foreach(MainSystem sysObject in GameObject.FindObjectsOfType(typeof(MainSystem))) {
			if(sysObject.gameObject != systemObject) {
				Debug.Log ("Destroy existing system");
				GameObject.DestroyImmediate(sysObject.gameObject);
			}
		}
		
		if(systemObject == null) {
			newSystem();
		}
	}
	
	static void newSystem() {
		systemObject = (GameObject) GameObject.Instantiate((GameObject) Resources.Load("System"));
	}
}
