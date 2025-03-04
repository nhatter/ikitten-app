﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerModel : MonoBehaviour {
	public static PlayerModel use;
	
	public PlayerModelState state = new PlayerModelState();
	public bool isIncreasingPoints = false;
	public bool stoppedIncreasingPoints = false;
	public int strokePoints = 0;

	public int strokePointsToGainHappyPoints = 10000;
	public int happyPointsGainedFromStroking = 100;
	public bool isHappyFromStroking = false;
		
	void Start() {
		DontDestroyOnLoad(this);
		if(use == null ) { 
			use = this;
		}
	}
	
	public void incStrokePoints() {
		strokePoints += (int) (Time.deltaTime * 1000);
		
		if(strokePoints >= strokePointsToGainHappyPoints) {
			isHappyFromStroking = true;
			state.happyPoints += happyPointsGainedFromStroking;
			isIncreasingPoints = true;
			strokePoints = 0;
		}
	}
	
	public void incHappyPoints(int points) {
		Debug.Log("Adding "+points+" points to player score.");
		state.happyPoints += points;
		isIncreasingPoints = true;
	}
	
	public SerialisableDictionary<string, iKittenState> getSerialisableParty() {
		SerialisableDictionary<string, iKittenState> partyStats = new SerialisableDictionary<string, iKittenState>();
		foreach(iKittenModel member in GameObject.FindObjectsOfType(typeof(iKittenModel))) {
			iKittenState entity = member.getState();
			entity.position = member.gameObject.transform.position;
			entity.materialName = getMaterialName(member.gameObject);
			entity.animationState = AnimationUtils.getEnabledBool(member.animator, iKittenState.ANIMATION_STATES);
			entity.position = member.gameObject.transform.position;
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
			iKitten.GetComponent<iKittenModel>().cacheGameObjectRefs();
			iKitten.GetComponent<iKittenModel>().setupNeeds();
			iKitten.GetComponent<iKittenModel>().passModelToState();
			AnimationUtils.disableAllStates(iKitten.GetComponent<iKittenModel>().animator, iKittenState.ANIMATION_STATES);
			iKitten.GetComponent<iKittenModel>().animator.SetBool(kitten.Value.animationState, true);
			iKitten.transform.position = iKitten.GetComponent<iKittenModel>().getState().position;
			iKittenNumber++;
		}
	}
	
	string getMaterialName(GameObject gameObj) {
		string materialName = gameObj.GetComponentInChildren<Renderer>().material.name;
		return materialName.Replace(" (Instance)", "");
	}
}
