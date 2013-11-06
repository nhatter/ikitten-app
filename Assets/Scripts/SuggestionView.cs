using UnityEngine;
using System.Collections;

public class SuggestionView : MonoBehaviour {
	public Texture2D backgroundImage;
	public GUISkin customSkin;
	public string suggestion = "Dear Gamer Developer Exchange,\n";
	
	Rect backgroundRect;
	Rect suggestionRect;
	Rect submitSuggestionRect;
	Rect cancelSuggestionRect;
	Vector2 submitSuggestionSize;

	// Use this for initialization
	void Start () {
		backgroundRect = new Rect(0,0,Screen.width, Screen.height);
		suggestionRect = new Rect(Screen.width/16, Screen.height/16, Screen.width - Screen.width/16*2, Screen.height*0.75f);
		
		customSkin.GetStyle("textarea").fontSize = Mathf.CeilToInt(Screen.height*0.05f);
		
		float submitSuggestionRatio = (float) customSkin.GetStyle("SendFeedback").normal.background.height / (float) customSkin.GetStyle("SendFeedback").normal.background.width;
		float submitSuggestionWidth = Screen.width * 0.238f;
		submitSuggestionSize = new Vector2(submitSuggestionWidth, submitSuggestionWidth * submitSuggestionRatio);
		submitSuggestionRect = new Rect(Screen.width/2 -submitSuggestionSize.x/2, Screen.height - submitSuggestionSize.y/2, submitSuggestionSize.x, submitSuggestionSize.y);
		
		customSkin.GetStyle("SendFeedback").padding = new RectOffset(Mathf.CeilToInt(Screen.width * 0.065f), 0, Mathf.CeilToInt(Screen.height * 0.08f), 0);
		customSkin.GetStyle("SendFeedback").fontSize = Mathf.CeilToInt(Screen.height*0.05f);
		customSkin.GetStyle("CancelFeedback").fontSize = customSkin.GetStyle("SendFeedback").fontSize;
		customSkin.GetStyle("CancelFeedback").padding = customSkin.GetStyle("SendFeedback").padding;
		
		cancelSuggestionRect = new Rect(Screen.width/20, Screen.height - submitSuggestionSize.y/2, submitSuggestionSize.x, submitSuggestionSize.y);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnGUI() {
		GUI.skin = customSkin;
		GUI.DrawTexture(backgroundRect, backgroundImage);
		suggestion = GUI.TextArea(suggestionRect, suggestion);
		if(GUI.Button(submitSuggestionRect, "Send", "SendFeedback")) {
			Debug.Log ("Submitting suggestion");
		}
		
		if(GUI.Button(cancelSuggestionRect, "Cancel", "CancelFeedback")) {
			Debug.Log ("Cancel suggestion");
		}
	}
}
