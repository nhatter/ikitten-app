using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerModel : MonoBehaviour {
	public static PlayerModel use;
	
	public int happyPoints;
	public int money;
	public int strokePoints;
	public bool isIncreasingPoints = false;
	public bool stoppedIncreasingPoints = false;
	
	public int strokePointsToGainHappyPoints = 10000;
	public int happyPointsGainedFromStroking = 100;
	public bool isHappyFromStroking = false;
		
	void Start() {
		use = this;
	}
	
	public void incStrokePoints() {
		strokePoints += (int) (Time.deltaTime * 1000);
		
		if(strokePoints >= strokePointsToGainHappyPoints) {
			isHappyFromStroking = true;
			happyPoints += happyPointsGainedFromStroking;
			isIncreasingPoints = true;
			strokePoints = 0;
		}
	}
	
	public void incHappyPoints(int points) {
		happyPoints += points;
		isIncreasingPoints = true;
	}
	
	public SerialisableDictionary<string, iKittenState> getSerialisableParty() {
		SerialisableDictionary<string, iKittenState> partyStats = new SerialisableDictionary<string, iKittenState>();
		foreach(iKittenModel member in GameObject.FindObjectsOfType(typeof(iKittenModel))) {
			iKittenState entity = member.getState();
			partyStats.Add(entity.name, entity);
		}
		
		return partyStats;
	}
	
	public void loadSerialisedParty(SerialisableDictionary<string, iKittenState> serialisedParty) {
		int iKittenNumber = 0;
		foreach(KeyValuePair<string, iKittenState> kitten in serialisedParty) {
			GameObject iKitten = (GameObject) GameObject.Instantiate((GameObject) Resources.Load("iKitten/iKitten"));
			iKitten.transform.position += new Vector3(-1*iKittenNumber,0,0);
			iKitten.GetComponent<iKittenModel>().setState(kitten.Value);
			iKitten.GetComponentInChildren<Renderer>().material = (Material) Resources.Load("iKitten/Materials/"+kitten.Value.materialName);
			CameraManager.use.setCameraToFollow(iKitten);
			iKitten.GetComponent<iKittenModel>().setupNeeds();
			iKitten.GetComponent<iKittenModel>().passModelToState();
			iKittenNumber++;
		}
	}
}
