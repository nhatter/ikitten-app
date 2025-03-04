﻿using UnityEngine;

using System;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public static iKittenController use;
	public float strokingDistance = 1.5f;
	public float touchDistance = 2.0f;
	public float touchStrokeScale = 0.1f;
	public float accelerometerSensitivity = 50.0f;
	public float moveLightBlobSpeed = 10.0f;

	public LayerMask touchLayerMask;
	float swipeSpeed = 0.1F;
	
	Animator animator;
	iKittenModel model;
	iKittenSounds sounds;
	WaypointController waypointController;
	RaycastHit touchHitInfo;
	GameObject touchedObject;
	GameObject touchediKitten;
	GameObject iKittyFood;
	GameObject lightBlob;
	GameObject suggestionBoard;
	GameObject foodBox;
	Vector3 foodBoxLocation;
	Vector3 foodBoxUseLocation;
	
	float inputX;
	float inputY;
	Vector2 touchDeltaPosition;
	Touch touch;
	
	Vector3 ballForce;
	Vector3 ballAppliedForce;
	
	Vector3 cameraPos;
	
	Voter voter;
	AnimatorStateInfo animationInfo;

	
	// Use this for initialization
	void Start () {
		use = this;
		iKittyFood = GameObject.Find("iKittyFood");
		lightBlob = GameObject.Find("LightBlob");
		suggestionBoard = GameObject.Find ("SuggestionBoard");
		foodBox = (GameObject)GameObject.Find("FoodBox");
		
		if(foodBox != null) {
			foodBoxLocation = foodBox.transform.position;
			foodBoxUseLocation = GameObject.Find("FoodBoxUseLocation").transform.position;
		}
	}
	
	
	// Update is called once per frame
	void LateUpdate () {
		if(iKittenGUI.use != null) {
			if(iKittenGUI.use.getMessageShowing()) {
				return;
			}
		}
		
		if(ShopView.use.isActive) {
			return;
		}
		
		if(iKittenModel.isTorchLit) {
			moveLight();
		}
		
		if(Camera.main != null) {
			cameraPos = Camera.main.transform.position;
		}
		
		if(Input.GetKeyDown(KeyCode.Escape)) {
			try {
				SaveDataModel.save(SaveDataModel.DEFAULT_SAVE_FILE);
			} catch(Exception e) {
				Debug.Log ("Could not save the game because "+e);
			}
			Application.Quit();
		}
		
		if(ShopView.use != null && SuggestionView.use != null) {
			if(ShopView.use.isActive || SuggestionView.use.isActive) {
				return;
			}
		}
		
		if(Input.GetMouseButtonDown(0) || Input.touchCount > 0) {
			
			#if UNITY_OSX_STANDALONE
		   		inputY = 10;
				inputX = -10;
			#else
			if(Input.touchCount > 0) {
				if(Input.GetTouch(0).phase == TouchPhase.Moved) {
					touch = Input.GetTouch(0);
					touchDeltaPosition = touch.deltaPosition;						 
			   		inputX = touchDeltaPosition.x;
			   		inputY = touchDeltaPosition.y;
				} else {
					inputX = 0;
					inputY = 0;
				}
			}
			#endif
		
			if(Camera.main.name == "FollowCamera") {
				if(CameraManager.use.distanceToKitten > strokingDistance) {
					iKittenModel.anyKitten.beckon();
					Debug.Log ("Beckoning kitten");
				}
			}
			
			if(Input.mousePosition.x < MobileDisplay.width - 110 && Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out touchHitInfo, touchDistance, touchLayerMask)) {
				Debug.Log("Touch hit "+touchHitInfo.collider.gameObject.name);
				touchedObject = touchHitInfo.collider.gameObject;
				
				if(touchedObject.layer == LayerMask.NameToLayer("iKitten")) {
					touchediKitten = touchedObject.transform.root.gameObject;

					Debug.Log ("touched kitten "+touchediKitten.name);
					model = touchediKitten.GetComponent<iKittenModel>();
					animator = touchediKitten.GetComponent<Animator>();
					sounds = touchediKitten.GetComponent<iKittenSounds>();
					waypointController = touchediKitten.GetComponent<WaypointController>();
					
					if(!PlayerModel.use.state.hasSelectedKitten) {
						MainSounds.use.audio.PlayOneShot(MainSounds.use.goodSound);
						FXManager.use.sparkle(model.head.transform.position+new Vector3(0,0.4f,0));
						Action adopt = delegate() { iKittenModel.adopt(touchediKitten); };
						CameraManager.use.fadeOutThen(adopt);
					}
				}
				
				if(touchedObject.name == "FoodBox") {
					Food.use.refillFood();
					MainSounds.use.audio.PlayOneShot(MainSounds.use.foodSound);
					iTween.RotateTo(foodBox, iTween.Hash("rotation",new Vector3(-35,45,0), "time", 3.0f, "onComplete", "rotateFoodBoxBack", "oncompletetarget", this.gameObject));
					iTween.MoveTo(foodBox, foodBoxUseLocation, 1.0f);
				}

				if(touchedObject.name == "Mouth") {
					animator.SetBool("Meow", false);
					animator.SetBool("Lick", true);
					animator.SetBool("Idle", false);
					model.isIdle = false;
					model.isStroking = true;
					model.isStrokingBegan = true;
					model.notStrokingTimer = 0;
				}
					
				if(touchedObject.name == "WoolBall") {
				    Debug.Log("X, Y: " + touchDeltaPosition.x	+ ", " + touchDeltaPosition.y);
					ballForce = new Vector3(-inputX, 0, -inputY);
					Debug.Log ("Ball force: "+ ballForce.x+","+ballForce.y+","+ballForce.z);
					touchedObject.rigidbody.AddForce(ballForce * 50);
					touchedObject.GetComponent<Ball>().isMoving = true;
				}
				
				if(touchedObject.name == "NoseBridge" || touchedObject.name == "Neck") {
					model.stroke(inputY, true);
				}
				
				if(touchedObject.name == "HeadSide") {
					model.stroke(inputY, false);
				}
				
				if(!iKittenModel.anyKitten.isStroking) {
					if(touchedObject.tag == "Voter") {
						Debug.Log ("Hit voter widget");
						voter = touchedObject.GetComponent<Voter>();
						Features.use.changeVote(voter.featureId, voter.voteCountToRepresent);
					}
					
					if(touchedObject.name == "SubmitVotes") {
						Debug.Log ("Hit SubmitVotes");
						Features.use.submitVotes();
					}
					
					if(touchedObject.name == "ReturnToGame") {
						CameraManager.use.disableFeatureCamera();
						suggestionBoard.collider.enabled = true;
					}
					
					if(touchedObject.name == "SuggestionBoard") {
						CameraManager.use.enableFeatureCamera();
						suggestionBoard.collider.enabled = false;
					}
					
					if(touchedObject.name == "SuggestionBox") {
						SuggestionView.use.isActive = true;
					}
					
					if(touchedObject.name == "ItemsBox") {
						ShopView.use.enable();
						
						if(ShopView.use.isActive) {
							ZoomFollowObject.use.useShopViewFOV();
						} else {
							ZoomFollowObject.use.useNormalFOV();
						}
					}
					
					if(touchedObject.name == "Torch") {
						iKittenModel.isTorchLit = !iKittenModel.isTorchLit;
				
						if(iKittenModel.isTorchLit) {
							CameraManager.use.enableTorchCamera();
							touchedObject.transform.LookAt(iKittenModel.lightBlob.transform.position);
							touchedObject.transform.Rotate(0,180,0);
							touchedObject.transform.GetComponent<FollowObject>().targetObject = iKittenModel.lightBlob;
							iKittenModel.lightBlob.GetComponentInChildren<Projector>().enabled = true;
			
							iKittenModel.chaseObject = iKittenModel.lightBlob;
							foreach(iKittenModel kittenModel in GameObject.FindObjectsOfType(typeof(iKittenModel)) ) {
								animationInfo = iKittenModel.anyKitten.animator.GetCurrentAnimatorStateInfo(0);
								
								if(animationInfo.nameHash == Animator.StringToHash("Base.A_idle")) {
									kittenModel.chase();
								}
							}
						} else {
							CameraManager.use.disableTorchCamera();
							touchedObject.transform.GetComponent<FollowObject>().targetObject = null;
							touchedObject.transform.position = iKittenModel.originalTorchPos;
							//foreach(iKittenModel kittenModel in GameObject.FindObjectsOfType(typeof(iKittenModel)) ) {
							//	kittenModel.stopChasingObject();
							//}
							iKittenModel.anyKitten.stopChasingObject();
							iKittenModel.lightBlob.GetComponentInChildren<Projector>().enabled = false;
						}
					}
				}
			}	
		}
	} // End of LateUpdate
	
	Vector3 dir = Vector3.zero;
	Vector3 cameraDir;
	public void moveLight() {
        dir.x = -Input.acceleration.y;
        dir.z = Input.acceleration.x;
        if (dir.sqrMagnitude > 1)
            dir.Normalize();
        
        dir *= Time.deltaTime;
        lightBlob.rigidbody.velocity = dir * accelerometerSensitivity * moveLightBlobSpeed;
	}
	
	public void rotateFoodBoxBack() {
		iTween.RotateTo(GameObject.Find("FoodBox"), iTween.Hash("rotation",new Vector3(0,45,0), "time", 2.0f));
		iTween.MoveTo(foodBox, foodBoxLocation, 2.0f);
	}
}
