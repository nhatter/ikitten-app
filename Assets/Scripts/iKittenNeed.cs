using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

public class iKittenNeed {
	public static int MIN_SATISFACTION = 1;
	public static int MAX_SATISFACTION = 10;
	public static float ALERT_TIME_SCALE = 2.0f;
	
	public iKittenNeedState state = new iKittenNeedState();
	
	private float timeTilNeedIncrease = 5.0f;
	private float timeTilNeedDecrease = 5.0f;
	private float timeTilMeow = 10.0f;
	private float minTimeTilMeow = 1.0f;
	private bool isResourceRequired = false;
	
	public static int levelToStartMeetingNeed = 3;
	
	private string needMetAnimationStateName;
	private GameObject needObjectTrigger;
	private GameObject needObject;
	
	private iKittenModel model;
	private bool queueTimerReset = false;
	
	private Action needIncreasedAction = delegate(){};
	
	private float needIncTimer = 0;
	public float timeToIncNeed = 3;
	
	public iKittenNeed(string name, string animationState, bool resourceRequired) {
		state.needName = name;
		this.needMetAnimationStateName = animationState;
		this.isResourceRequired = resourceRequired;
	}
	
	public iKittenNeed(string name, string animationState) : this(name, animationState, false) {
	}
	
	public iKittenNeed(string name) : this(name, "", false) {
	}
	
	// Update is called once per frame
	public void handleNeed() {
		state.timer += Time.deltaTime;
		
		if(state.isMeetingNeed && (state.resourceLevel > 0 && isResourceRequired)) {
			if(state.timer >= timeTilNeedIncrease) {
				needIncreasedAction();
				state.need++;
				queueTimerReset = true;
			}
		} else {
			if(state.isMeetingNeed && isResourceRequired) {
				stopMeetingNeed();
			}
			
			if(state.timer >= timeTilNeedDecrease && state.need > MIN_SATISFACTION && !state.isMeetingNeed) {
				state.need--;
				queueTimerReset = true;
			}
		}
		
		if(needObjectTrigger != null) {
			if(state.need <= levelToStartMeetingNeed && model.isIdle && !state.isAtLocationToMeetNeed && !state.isMovingToMeetNeed && !state.isMeetingNeed) {
				model.waypointController.clearWaypoints();
				model.waypointController.addWaypoint(needObjectTrigger.transform.position);
				model.waypointController.MoveToWaypoint();
				model.waypointController.setFinalLookTarget(needObject.transform.position);
				model.waypointController.setOnCompleteAction(setMovedToMeetNeed);
				state.isMovingToMeetNeed = true;
			}
		}
		
		if(state.need == MAX_SATISFACTION && state.isMeetingNeed && isResourceRequired) {
			state.isMeetingNeed = false;
			model.audio.Stop();
			model.audio.loop = false;
			if(needMetAnimationStateName != "") {
				model.animator.SetBool(needMetAnimationStateName, false);
				model.animator.SetBool("Idle", true);
			}
		}
		
		if(queueTimerReset) {
			state.timer = 0;
			queueTimerReset = false;
		}
	}
	
	void setMovedToMeetNeed() {
		state.isMovingToMeetNeed = false;
		model.isRunning = false;
		if(needMetAnimationStateName != "") {
			model.animator.SetBool("Run", false);
			model.animator.SetBool("Idle", true);
		}
	}
	
	public void meetNeed() {
		state.isMeetingNeed = true;
		model.animator.SetBool(needMetAnimationStateName, true);
		model.animator.SetBool("Idle", false);
		model.animator.SetBool("Meow", false);
		model.audio.clip = model.sounds.purrSound;
		model.audio.loop = true;
		model.audio.Play();
	}
	
	public void stopMeetingNeed() {
		model.audio.Stop();
		model.audio.loop = false;
		state.isMeetingNeed = false;
		if(needMetAnimationStateName != "") {
			model.animator.SetBool(needMetAnimationStateName, state.isMeetingNeed);
		}
	}
	
	public void checkIfHitNeedTrigger(Collider other) {
		if(needObjectTrigger != null) {
			if(other.gameObject == needObjectTrigger && !state.isMeetingNeed) {
				state.isAtLocationToMeetNeed = true;
				checkNeedSatisfied();
			}
		}
	}
	
	public void checkIfLeftNeedTrigger(Collider other) {
		if(needObjectTrigger != null) {
			if(other.gameObject == needObjectTrigger && !state.isMeetingNeed) {
				state.isAtLocationToMeetNeed = false;
			}
		}
	}
	
	public void checkNeedSatisfied() {
		model.animator.SetBool("Meow", false);
		if(state.need <= levelToStartMeetingNeed) {
			if(state.need <= levelToStartMeetingNeed && state.needAlertTimer >= timeTilMeow & model.isIdle) {
				model.animator.SetBool("Meow", true);
				model.sounds.randomMeow();
				state.needAlertTimer = 0;
			} else {
				state.needAlertTimer += Time.deltaTime;
			}
			
			if(state.resourceLevel > 0 && isResourceRequired) {
				meetNeed();
			} else {
				if(state.need > 0) {
					timeTilMeow = state.need*ALERT_TIME_SCALE;
				} else {
					timeTilMeow = minTimeTilMeow;
				}
			}
		}
	}
	
	public void setNeedObjectTrigger(GameObject trigger) {
		needObjectTrigger = trigger;
	}
	
	public void setNeedObject(GameObject obj) {
		needObject = obj;
	}
	
	public void setNeedIncreasedAction(Action newAction) {
		needIncreasedAction = newAction;
	}
	
	public void inc() {
		if(state.need < MAX_SATISFACTION) {
			if(!state.isMeetingNeed) {
				meetNeed();
			}	
				
			needIncTimer += Time.deltaTime;
			if(needIncTimer >= timeToIncNeed) {
				state.need++;
				needIncTimer = 0;
			}
		}
	}
	
	public void dec() {
		if(state.need < MIN_SATISFACTION) {
			state.need--;
		}
	}
	
	public void setModel(iKittenModel newModel) {
		this.model = newModel;
	}
}
