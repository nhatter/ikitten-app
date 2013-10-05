using UnityEngine;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public float touchDistance = 2.0f;
	public float touchStrokeScale = 0.1f;
	public LayerMask touchLayerMask;
	float swipeSpeed = 0.1F;
	
	Animator animator;
	iKittenModel model;
	iKittenSounds sounds;
	AnimatorStateInfo stateInfo;
	WaypointController waypointController;
	RaycastHit touchHitInfo;
	GameObject touchedObject;
	GameObject iKittyFood;
	public Transform iKittyHead;
	
	float inputX;
	float inputY;
	Vector2 touchDeltaPosition;
	Touch touch;
	
	Vector3 ballForce;
	Vector3 ballAppliedForce;
	
	Vector3 cameraPos;
	
	float strokeAngleX = 0;
	public float maxStrokeAngleX = 35;
	public float minStrokeAngleX = -35;
	float strokeAngleZ = 0;
	public float maxStrokeAngleZ = 35;
	public float minStrokeAngleZ = -35;
	float notStrokingTimer = 0;
	float timeToStopStroking = 3;
	
	// Use this for initialization
	void Start () {
		model = GetComponent<iKittenModel>();
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
		waypointController = GetComponent<WaypointController>();
		iKittyFood = GameObject.Find("iKittyFood");
	}
	
	
	// Update is called once per frame
	void LateUpdate () {
		cameraPos = Camera.main.transform.position;
		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		if(Input.GetKeyDown(KeyCode.Escape)) {
			Application.Quit();
		}
		
		if(!model.isIdle && !animator.GetBool("Idle") && !model.isRunning) {
			model.isPlayerInteracting = false;
			animator.SetBool("Idle", true);
			Debug.Log ("Kitten is now idle");
		}
		
		iKittenModel.use.isStroking = false;
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
				
				if(touchedObject == iKittyFood) {
					Food.use.refillFood();
					model.isIdle = false;
				}

				if(touchedObject.name == "Mouth") {
					animator.SetBool("Meow", false);
					animator.SetBool("Lick", true);
					animator.SetBool("Idle", false);
					model.isIdle = false;
					model.timer = 0;
					iKittenModel.use.isStroking = true;
					notStrokingTimer = 0;
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
					strokeAngleX += -inputY * touchStrokeScale;
					
					if(strokeAngleX > maxStrokeAngleX) {
						strokeAngleX = maxStrokeAngleX;
					}
					
					if(strokeAngleX < minStrokeAngleX) {
						strokeAngleX = minStrokeAngleX;
					}
					
					iKittenModel.use.isStroking = true;
					notStrokingTimer = 0;

				}
				
				if(touchedObject.name == "HeadSide") {
					animator.SetBool("Idle", false);
					animator.SetBool("Stroke", true);
					strokeAngleZ += -inputY * touchStrokeScale;
					
					if(strokeAngleZ > maxStrokeAngleZ) {
						strokeAngleZ = maxStrokeAngleZ;
					}
					
					if(strokeAngleZ < minStrokeAngleZ) {
						strokeAngleZ = minStrokeAngleZ;
					}
					
					iKittenModel.use.isStroking = true;
					notStrokingTimer = 0;
				}
			}
			
		} else {
			animator.SetBool("Meow", false);
			animator.SetBool("Lick", false);
		}
		
		if(iKittenModel.use.isStroking) {
			notStrokingTimer = 0;
			iKittenSounds.use.purr();
		} else {
			//Debug.Log("Timer: "+notStrokingTimer);
			notStrokingTimer += Time.deltaTime;
			strokeAngleX = Mathf.LerpAngle(strokeAngleX, 0, 0.01f);
			strokeAngleZ = Mathf.LerpAngle(strokeAngleZ, 0, 0.01f);
		}
		
		iKittyHead.rotation = Quaternion.Euler(new Vector3(strokeAngleX, 0, strokeAngleZ));
						
		if(notStrokingTimer > timeToStopStroking) {
			animator.SetBool("Stroke", false);
			iKittenSounds.use.stop();
			notStrokingTimer = 0;
		}
	}
}
