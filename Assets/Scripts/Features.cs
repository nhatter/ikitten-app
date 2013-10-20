using UnityEngine;
using SimpleJSON;
using System.Collections;
using System.Collections.Generic;

public class Features : MonoBehaviour {
    public static string voteURL = "http://localhost:8888/gdxbackend/vote.php";
    public static string featuresURL = "http://localhost:8888/gdxbackend/feature_list.php";
	
	JSONArray features;
	
	public static int MAX_VOTES_ALLOWED = 5;
	public static int votesUsed = 0;
	public static Dictionary<int, int> votes = new Dictionary<int, int>();
 
    void Start()
    {
        StartCoroutine(GetFeatures());
    }
 
    // remember to use StartCoroutine when calling this function!
    IEnumerator PostScores()
    {
		WWWForm voteForm = new WWWForm();
		voteForm.AddField("username", PlayerModel.use.state.username);
		
		JSONArray votesJSON = new JSONArray();
		
		JSONClass voteEntry = new JSONClass();
		
		int i=0;
		foreach(KeyValuePair<int, int> vote in votes) {
			voteEntry = new JSONClass();
			voteEntry["feature_id"].AsInt = vote.Key;
			voteEntry["votes"].AsInt = vote.Value;
			votesJSON[i] = voteEntry;
			i++;
		}
 
		Debug.Log(votesJSON.ToString());
		voteForm.AddField("votes_data", votesJSON.ToString());
		voteForm.AddField("poll_id", 1);
		
        // Post the URL to the site and create a download object to get the result.
        WWW postVote = new WWW(voteURL, voteForm);
        yield return postVote; // Wait until the download is done
 
        if (postVote.error != null)
        {
            print("There was an error posting the high score: " + postVote.error);
        }
    }
 
    // Get the scores from the MySQL DB to display in a GUIText.
    // remember to use StartCoroutine when calling this function!
    IEnumerator GetFeatures()
    {
        gameObject.GetComponent<TextMesh>().text = "(Loading Features)";
		Debug.Log (featuresURL);
        WWW getFeatures = new WWW(featuresURL);
        yield return getFeatures;
 
        if (getFeatures.error != null)
        {
            print("There was an error getting the high score: " + getFeatures.error);
        }
        else
        {
			gameObject.GetComponent<TextMesh>().text = "";
			var featuresJSON = JSONNode.Parse(getFeatures.text);
			features = (JSONArray) featuresJSON["features"];

			foreach(JSONNode feature in features) {
            	gameObject.GetComponent<TextMesh>().text += feature["name"]+" ("+feature["votes"]+")\n"; // this is a GUIText that will display the scores in game.
			}
        }
    }
}
