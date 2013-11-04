using UnityEngine;
using SimpleJSON;
using System.Collections;
using System.Collections.Generic;

public class Features : MonoBehaviour {
	public static Features use;
	public static int POINTS_FROM_VOTING = 5000;
	
	JSONArray features;
	
	public static float voterWidgetSpacing = -0.3f;
	public static float featureVerticalSpacing = -0.5f;
	public static int MAX_VOTES_ALLOWED = 5;
	public static int MAX_VOTES_PER_FEATURE = 5;
	public static Dictionary<int, int> votes = new Dictionary<int, int>();
	public static Dictionary<int, GameObject> featureCountIDs = new Dictionary<int, GameObject>();
	public static Dictionary<int, GameObject[]> featureVoteWidgets = new Dictionary<int, GameObject[]>();
	public static bool areWidgetsInitialised = false;
	
	Vector3 voterWidgetPos;
	Vector3 minus1Pos;
	Vector3 featureCountPos;
	
	GameObject submitVotesWidget;
	GameObject voteQuota;
 
    void Start()
    {
		updateFeatures();
		voterWidgetPos = GameObject.Find("VoteSymbol").transform.position;

		submitVotesWidget = GameObject.Find("SubmitVotes");
		voteQuota = GameObject.Find("VoteQuota");

		use = this;
    }
 
    // remember to use StartCoroutine when calling this function!
    IEnumerator PostFeatures()
    {
		Debug.Log("POSTing votes");
		WWWForm voteForm = new WWWForm();
		
		JSONArray votesJSON = new JSONArray();
		JSONClass voteEntry = new JSONClass();
		
		voteForm.AddField("session_id", PlayerModel.use.state.sessionId);
		
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
        WWW postVote = new WWW(WebConfig.VOTE_URL, voteForm);
        yield return postVote; // Wait until the download is done
		
		
 
        if (postVote.error != null) {
            print("There was an error posting the high score: " + postVote.error);
			submitVotesWidget.GetComponent<TextMesh>().text = "ERROR - TRY AGAIN";
		} else {
			updateFeatures();
			submitVotesWidget.GetComponent<TextMesh>().text = "THANK YOU!";
			PlayerModel.use.incHappyPoints(POINTS_FROM_VOTING);
			yield return new WaitForSeconds(2);
			PlayerModel.use.stoppedIncreasingPoints = true;
        }
    }
 
    // Get the scores from the MySQL DB to display in a GUIText.
    // remember to use StartCoroutine when calling this function!
    IEnumerator GetFeatures()
    {
        gameObject.GetComponent<TextMesh>().text = "(Loading Features)";
		Debug.Log (WebConfig.FEATURES_URL);
        WWW getFeatures = new WWW(WebConfig.FEATURES_URL);
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
					createVoter3DWidgets(feature["id"].AsInt, voterWidgetPos+vSpacing, featureCountPos+vSpacing);
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
	
	void createVoter3DWidgets(int featureId, Vector3 firstWidgetPost, Vector3 newFeatureCountPos) {
		List<GameObject> featureVoteWidgetsList = new List<GameObject>();
		
		for(int i=0; i<MAX_VOTES_PER_FEATURE; i++) {
			GameObject voterWidget = (GameObject) GameObject.Instantiate(Resources.Load("WhiteBoard/VoteSymbol"));
			voterWidget.transform.position = firstWidgetPost + new Vector3(0, 0, i*voterWidgetSpacing);
			
			// Make the first voterWidget enabled by default for UI clarity
			voterWidget.GetComponent<Voter>().setEnabled(i == 0);
			voterWidget.GetComponent<Voter>().featureId = featureId;
			voterWidget.GetComponent<Voter>().voteCountToRepresent = i;
			featureVoteWidgetsList.Add(voterWidget);
		}
		
		featureVoteWidgets.Add(featureId, featureVoteWidgetsList.ToArray());
	}
	
	public void changeVote(int featureId, int representingVoteCount) {
		GameObject[] featureVoteWidgetsArray;
		
		int voteCount = representingVoteCount;
		int currentVotesForFeature = 0;
		int currentVoteCount = getVotesUsed();
		votes.TryGetValue(featureId, out currentVotesForFeature) ;
		
		if(currentVoteCount - currentVotesForFeature + voteCount > MAX_VOTES_ALLOWED) {
			voteCount = MAX_VOTES_ALLOWED - (currentVoteCount - currentVotesForFeature);
		}
		
		votes.Remove(featureId);
		votes.Add(featureId, voteCount);
		
		featureVoteWidgets.TryGetValue(featureId, out featureVoteWidgetsArray);
		
		for(int i=0; i<=voteCount; i++) {
			featureVoteWidgetsArray[i].GetComponent<Voter>().setEnabled(true);
		}
	
		if(voteCount <= MAX_VOTES_PER_FEATURE-2) {
			for(int i=voteCount+1; i<MAX_VOTES_PER_FEATURE; i++) {
				featureVoteWidgetsArray[i].GetComponent<Voter>().setEnabled(false);
			}
		}
		
		voteQuota.GetComponent<TextMesh>().text = (MAX_VOTES_ALLOWED - getVotesUsed())+" left";
		
	}
	
	public int getVotesUsed() {
		int totalVoteCount = 0;
		
		foreach(int voteCount in votes.Values) {
			totalVoteCount += voteCount;
		}
		
		return totalVoteCount;
	}
}
