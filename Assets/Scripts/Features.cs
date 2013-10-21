using UnityEngine;
using SimpleJSON;
using System.Collections;
using System.Collections.Generic;

public class Features : MonoBehaviour {
	public static Features use;
    public static string voteURL = "http://localhost:8888/gdxbackend/vote.php";
    public static string featuresURL = "http://localhost:8888/gdxbackend/feature_list.php";
	
	JSONArray features;
	
	public static float featureVerticalSpacing = -0.5f;
	public static int MAX_VOTES_ALLOWED = 5;
	public static int votesUsed = 0;
	public static Dictionary<int, int> votes = new Dictionary<int, int>();
	public static Dictionary<int, GameObject> featureCountIDs = new Dictionary<int, GameObject>();
	public static bool areWidgetsInitialised = false;
	
	Vector3 plus1Pos;
	Vector3 minus1Pos;
	Vector3 featureCountPos;
	
	GameObject submitVotesWidget;
 
    void Start()
    {
		updateFeatures();
		plus1Pos = GameObject.Find("Feature +1").transform.position;
		minus1Pos = GameObject.Find("Feature -1").transform.position;
		featureCountPos = GameObject.Find("FeatureCount").transform.position;
		submitVotesWidget = GameObject.Find("SubmitVotes");

		use = this;
    }
 
    // remember to use StartCoroutine when calling this function!
    IEnumerator PostFeatures()
    {
		Debug.Log("POSTing votes");
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
 
        if (postVote.error != null) {
            print("There was an error posting the high score: " + postVote.error);
		} else {
			updateFeatures();
			submitVotesWidget.GetComponent<TextMesh>().text = "SUBMITTED!";
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
			
			int i = 0;
			
			votes = new Dictionary<int, int>();
			foreach(JSONNode feature in features) {
				Vector3 vSpacing = new Vector3(0, i*featureVerticalSpacing,0);
            	gameObject.GetComponent<TextMesh>().text += feature["name"]+" ("+feature["votes"]+")\n";
				
				if(!areWidgetsInitialised) {
					createVoter3DWidgets(feature["id"].AsInt, plus1Pos+vSpacing, minus1Pos+vSpacing,featureCountPos+vSpacing);
				}
				
				// init vote count for feature
				votes.Add(feature["id"].AsInt, 0);
				
				i++;
			}
			
			areWidgetsInitialised = true;
        }
    }
	
	public void submitVotes() {
		StartCoroutine(PostFeatures());
	}
	
	public void updateFeatures() {
		StartCoroutine(GetFeatures());
	}
	
	void createVoter3DWidgets(int featureId, Vector3 newPlus1Pos, Vector3 newMinus1Pos, Vector3 newFeatureCountPos) {
		GameObject plus1 = (GameObject) GameObject.Instantiate(Resources.Load("WhiteBoard/Feature +1"));
		plus1.transform.position = newPlus1Pos;
		plus1.GetComponent<Voter>().isIncVote = true;
		plus1.GetComponent<Voter>().featureId = featureId;
		
		GameObject minus1 = (GameObject) GameObject.Instantiate(Resources.Load("WhiteBoard/Feature -1"));
		minus1.GetComponent<Voter>().featureId = featureId;
		minus1.GetComponent<Voter>().isIncVote = false;
		minus1.transform.position = newMinus1Pos;
		
		GameObject featureCount = (GameObject) GameObject.Instantiate(Resources.Load("WhiteBoard/FeatureCount"));
		featureCountIDs.Add(featureId, featureCount);
		featureCount.transform.position = newFeatureCountPos;
	}
	
	public void changeVote(int featureId, bool isAdding) {
		int voteCount = 0;
		GameObject voteCountDisplay;
		
	
		votes.TryGetValue(featureId, out voteCount);
		votes.Remove(featureId);
		if(isAdding) {
			if(votesUsed < MAX_VOTES_ALLOWED) {
				voteCount++;
				votesUsed++;
			}
		} else {
			if(voteCount > 0) {
				voteCount--;
				votesUsed--;
			}
		}
		
		votes.Add(featureId, voteCount);
		
		featureCountIDs.TryGetValue(featureId, out voteCountDisplay);
		voteCountDisplay.GetComponent<TextMesh>().text = ""+voteCount;
	}
}
