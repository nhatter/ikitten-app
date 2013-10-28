using UnityEngine;
using System;
using System.Collections;
using SimpleJSON;

public class CreateUsername : MonoBehaviour {
	public GUISkin customSkin;
    public enum CreationStatus { USERNAME_EXISTS, RUDE_USERNAME, SUCCESS };
	string statusMessage;
	string username = "";
	CreationStatus status;
	
	Rect usernamePos;
	
	void Start() {
		
	}
	
	// remember to use StartCoroutine when calling this function!
    IEnumerator createUsername(string username)
    {
		WWWForm voteForm = new WWWForm();
		voteForm.AddField("username", username);
		voteForm.AddField("action", "create_user");
		
        // Post the URL to the site and create a download object to get the result.
        WWW postUsername = new WWW(WebConfig.CREATE_USERNAME_URL, voteForm);
        yield return postUsername; // Wait until the download is done
 
        if (postUsername.error != null) {
            print("There was an error creating username: " + postUsername.error);
		} else {
			var resultJSON = JSONNode.Parse(postUsername.text);
			Debug.Log("Status when creating username: "+resultJSON["status"]);
			status = (CreationStatus) Enum.Parse(typeof(CreationStatus), resultJSON["status"]);
			switch(status) {
				case CreationStatus.USERNAME_EXISTS:
					statusMessage = "Username already exists :(";
				break;
				
				case CreationStatus.RUDE_USERNAME:
					statusMessage = "Rude username :( Try again.";
				break;
				
				case CreationStatus.SUCCESS:
					PlayerModel.use.state.username = username;
					PlayerModel.use.state.sessionId = resultJSON["session_id"];
					Debug.Log ("Player username is"+PlayerModel.use.state.username );

					Fader.use.OutThen(delegate() {
						Debug.Log ("Player username is"+PlayerModel.use.state.username );
						Application.LoadLevel("Adoption");
					});
				break;
			}
        }
    }
	
	void OnGUI() {
		GUI.skin = iKittenGUI.use.customSkin;
		iKittenGUI.dropShadowLabel(iKittenGUI.messagePos, "Create a username", "Message");
		username = GUI.TextField(iKittenGUI.textFieldPos, username);
		
		if(statusMessage != "") {
			GUI.Label(iKittenGUI.inputWarningPos, statusMessage, "InputWarning");
		}
		
		if(GUI.Button(iKittenGUI.okButtonPos, "Create", "OKButton")) {
			StartCoroutine(createUsername(username));
		}
		
		Fader.use.showChange();
	}
}
