using UnityEngine;
using System.Collections;

public class iKittenGUI : MonoBehaviour {
	public GUISkin customSkin;
	public Vector2 SHADOW_OFFSET = new Vector2(-1,-1);
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
		
		GUI.Label(new Rect(Screen.width/4 - GUI.skin.GetStyle("iKittenIcon").fixedWidth, 5, GUI.skin.GetStyle("iKittenIcon").fixedWidth, GUI.skin.GetStyle("iKittenIcon").fixedHeight), "", "iKittenIcon");
		dropShadowLabel(new Rect(Screen.width/4, 5, GUI.skin.GetStyle("Label").fixedWidth, GUI.skin.GetStyle("Label").fixedHeight), ""+PlayerModel.use.happyPoints, "Label");
	}
	
	Color currentGUIColor;
	void dropShadowLabel(Rect pos, string content, GUIStyle style) {
		currentGUIColor = GUI.color;
		GUI.color = Color.black;
		GUI.Label(new Rect(pos.x+SHADOW_OFFSET.x, pos.y+SHADOW_OFFSET.y, pos.width, pos.height), content, "LabelShadow");
		GUI.color = currentGUIColor;
		GUI.Label(pos, content, style);
	}
}
