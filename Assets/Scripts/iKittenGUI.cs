using UnityEngine;
using System.Collections;

public class iKittenGUI : MonoBehaviour {
	public GUISkin customSkin;
	public Vector2 SHADOW_OFFSET = new Vector2(-1,-1);
	private Rect cameraButtonPos;
	bool isShowingMessage = true;
	string message = "Congratulations! You have adopted an iKitten. They may be a bit shy. Why don't you try stroking it to put it at ease?";
	GUIStyle messageStyle;
	
	Rect messagePos;
	Rect scorePos;
	Rect scoreIconPos;
	Rect okButtonPos;
	
	void Start() {
		DontDestroyOnLoad(this);
		int cameraButtonWidth = (int)customSkin.GetStyle("CameraButton").fixedWidth;
		int cameraButtonHeight = (int)customSkin.GetStyle("CameraButton").fixedHeight;
		cameraButtonPos = new Rect(Screen.width - cameraButtonWidth, 0, cameraButtonWidth, cameraButtonHeight);
		
		messagePos = generateStyleRect("Message");
		okButtonPos = generateStyleRect("OKButton");
		scorePos = generateStyleRect("Score");
		scoreIconPos = generateStyleRect("ScoreIcon");
	}
	
	void OnGUI() {
		GUI.skin = customSkin;
		if(GUI.Button(cameraButtonPos, "", "CameraButton")) {
			Debug.Log ("Changing camera");
			CameraManager.use.nextCamera();
		}
		
		GUI.Label(scoreIconPos, "", "ScoreIcon");
		dropShadowLabel(scorePos, ""+PlayerModel.use.happyPoints, "Score");
		
		if(isShowingMessage) {
			drawMessage();
		}
	}
	
	Color currentGUIColor;
	void dropShadowLabel(Rect pos, string content, GUIStyle style) {
		currentGUIColor = GUI.color;
		GUI.color = Color.black;
		GUI.Label(new Rect(pos.x+SHADOW_OFFSET.x, pos.y+SHADOW_OFFSET.y, pos.width, pos.height), content, "LabelShadow");
		GUI.color = currentGUIColor;
		GUI.Label(pos, content, style);
	}
	
	void dropShadowLabelLayout(string content, GUIStyle style) {
		currentGUIColor = GUI.color;
		GUI.color = Color.black;
		GUILayout.Label(content, "LabelShadow");
		GUI.color = currentGUIColor;
		GUILayout.Label(content, style);
	}
	
	void drawMessage() {
		dropShadowLabel(messagePos, message, "Message");
		if(GUI.Button(okButtonPos, "OK", "OKButton")) {
			hideMessage();
		}
	}
	
	public void displayMessage(string newMessage) {
		this.message = newMessage;
	}
		
	public void hideMessage() {
		isShowingMessage = false;
	}
	
	Rect generateStyleRect(string style) {
		GUIStyle element = customSkin.GetStyle(style);
		return new Rect(element.margin.left, element.margin.top, element.fixedWidth, element.fixedHeight);
	}
}
