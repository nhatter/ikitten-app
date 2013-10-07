using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerModel : MonoBehaviour {
	public static PlayerModel use;
	
	public int happyPoints;
	public int money;
	public int strokePoints;
	
	public int strokePointsToGainHappyPoints = 10000;
	public int happyPointsGainedFromStroking = 100;
	public bool isHappyFromStroking = false;
	
	private Dictionary<string, GameObject> party = new Dictionary<string, GameObject>();
	
	void Start() {
		use = this;
		foreach(iKittenModel model in GameObject.FindObjectsOfType(typeof(iKittenModel) )) {
			party.Add (model.getState().name, model.gameObject);
		}
	}
	
	public void incStrokePoints() {
		strokePoints += (int) (Time.deltaTime * 1000);
		
		if(strokePoints >= strokePointsToGainHappyPoints) {
			isHappyFromStroking = true;
			happyPoints += happyPointsGainedFromStroking;
			strokePoints = 0;
		}
	}
	
	public SerialisableDictionary<string, iKittenState> getSerialisableParty() {
		SerialisableDictionary<string, iKittenState> partyStats = new SerialisableDictionary<string, iKittenState>();
		foreach(GameObject member in party.Values) {
			iKittenState entity = member.GetComponent<iKittenModel>().getState();
			partyStats.Add(entity.name, entity);
		}
		
		return partyStats;
	}
	
	public void loadSerialisedParty(SerialisableDictionary<string, iKittenState> serialisedParty) {
		foreach(KeyValuePair<string, iKittenState> kitten in serialisedParty) {
			GameObject iKitten = (GameObject) GameObject.Instantiate((GameObject) Resources.Load("iKitten"));
			iKitten.GetComponent<iKittenModel>().state = kitten.Value;
			CameraManager.use.setCameraToFollow(iKitten);
		}
	}
}
