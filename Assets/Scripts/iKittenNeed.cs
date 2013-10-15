using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

public class iKittenNeed : MonoBehaviour {
	public static int MIN_SATISFACTION = 1;
	public static int MAX_SATISFACTION = 10;
	public static float ALERT_TIME_SCALE = 2.0f;
	
	public iKittenNeedState state = new iKittenNeedState();
	
	public float timeTilNeedIncrease = 5.0f;
	public float timeTilNeedDecrease = 5.0f;
	private float timeTilMeow = 10.0f;
	private float minTimeTilMeow = 1.0f;

	public bool isResourceRequired = false;
	public bool requiresPlayerToMeetNeed = false;
	
	public static int levelToStartMeetingNeed = 3;
	public static iKittenNeed deficientNeed;
	
	public string needMetAnimationStateName;
	private GameObject needObjectTrigger;
	private GameObject needObject;
	
	private iKittenModel model;
	private bool queueTimerReset = false;
	
	private bool isNeedLocationActionSet = false;
	private Action atNeedLocationAction = delegate(){};
	private bool isNeedIncreasedActionSet = false;
	private Action needIncreasedAction = delegate(){};
	
	private float needIncTimer = 0;
	
	// Update is called once per frame
	public void handleNeed() {
		state.timer += Time.deltaTime;
		
		if(state.isMeetingNeed && (state.resourceLevel > 0 && isResourceRequired || !isResourceRequired)) {
			if(state.timer >= timeTilNeedIncrease) {
				if(isNeedIncreasedActionSet) {
					needIncreasedAction();
				}
				state.need++;
				queueTimerReset = true;
			}
		} else {
			if(state.isMeetingNeed) {
				stopMeetingNeed();
			}
			
			if(state.timer >= timeTilNeedDecrease && state.need > MIN_SATISFACTION && !state.isMeetingNeed) {
				state.need--;
				queueTimerReset = true;
			}
		}
		
		
		if(state.need <= levelToStartMeetingNeed) {
			if(needObjectTrigger != null) {
				if(deficientNeed == this && model.isIdle && !state.isAtLocationToMeetNeed && !state.isMovingToMeetNeed && !state.isMeetingNeed) {
					Debug.Log ("Kitten is moving to meet need");
					model.isRunning = true;
					model.waypointController.clearWaypoints();
					model.waypointController.addWaypoint(needObjectTrigger.transform.position);
					model.waypointController.MoveToWaypoint();
					model.waypointController.setFinalLookTarget(needObject.transform.position);
					if(!isNeedLocationActionSet) {
						model.waypointController.setOnCompleteAction(setMovedToMeetNeed);
					}
					
					state.isMovingToMeetNeed = true;
				}
			}
			
			setThisAsDeficientNeed();
		}
	
		
		if(state.isMeetingNeed) {
			if(state.need > levelToStartMeetingNeed) {
				deficientNeed = null;
			}	
			
			if(state.need == MAX_SATISFACTION) {
				resetNeed();
				model.audio.Stop();
				model.audio.loop = false;
				if(needMetAnimationStateName != "") {
					model.animator.SetBool(needMetAnimationStateName, false);
					model.animator.SetBool("Idle", true);
				}
			}
		}
		
		if(queueTimerReset) {
			state.timer = 0;
			queueTimerReset = false;
		}
	}
	
	public void setMovedToMeetNeed() {
		Debug.Log("Kittne has moved to need location");
		model.isRunning = false;
		if(needMetAnimationStateName != "") {
			model.animator.SetBool("Run", false);
			model.animator.SetBool("Idle", true);
		}
	}
	
	public void meetNeed() {
		if(!state.isMeetingNeed) {
			state.isMeetingNeed = true;
			model.animator.SetBool(needMetAnimationStateName, true);
			model.animator.SetBool("Idle", false);
			model.animator.SetBool("Meow", false);
			model.audio.clip = model.sounds.purrSound;
			model.audio.loop = true;
			model.audio.Play();
		}
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
			Debug.Log(other.name+" is other object.");

			if(other.gameObject == needObjectTrigger && !state.isMeetingNeed && deficientNeed == this) {
				state.isAtLocationToMeetNeed = true;
				if(isNeedLocationActionSet) {
					atNeedLocationAction();
				}
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
			setThisAsDeficientNeed();
			
			if(deficientNeed == this) {
				if(state.need <= levelToStartMeetingNeed && state.needAlertTimer >= timeTilMeow & model.isIdle) {
					model.animator.SetBool("Meow", true);
					model.sounds.randomMeow();
					state.needAlertTimer = 0;
				} else {
					state.needAlertTimer += Time.deltaTime;
				}
				
				if(state.resourceLevel > 0 && isResourceRequired || (!isResourceRequired && !requiresPlayerToMeetNeed)) {
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
	}
	
	public void setNeedObjectTrigger(GameObject trigger) {
		needObjectTrigger = trigger;
	}
	
	public void setNeedObject(GameObject obj) {
		needObject = obj;
	}
	
	public void setNeedIncreasedAction(Action newAction) {
		isNeedIncreasedActionSet = true;
		needIncreasedAction = newAction;
	}
	
	public void setAtNeedLocationAction(Action newAction) {
		atNeedLocationAction = newAction;
		isNeedLocationActionSet = true;
	}
	
	public void inc() {
		if(!state.isMeetingNeed) {
			meetNeed();
		}	
			
		needIncTimer += Time.deltaTime;
		if(needIncTimer >= timeTilNeedIncrease) {
			if(state.need < MAX_SATISFACTION) {
				state.need++;
			}
			PlayerModel.use.incHappyPoints(100);
			needIncTimer = 0;
		}
	}
	
	public void dec() {
		if(state.need < MIN_SATISFACTION) {
			state.need--;
		}
	}
	
	void setThisAsDeficientNeed() {
		if(deficientNeed == null) {
			deficientNeed = this;
		}
	}
	
	public void setModel(iKittenModel newModel) {
		this.model = newModel;
	}
	
	void resetNeed() {
		state.isAtLocationToMeetNeed = false;
		state.isMovingToMeetNeed = false;
		state.isMeetingNeed = false;
	}
}
