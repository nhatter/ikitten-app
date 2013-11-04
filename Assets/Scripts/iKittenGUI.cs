using UnityEngine;
using System;
using System.Collections;

public class iKittenGUI : MonoBehaviour {
	public static iKittenGUI use;
	
	public bool isActive = false;
	public GUISkin customSkin;
	public static Vector2 SHADOW_OFFSET = new Vector2(-1,-1);
	private Rect cameraButtonPos;
	private Rect torchButtonPos;
	bool isShowingMessage = false;
	string message = "Congratulations! You have adopted an iKitten. They may be a bit shy. Why don't you try stroking it to put it at ease?";
	GUIStyle messageStyle;
	GUIStyle OKButtonStyle;
	string okButtonText;
	Action okButtonAction;
	bool isOKButtonActionSet = false;

	Rect scorePosValue;
	public Rect messagePos;
	public Rect originalMessagePos;
	public Rect textFieldPos;
	public Rect inputWarningPos;
	Rect scorePos;
	Rect scorePosOffScreen;
	Rect scoreIconPos;
	Rect scoreIconPosOffScreen;
	Rect scoreIconPosValue;
	public static Rect okButtonPos;
	Rect featureButtonPos;
	
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
		
		messageStyle = customSkin.GetStyle("Message");
		originalMessagePos = new Rect(messageStyle.margin.left, messageStyle.margin.top, Screen.width-(messageStyle.margin.left*2), Screen.height-(messageStyle.margin.top*2));
		messagePos = originalMessagePos;
		OKButtonStyle = customSkin.GetStyle("OKButton");
		
		GUIStyle textFieldStyle = customSkin.GetStyle("textfield");
		textFieldPos = new Rect(messagePos.x+textFieldStyle.margin.left, messagePos.y+messageStyle.fontSize*2, messagePos.width-messagePos.x*2, textFieldStyle.fixedHeight);
		
		inputWarningPos = new Rect(textFieldPos.x, textFieldPos.y+textFieldPos.height, textFieldPos.width, textFieldPos.height);
				
		scorePos = generateStyleRect("Score");
		scorePosOffScreen = new Rect(scorePos.x, scorePos.y - customSkin.GetStyle("Score").fixedHeight*2, scorePos.width, scorePos.height);
		scorePosValue = scorePosOffScreen;
		
		scoreIconPos = generateStyleRect("ScoreIcon");
		scoreIconPosOffScreen = new Rect(scoreIconPos.x, scoreIconPos.y - customSkin.GetStyle("ScoreIcon").fixedHeight*2, scoreIconPos.width, scoreIconPos.height);
		scoreIconPosValue = scoreIconPosOffScreen;
		
		featureButtonPos = generateStyleRect("FeatureButton");
		
		use = this;
	}
	
	void OnGUI() {
		// Don't show interface unless playing the game
		if(!isActive) {
			return;
		}
		
		GUI.skin = customSkin;
		
		if(PlayerModel.use.isIncreasingPoints || ShopView.use.isActive) {
			if(!hasAnimatedShowingScore) {
				iTween.ValueTo(gameObject,iTween.Hash("from",scoreIconPosValue,"to",scoreIconPos,"onupdate","AnimateScoreIcon","easetype","easeinoutback"));
				iTween.ValueTo(gameObject,iTween.Hash("from",scorePosValue,"to",scorePos,"onupdate","AnimateScore","easetype","easeinoutback"));
				
				hasAnimatedShowingScore = true;
			} else {
				if(!hasAnimatedHidingScore && (PlayerModel.use.stoppedIncreasingPoints || !ShopView.use.isActive)) {
					iTween.ValueTo(gameObject,iTween.Hash("from",scoreIconPosValue,"to",scoreIconPosOffScreen,"onupdate","AnimateScoreIcon","easetype","easeinoutback"));
				    iTween.ValueTo(gameObject,iTween.Hash("from",scorePosValue,"to",scorePosOffScreen,"onupdate","AnimateScore","easetype","easeinoutback"));
	
					hasAnimatedHidingScore = true;
				}
			}
			
			GUI.Label(scoreIconPosValue, "", "ScoreIcon");
			dropShadowLabel(scorePosValue, ""+PlayerModel.use.state.happyPoints, "Score");
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
	
	static Color currentGUIColor;
	
	public void dropShadowLabel(Rect pos, string content, GUIStyle style) {
		dropShadowLabel(pos, content, style, TextAnchor.UpperLeft);
	}
	
	public void dropShadowLabel(Rect pos, string content, GUIStyle style, TextAnchor alignment) {
		currentGUIColor = GUI.color;
		GUI.color = Color.black;
		customSkin.GetStyle("LabelShadow").fontSize = style.fontSize;
		customSkin.GetStyle("LabelShadow").alignment = alignment;
		GUI.Label(new Rect(pos.x+SHADOW_OFFSET.x, pos.y+SHADOW_OFFSET.y, pos.width, pos.height), content, "LabelShadow");
		GUI.color = currentGUIColor;
		GUI.Label(pos, content, style);
	}
	
	void dropShadowLabelLayout(string content, GUIStyle style) {
		currentGUIColor = GUI.color;
		GUI.color = Color.black;
		customSkin.GetStyle("LabelShadow").fontSize = style.fontSize;
		GUILayout.Label(content, "LabelShadow");
		GUI.color = currentGUIColor;
		GUILayout.Label(content, style);
	}
	
	public void drawMessage() {
		dropShadowLabel(messagePos, message, "Message", TextAnchor.UpperCenter);
		if(GUI.Button(okButtonPos, okButtonText, "OKButton")) {
			hideMessage();
			if(isOKButtonActionSet) {
				okButtonAction();
			}
		}
	}
	
	public void displayMessage(Rect messagePos, string newMessage, string okButtonText) {
		this.okButtonText = okButtonText;
		this.messagePos = messagePos;
		this.message = newMessage;
		okButtonPos = new Rect(messagePos.x+messagePos.width/4, messagePos.y+messagePos.height-OKButtonStyle.fixedHeight-messageStyle.padding.top, messagePos.width/2, OKButtonStyle.fixedHeight);
		isShowingMessage = true;
	}
	
	public void displayMessage(string newMessage) {
		displayMessage(newMessage, "OK");
	}
	
	public void displayMessage(string newMessage, string okButtonText, Action okAction) {
		this.okButtonAction = okAction;
		this.isOKButtonActionSet = true;
		displayMessage(newMessage, okButtonText);
	}
	
	public void displayMessage(string newMessage, string okButtonText) {
		this.okButtonText = okButtonText;
		this.messagePos = originalMessagePos;
		this.message = newMessage;
		okButtonPos = new Rect(messagePos.x+messagePos.width/4, messagePos.y+messagePos.height-OKButtonStyle.fixedHeight-messageStyle.padding.top, messagePos.width/2, OKButtonStyle.fixedHeight);
		isShowingMessage = true;
	}
		
	public void hideMessage() {
		isShowingMessage = false;
	}
	
	Rect generateStyleRect(string style) {
		GUIStyle element = customSkin.GetStyle(style);
		return new Rect(element.margin.left, element.margin.top, element.fixedWidth, element.fixedHeight);
	}
	
	public static Rect generateStyleRect(GUISkin guiStyle, string style) {
		GUIStyle element = guiStyle.GetStyle(style);
		return new Rect(element.margin.left, element.margin.top, element.fixedWidth, element.fixedHeight);
	}
}
