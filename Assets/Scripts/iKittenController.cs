using UnityEngine;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public float touchDistance = 2.0f;
	float swipeSpeed = 0.1F;
	
	Animator animator;
	iKittenModel model;
	iKittenSounds sounds;
	AnimatorStateInfo stateInfo;
	WaypointController waypointController;
	RaycastHit touchHitInfo;
	GameObject touchedObject;
	
	float inputX;
	float inputY;
	Vector2 touchDeltaPosition;
	Touch touch;
	
	Vector3 ballForce;
	Vector3 ballAppliedForce;
	
	Vector3 cameraPos;
	
	// Use this for initialization
	void Start () {
		model = GetComponent<iKittenModel>();
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
		waypointController = GetComponent<WaypointController>();
	}
	
	// Update is called once per frame
	void Update () {
		cameraPos = Camera.main.transform.position;
		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		if(!model.isIdle && !animator.GetBool("Idle") && !model.isRunning) {
			model.isPlayerInteracting = false;
			animator.SetBool("Idle", true);
			Debug.Log ("Kitten is now idle");
		}
		
		if(Input.GetMouseButtonDown(0) || Input.touchCount > 0) {
			
			#if UNITY_EDITOR
		   		inputY = -20+Random.value*40;
				inputX = -20+Random.value*40;
			#else
			if(Input.GetTouch(0).phase == TouchPhase.Moved) {
				touch = Input.GetTouch(0);
				touchDeltaPosition = touch.deltaPosition;						 
		   		inputX = touchDeltaPosition.x;
		   		inputY = touchDeltaPosition.y;
			} else {
				inputX = 0;
				inputY = 0;
			}
			#endif
			
			if(Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out touchHitInfo, touchDistance)) {
				//Debug.Log(touchHitInfo.collider.gameObject.name);
				touchedObject = touchHitInfo.collider.gameObject;
				
				if(touchedObject == Food.use.gameObject) {
					Food.use.refillFood();
					model.isIdle = false;
				}
				
				if(model.isIdle && animator.GetBool("Idle")) {
					if(touchedObject.name == "cu_cat_tongue") {
						animator.SetBool("Meow", false);
						animator.SetBool("Lick", true);
						animator.SetBool("Idle", false);
						audio.PlayOneShot(sounds.lickSound);
						model.isIdle = false;
						model.timer = 0;
					}
					
					if(touchedObject == this.gameObject) {
						animator.SetBool("Meow", false);	
						animator.SetBool("Meow", true);
						animator.SetBool("Idle", false);
						sounds.randomMeow();
						model.isIdle = false;
						model.timer = 0;
					}	
					
					if(touchedObject.name == "WoolBall") {
					    Debug.Log("X, Y: " + touchDeltaPosition.x	+ ", " + touchDeltaPosition.y);
						ballForce = new Vector3(-inputX, 0, -inputY);
						Debug.Log ("Ball force: "+ ballForce.x+","+ballForce.y+","+ballForce.z);
						touchedObject.rigidbody.AddForce(ballForce * 50);
						touchedObject.GetComponent<Ball>().isMoving = true;
					}
				}
			}
		} else {
			animator.SetBool("Meow", false);
			animator.SetBool("Lick", false);
		}
	}
}
