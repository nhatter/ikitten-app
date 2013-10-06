using UnityEngine;
using System.Collections;

public class iKittenGUI : MonoBehaviour {
	public GUISkin customSkin;
	private Rect cameraButtonPos;
	
	
	void Start() {
		DontDestroyOnLoad(this);
		int cameraButtonWidth = (int)customSkin.GetStyle("CameraButton").fixedWidth;
		int cameraButtonHeight = (int)customSkin.GetStyle("CameraButton").fixedHeight;
		cameraButtonPos = new Rect(Screen.width - cameraButtonWidth, 0, cameraButtonWidth, cameraButtonHeight);
	}
	
	void OnGUI() {
		GUI.skin = customSkin;
		if(GUI.Button(cameraButtonPos, "", "CameraButton")) {
			Debug.Log ("Changing camera");
			CameraManager.use.nextCamera();
		}
		
		GUI.Label(new Rect(Screen.width/2, 5, Screen.width/2, 40), "Points: "+PlayerModel.use.happyPoints);
	}
}
