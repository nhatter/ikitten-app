using UnityEngine;
using System.Collections;

public class SuggestionView : MonoBehaviour {
	public static SuggestionView use;
	public Texture2D backgroundImage;
	public GUISkin customSkin;
	public string suggestion = "Dear Gamer Developer Exchange,\n";
	public bool isActive = false;
	public static int POINTS_FROM_SUGGESTION = 5000;
	
	Rect backgroundRect;
	Rect suggestionRect;
	Rect submitSuggestionRect;
	Rect cancelSuggestionRect;
	Vector2 submitSuggestionSize;

	// Use this for initialization
	void Start () {
		backgroundRect = new Rect(0,0,Screen.width, Screen.height);
		suggestionRect = new Rect(Screen.width/16, Screen.height/16, Screen.width - Screen.width/16*2, Screen.height*0.75f);
		
		customSkin.GetStyle("textarea").fontSize = Mathf.CeilToInt(Screen.height*0.075f);
		
		float submitSuggestionRatio = (float) customSkin.GetStyle("SendFeedback").normal.background.height / (float) customSkin.GetStyle("SendFeedback").normal.background.width;
		float submitSuggestionWidth = Screen.width * 0.238f;
		submitSuggestionSize = new Vector2(submitSuggestionWidth, submitSuggestionWidth * submitSuggestionRatio);
		submitSuggestionRect = new Rect(Screen.width/2 -submitSuggestionSize.x/2, Screen.height - submitSuggestionSize.y/2, submitSuggestionSize.x, submitSuggestionSize.y);
		
		customSkin.GetStyle("SendFeedback").padding = new RectOffset(Mathf.CeilToInt(Screen.width * 0.05f), 0, Mathf.CeilToInt(Screen.height * 0.095f), 0);
		customSkin.GetStyle("SendFeedback").fontSize = Mathf.CeilToInt(Screen.height*0.1f);
		customSkin.GetStyle("CancelFeedback").fontSize = customSkin.GetStyle("SendFeedback").fontSize;
		customSkin.GetStyle("CancelFeedback").padding = new RectOffset(Mathf.CeilToInt(Screen.width * 0.05f), 0, Mathf.CeilToInt(Screen.height * 0.08f), 0);
		
		cancelSuggestionRect = new Rect(Screen.width/20, Screen.height - submitSuggestionSize.y/2, submitSuggestionSize.x, submitSuggestionSize.y);
		
		use = this;
	}
	
	// remember to use StartCoroutine when calling this function!
    IEnumerator PostSuggestion()
    {
		Debug.Log("POSTing suggestion");
		WWWForm voteForm = new WWWForm();
		
		voteForm.AddField("session_id", PlayerModel.use.state.sessionId);
		voteForm.AddField("suggestion_text", suggestion);
		
        // Post the URL to the site and create a download object to get the result.
        WWW postVote = new WWW(WebConfig.SUGGEST_URL, voteForm);
        yield return postVote; // Wait until the download is done
		
        if (postVote.error != null) {
            print("There was an error posting your suggestion: " + postVote.error);
		} else {
			PlayerModel.use.incHappyPoints(POINTS_FROM_SUGGESTION);
			yield return new WaitForSeconds(2);
			PlayerModel.use.stoppedIncreasingPoints = true;
			isActive = false;
        }
    }
	
	void OnGUI() {
		if(!isActive) {
			return;
		}
		
		GUI.skin = customSkin;
		GUI.DrawTexture(backgroundRect, backgroundImage);
		suggestion = GUI.TextArea(suggestionRect, suggestion);
		if(GUI.Button(submitSuggestionRect, "Send", "SendFeedback")) {
			Debug.Log ("Submitting suggestion");
			StartCoroutine(PostSuggestion());
		}
		
		if(GUI.Button(cancelSuggestionRect, "Cancel", "CancelFeedback")) {
			Debug.Log ("Cancel suggestion");
			isActive = false;
		}
	}
}
