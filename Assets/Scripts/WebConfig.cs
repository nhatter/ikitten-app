using UnityEngine;
using System.Collections;

public class WebConfig : MonoBehaviour {
	
	public static string CREATE_USERNAME_URL;
    public static string VOTE_URL;
    public static string FEATURES_URL;
	public static string SUGGEST_URL;
	
	static WebConfig() {
		string hostname = "www.gamerdevx.com";
		#if UNITY_EDITOR
			hostname = "localhost:8888";
			Debug.Log("Using localhost for development");
		#endif
		
		CREATE_USERNAME_URL = "http://"+hostname+"/gdxbackend/user.php";
		VOTE_URL = "http://"+hostname+"/gdxbackend/vote.php";
		FEATURES_URL = "http://"+hostname+"/gdxbackend/feature_list.php";
		SUGGEST_URL ="http://"+hostname+"/gdxbackend/suggest.php";
	}
}
