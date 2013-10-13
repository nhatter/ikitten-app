using UnityEngine;
using System.Collections;

public class iKittenGUI : MonoBehaviour {
	public GUISkin customSkin;
	public Vector2 SHADOW_OFFSET = new Vector2(-1,-1);
	private Rect cameraButtonPos;
	private Rect torchButtonPos;
	bool isShowingMessage = true;
	string message = "Congratulations! You have adopted an iKitten. They may be a bit shy. Why don't you try stroking it to put it at ease?";
	GUIStyle messageStyle;
	
	Rect scorePosValue;
	Rect messagePos;
	Rect scorePos;
	Rect scorePosOffScreen;
	Rect scoreIconPos;
	Rect scoreIconPosOffScreen;
	Rect scoreIconPosValue;
	Rect okButtonPos;
	
	bool isShowingScore = false;
	bool isHidingScore = false;
	bool hasAnimatedShowingScore = false;
	bool hasAnimatedHidingScore = false;
	
	void Start() {
		DontDestroyOnLoad(this);
		int cameraButtonWidth = (int)customSkin.GetStyle("CameraButton").fixedWidth;
		int cameraButtonHeight = (int)customSkin.GetStyle("CameraButton").fixedHeight;
		cameraButtonPos = new Rect(Screen.width - cameraButtonWidth, 0, cameraButtonWidth, cameraButtonHeight);
		torchButtonPos = new Rect(Screen.width - cameraButtonWidth, cameraButtonHeight+5, cameraButtonWidth, cameraButtonHeight);
		
		messagePos = generateStyleRect("Message");
		okButtonPos = generateStyleRect("OKButton");
		scorePos = generateStyleRect("Score");
		scorePosOffScreen = new Rect(scorePos.x, scorePos.y - customSkin.GetStyle("Score").fixedHeight*2, scorePos.width, scorePos.height);
		scorePosValue = scorePosOffScreen;
		
		scoreIconPos = generateStyleRect("ScoreIcon");
		scoreIconPosOffScreen = new Rect(scoreIconPos.x, scoreIconPos.y - customSkin.GetStyle("ScoreIcon").fixedHeight*2, scoreIconPos.width, scoreIconPos.height);
		scoreIconPosValue = scoreIconPosOffScreen;
	}
	
	void OnGUI() {
		GUI.skin = customSkin;
		if(GUI.Button(cameraButtonPos, "", "CameraButton")) {
			Debug.Log ("Changing camera");
			CameraManager.use.nextCamera();
		}
		
		if(GUI.Button(torchButtonPos, "", "TorchButton"+(iKittenModel.isTorchLit ? "Lit" : "")) ) {
			iKittenModel.isTorchLit = !iKittenModel.isTorchLit;
			if(iKittenModel.isTorchLit) {
				iKittenModel.lightBlob.GetComponentInChildren<Projector>().enabled = true;

				iKittenModel.chaseObject = iKittenModel.lightBlob;
				foreach(iKittenModel model in GameObject.FindObjectsOfType(typeof(iKittenModel)) ) {
					model.chase();
				}
			} else {
				foreach(iKittenModel model in GameObject.FindObjectsOfType(typeof(iKittenModel)) ) {
					model.stopChasingObject();
				}
				iKittenModel.lightBlob.GetComponentInChildren<Projector>().enabled = false;
			}
		}
		
		if(PlayerModel.use.isIncreasingPoints) {
			if(!hasAnimatedShowingScore) {
				iTween.ValueTo(gameObject,iTween.Hash("from",scoreIconPosValue,"to",scoreIconPos,"onupdate","AnimateScoreIcon","easetype","easeinoutback"));
				iTween.ValueTo(gameObject,iTween.Hash("from",scorePosValue,"to",scorePos,"onupdate","AnimateScore","easetype","easeinoutback"));
				
				hasAnimatedShowingScore = true;
			} else {
				if(!hasAnimatedHidingScore && PlayerModel.use.stoppedIncreasingPoints) {
					iTween.ValueTo(gameObject,iTween.Hash("from",scoreIconPosValue,"to",scoreIconPosOffScreen,"onupdate","AnimateScoreIcon","easetype","easeinoutback"));
				    iTween.ValueTo(gameObject,iTween.Hash("from",scorePosValue,"to",scorePosOffScreen,"onupdate","AnimateScore","easetype","easeinoutback"));
	
					hasAnimatedHidingScore = true;
				}
			}
			
			GUI.Label(scoreIconPosValue, "", "ScoreIcon");
			dropShadowLabel(scorePosValue, ""+PlayerModel.use.happyPoints, "Score");
		}
		
		
		
		if(isShowingMessage) {
			drawMessage();
		}
	}
	
	public void showScore() {
		isShowingScore = true;
	}
	
	public void hideScore() {
		isHidingScore = true;
	}
	
	void ResetScoreAnimation() {
		hasAnimatedShowingScore = false;
		hasAnimatedHidingScore = false;
		PlayerModel.use.isIncreasingPoints = false;
		PlayerModel.use.stoppedIncreasingPoints = false;
		isShowingScore = false;
		isHidingScore = false;
	}
	
	void AnimateScore(Rect newCoordinates){
		scorePosValue=newCoordinates;
	}
	
	void AnimateScoreIcon(Rect newCoordinates){
		scoreIconPosValue=newCoordinates;
		if(scoreIconPosValue == scoreIconPosOffScreen && hasAnimatedHidingScore) {
			ResetScoreAnimation();
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
