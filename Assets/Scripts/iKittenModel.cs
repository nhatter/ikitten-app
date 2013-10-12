using UnityEngine;
using System.Collections;

public class iKittenModel : MonoBehaviour {
	public static iKittenModel use;

	public iKittenState state = new iKittenState();
	
	public bool isEating = false;
	public bool isIdle = true;
	public bool isPlayerInteracting = false;
	public bool haveCriticalNeed = false;
	
	Animator animator;
	AnimatorStateInfo stateInfo;
	iKittenSounds sounds;
	WaypointController waypointController;
	
	GameObject mouthObjectPlaceholder;
	GameObject ballPlaceholder;
	GameObject food;
	GameObject eatLocation;
	
	public float timer = 0.0f;
	public float hungerAlertTimer = 0.0f;
	bool queueTimerReset = false;
	
	public int idleNameHash = Animator.StringToHash("Base.A_idle");
	
	GameObject ball;
	Ball ballState;
	public bool isChasingBall = false;
	public bool isBallInMouth = false;
	public float chaseBallReactionTime = 1.0f;
	public float distanceToCatchBall = 0.01f;
	public float chaseBallReactionTimer = 0;
	public Vector3 ballInMouthOffset = new Vector3(0,0,0);
	public float chasingDistance = 2.0f;
	
	public bool isRunning = false;
	public float runSpeed = 2.0f;
	float runSoundTimer = 0;
	public float runSoundTime = 0.2f;
	public float waypointLookTime = 1.0f;
	
	public bool isStroking = false;
	public float strokeAngleX = 0;
	public float maxStrokeAngleX = 35;
	public float minStrokeAngleX = -35;
	public float strokeAngleZ = 0;
	public float maxStrokeAngleZ = 35;
	public float minStrokeAngleZ = -35;
	public float notStrokingTimer = 0;
	public float timeToStopStroking = 3;
	public bool isStrokingBegan = false;
	public bool isHappyFromStroking = false;
	
	Transform head;

	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
		waypointController = GetComponent<WaypointController>();
		ball = GameObject.Find ("WoolBall");
		ballState = ball.GetComponent<Ball>();
		mouthObjectPlaceholder = GameObject.Find ("MouthObjectPlaceholder");
		ballPlaceholder = GameObject.Find("WoolBallPlaceholder");
		food = GameObject.Find("iKittyFood");
		eatLocation = GameObject.Find("EatLocation");
		head = ComponentUtils.FindTransformInChildren(this.gameObject, "cu_cat_head");
		if(head == null) {
			Debug.Log ("No kitten head found!");
		}
		use = this;
	}
	
	// Update is called once per frame
	void Update () {
		timer += Time.deltaTime;
		
		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		isIdle = (stateInfo.nameHash == Animator.StringToHash("Base.A_idle"));
		
		#if UNITY_IPHONE || UNITY_ANDROID
		if(animator.GetBool("Lick")) {
			Handheld.Vibrate();
		}
		#endif
		
		if(isRunning) {
			animator.SetBool("Run", true);
			animator.SetBool("Idle", false);
			
			if(isChasingBall) {
				chaseBallReactionTimer += Time.deltaTime;
				
				if(chaseBallReactionTimer > chaseBallReactionTime) {
					waypointController.addWaypoint(ball.transform.position);
					waypointController.MoveToWaypoint();
					chaseBallReactionTimer = 0;
				}
			}	
				
			if(runSoundTimer > runSoundTime) {
				runSoundTimer = 0;
			}
			
			if(runSoundTimer == 0) {
				audio.PlayOneShot(sounds.runSound);
			}
			
			runSoundTimer += Time.deltaTime;
		}
		
		if(ballState.isMoving && !isChasingBall && isIdle && animator.GetBool("Idle") && (!haveCriticalNeed || state.fun.need < iKittenNeed.levelToStartMeetingNeed) && !isStroking) {
			if(Vector3.Distance(ball.transform.position, this.gameObject.transform.position) > chasingDistance) {
				chaseBall();
			}
		}
		
		if(!isIdle && !animator.GetBool("Idle") && !isRunning) {
			isPlayerInteracting = false;
			animator.SetBool("Idle", true);
			Debug.Log ("Kitten is now idle");
		}
		
		if(isStroking) {
			notStrokingTimer = 0;
			iKittenSounds.use.purr();
			isStrokingBegan = true;
		} else {
			if(isStrokingBegan) {
				notStrokingTimer += Time.deltaTime;
				strokeAngleX = Mathf.LerpAngle(strokeAngleX, 0, 0.01f);
				strokeAngleZ = Mathf.LerpAngle(strokeAngleZ, 0, 0.01f);
				animator.SetBool("Meow", false);
				animator.SetBool("Lick", false);
			}
		}
		
		isStroking = false;
		
		if(notStrokingTimer > timeToStopStroking) {
			Debug.Log("Stopped stoking kitten");
			animator.SetBool("Stroke", false);
			iKittenSounds.use.stop();
			notStrokingTimer = 0;
			isStrokingBegan = false;
			PlayerModel.use.isHappyFromStroking = false;
			PlayerModel.use.strokePoints = 0;
			PlayerModel.use.stoppedIncreasingPoints = true;
		} else {
			if(isStrokingBegan) {
				head.rotation = Quaternion.Euler(new Vector3(strokeAngleX, 0, strokeAngleZ));
			}
		}
		
	} // End of Update
	
	public iKittenState getState() {
		return state;
	}
	
	public void catchBall() {
		//ball.rigidbody.velocity = Vector3.zero;
		isChasingBall = false;
		audio.Stop();
		pickupBall();
		Debug.Log("Kitten caught the ball");
	}
	
	public void chaseBall() {
		isChasingBall = true;
		isRunning = true;
		waypointController.setMoveSpeed(runSpeed);
		waypointController.setLookTime(waypointLookTime);
		waypointController.addWaypoint(ball.transform.position);
		waypointController.addWaypoint(ball.transform.position);
		waypointController.MoveToWaypoint();
	}
	
	public void pickupBall() {
		ball.rigidbody.isKinematic = true;
		ball.transform.parent = mouthObjectPlaceholder.transform;
		ball.transform.localPosition = Vector3.zero;
		isBallInMouth = true;
	}
	
	public void dropBall() {
		Debug.Log ("Kitten dropped ball");
		ball.transform.parent = null;
		ball.rigidbody.isKinematic = false;
		ball.rigidbody.velocity = Vector3.zero;
		isBallInMouth = false;
		animator.SetBool("Run",false);
		animator.SetBool("Idle",true);
		ballState.isMoving = false;
		isRunning = false;
	}
		
	void OnTriggerStay(Collider other) {
		if(other.gameObject == ball && isChasingBall && !isBallInMouth) {
			waypointController.clearWaypoints();
			catchBall();
			//iTween.StopByName("waypointController");
			waypointController.addWaypoint(ballPlaceholder.transform.position);
			waypointController.setOnCompleteAction(dropBall);
			waypointController.MoveToWaypoint();
		}
	}
	
	void OnTriggerExit(Collider other) {
		
	}
}
