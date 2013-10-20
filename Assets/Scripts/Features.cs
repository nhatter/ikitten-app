using UnityEngine;
using SimpleJSON;
using System.Collections;

public class Features : MonoBehaviour {
    public string voteURL = "http://localhost:8888/adoptafluffy/vote.php?"; //be sure to add a ? to your url
    public string featuresURL = "http://localhost:8888/adoptafluffy/feature_list.php";
 
    void Start()
    {
        StartCoroutine(GetFeatures());
    }
 
    // remember to use StartCoroutine when calling this function!
    IEnumerator PostScores(string name, int score)
    {
        //This connects to a server side php script that will add the name and score to a MySQL DB.
        // Supply it with a string representing the players name and the players score.
        string hash = name + score;
 
        string post_url = voteURL + "name=" + WWW.EscapeURL(name) + "&score=" + score + "&hash=" + hash;
 
        // Post the URL to the site and create a download object to get the result.
        WWW hs_post = new WWW(post_url);
        yield return hs_post; // Wait until the download is done
 
        if (hs_post.error != null)
        {
            print("There was an error posting the high score: " + hs_post.error);
        }
    }
 
    // Get the scores from the MySQL DB to display in a GUIText.
    // remember to use StartCoroutine when calling this function!
    IEnumerator GetFeatures()
    {
        gameObject.GetComponent<TextMesh>().text = "(Loading Features)";
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
			JSONArray features = (JSONArray) featuresJSON["features"];

			foreach(JSONNode feature in features) {
            	gameObject.GetComponent<TextMesh>().text += feature["name"]+" ("+feature["votes"]+")\n"; // this is a GUIText that will display the scores in game.
			}
        }
    }
}
