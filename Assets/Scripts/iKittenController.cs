using UnityEngine;

using System;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public float touchDistance = 2.0f;
	public float touchStrokeScale = 0.1f;
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
	
	float inputX;
	float inputY;
	Vector2 touchDeltaPosition;
	Touch touch;
	
	Vector3 ballForce;
	Vector3 ballAppliedForce;
	
	Vector3 cameraPos;
	
	// Use this for initialization
	void Start () {
		iKittyFood = GameObject.Find("iKittyFood");
	}
	
	
	// Update is called once per frame
	void LateUpdate () {
		cameraPos = Camera.main.transform.position;
		
		if(Input.GetKeyDown(KeyCode.Escape)) {
			try {
				SaveDataModel.save("iKitten.xml");
			} catch(Exception e) {
				Debug.Log ("Could not save the game because "+e);
			}
			Application.Quit();
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
		
			
			if(Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out touchHitInfo, touchDistance, touchLayerMask)) {
				Debug.Log("Touch hit "+touchHitInfo.collider.gameObject.name);
				touchedObject = touchHitInfo.collider.gameObject;
				
				if(touchedObject.layer == LayerMask.NameToLayer("iKitten")) {
					touchediKitten = touchedObject.transform.root.gameObject;

					Debug.Log ("touched kitten "+touchediKitten.name);
					model = touchediKitten.GetComponent<iKittenModel>();
					animator = touchediKitten.GetComponent<Animator>();
					sounds = touchediKitten.GetComponent<iKittenSounds>();
					waypointController = touchediKitten.GetComponent<WaypointController>();
				}
				
				if(touchedObject == iKittyFood) {
					Food.use.refillFood();
				}

				if(touchedObject.name == "Mouth") {
					animator.SetBool("Meow", false);
					animator.SetBool("Lick", true);
					animator.SetBool("Idle", false);
					model.isIdle = false;
					model.isStroking = true;
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
					animator.SetBool("Idle", false);
					animator.SetBool("Stroke", true);
					model.strokeAngleX += -inputY * touchStrokeScale;
					
					if(model.strokeAngleX > model.maxStrokeAngleX) {
						model.strokeAngleX = model.maxStrokeAngleX;
					}
					
					if(model.strokeAngleX < model.minStrokeAngleX) {
						model.strokeAngleX = model.minStrokeAngleX;
					}
					
					model.isStroking = true;
					model.notStrokingTimer = 0;
					PlayerModel.use.incStrokePoints();
				}
				
				if(touchedObject.name == "HeadSide") {
					animator.SetBool("Idle", false);
					animator.SetBool("Stroke", true);
					model.strokeAngleZ += -inputY * touchStrokeScale;
					
					if(model.strokeAngleZ > model.maxStrokeAngleZ) {
						model.strokeAngleZ = model.maxStrokeAngleZ;
					}
					
					if(model.strokeAngleZ < model.minStrokeAngleZ) {
						model.strokeAngleZ = model.minStrokeAngleZ;
					}
					
					model.isStroking = true;
					model.notStrokingTimer = 0;
					PlayerModel.use.incStrokePoints();
				}
			}	
		}
	}
}
