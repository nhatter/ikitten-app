﻿using UnityEngine;
using System.Collections;

public class SceneManager : MonoBehaviour {
	public static string DEFAULT_SCENE = "Default";
	static bool isLoadingScene = false;
	
	void Start() {
		Debug.Log("Starting SceneManager");
		MainSystem.load();
		CameraManager.use.fadeIn();
	}
	
	public static void loadScene(string sceneName) {
		isLoadingScene = true;
		Application.LoadLevel(sceneName);
		Debug.Log("Finished loading "+sceneName);
	}
}
