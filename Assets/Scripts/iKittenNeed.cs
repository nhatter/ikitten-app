using UnityEngine;
using System;
using System.Collections;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

[Serializable]
public class iKittenNeed {
	public static int MAX_SATISFACTION = 10;
	public static float ALERT_TIME_SCALE = 2.0f;
	
	private float timeTilNeedIncrease = 5.0f;
	private float timeTilNeedDecrease = 5.0f;
	private float timeTilMeow = 10.0f;
	private float minTimeTilMeow = 1.0f;
	
	public static int levelToStartMeetingNeed = 3;
	
	public string needName;
	public int need = 10;
	public int resourceLevel = 10;
	public bool isResourceRequired = false;
	public float timer = 0;
	public bool isMovingToMeetNeed = false;
	public bool isAtLocationToMeetNeed = false;
	public bool isMeetingNeed = false;
	public float needAlertTimer = 0;
	
	private string needMetAnimationStateName;
	private GameObject needObjectTrigger;
	private GameObject needObject;
	
	private iKittenModel model;
	private iKittenSounds sounds;
	private Animator animator;
	private WaypointController waypointController;
	private AudioSource audio;
	private bool queueTimerReset = false;
	
	public iKittenNeed() {
		// For serialisation
	}
	
	public iKittenNeed(string name, string animationState, int level) {
		this.needName = name;
		this.needMetAnimationStateName = animationState;
		this.need = level;
	}
	
	public iKittenNeed(string name, string animationState, int level, bool resourceRequired) {
		this.needName = name;
		this.needMetAnimationStateName = animationState;
		this.need = level;
		this.isResourceRequired = resourceRequired;
	}
	
	public iKittenNeed(string name, int level) {
		this.needName = name;
		this.need = level;
	}
	
	// Update is called once per frame
	public void handleNeed() {
		if(isMeetingNeed && (resourceLevel > 0 || !isResourceRequired)) {
			if(timer >= timeTilNeedIncrease) {
				Food.use.moveFoodDown();
				need++;
				queueTimerReset = true;
			}
		} else {
			if(isMeetingNeed) {
				audio.Stop();
				audio.loop = false;
				isMeetingNeed = false;
				if(needMetAnimationStateName != "") {
					animator.SetBool(needMetAnimationStateName, isMeetingNeed);
				}
			}
			
			if(timer >= timeTilNeedDecrease) {
				need--;
				queueTimerReset = true;
			}
		}
		
		if(need <= levelToStartMeetingNeed && model.isIdle && !isAtLocationToMeetNeed && !isMovingToMeetNeed && !isMeetingNeed) {
			waypointController.clearWaypoints();
			waypointController.addWaypoint(needObjectTrigger.transform.position);
			waypointController.MoveToWaypoint();
			waypointController.setFinalLookTarget(needObject.transform.position);
			waypointController.setOnCompleteAction(setMovedToMeetNeed);
			isMovingToMeetNeed = true;
		}
		
		if(need == MAX_SATISFACTION && isMeetingNeed) {
			isMeetingNeed = false;
			audio.Stop();
			audio.loop = false;
			if(needMetAnimationStateName != "") {
				animator.SetBool(needMetAnimationStateName, false);
				animator.SetBool("Idle", true);
			}
		}
		
		if(queueTimerReset) {
			timer = 0;
			queueTimerReset = false;
		}
	}
	
	void setMovedToMeetNeed() {
		isMovingToMeetNeed = false;
		model.isRunning = false;
		if(needMetAnimationStateName != "") {
			animator.SetBool("Run", false);
			animator.SetBool("Idle", true);
		}
	}
	
	public void meetNeed() {
		isMeetingNeed = true;
		animator.SetBool(needMetAnimationStateName, true);
		animator.SetBool("Idle", false);
		animator.SetBool("Meow", false);
		audio.clip = sounds.purrSound;
		audio.loop = true;
		audio.Play();
	}
	
	public void needLocation(Collider other) {
		if(other.gameObject == needObjectTrigger && !isMeetingNeed) {
			isAtLocationToMeetNeed = true;
			if(need <= levelToStartMeetingNeed) {
				if(need <= levelToStartMeetingNeed && needAlertTimer >= timeTilMeow & model.isIdle) {
					animator.SetBool("Meow", true);
					sounds.randomMeow();
					needAlertTimer = 0;
				} else {
					needAlertTimer += Time.deltaTime;
				}
				
				if(resourceLevel > 0 || !isResourceRequired) {
					meetNeed();
				} else {
					if(need > 0) {
						timeTilMeow =need*ALERT_TIME_SCALE;
					} else {
						timeTilMeow = minTimeTilMeow;
					}
				}
			}
		}
	}
}
