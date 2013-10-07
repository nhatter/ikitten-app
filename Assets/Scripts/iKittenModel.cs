using UnityEngine;
using System.Collections;

public class iKittenModel : MonoBehaviour {
	public static iKittenModel use;
	
	public int MAX_SATISFACTION = 10;
	public float FEED_ALERT_TIME_SCALE = 2.0f;
	
	public iKittenState state = new iKittenState();
	
	public float timeTilSatiationIncrease = 5.0f;
	public float timeTilSatiationDecrease = 5.0f;
	public float levelToStartEating = 3.0f;
	public float timeTilSatiationMeow = 10.0f;
	public float minTimeTilSatiationMeow = 1.0f;
	
	public bool isEating = false;
	public bool isIdle = true;
	
	public bool isPlayerInteracting = false;
	
	Animator animator;
	AnimatorStateInfo stateInfo;
	iKittenSounds sounds;
	WaypointController waypointController;
	
	GameObject mouthObjectPlaceholder;
	GameObject ballPlaceholder;
	GameObject food;
	public bool isMovingToFood = false;
	public bool isAtFoodLocation = false;
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
		
		if(isEating && Food.use.foodLevel > 0) {
			if(timer >= timeTilSatiationIncrease) {
				Food.use.moveFoodDown();
				state.satiation++;
				queueTimerReset = true;
			}
		} else {
			if(isEating) {
				audio.Stop();
				audio.loop = false;
				isEating = false;
				animator.SetBool("Eat", isEating);
			}
			
			if(timer >= timeTilSatiationDecrease) {
			state.satiation--;
				queueTimerReset = true;
			}
		}
		
		if(state.satiation <= levelToStartEating && isIdle && !isAtFoodLocation && !isMovingToFood && !isEating) {
			waypointController.clearWaypoints();
			waypointController.addWaypoint(eatLocation.transform.position);
			waypointController.MoveToWaypoint();
			waypointController.setFinalLookTarget(food.transform.position);
			waypointController.setOnCompleteAction(setMovedToFood);
			isMovingToFood = true;
			iKittenModel.use.isStroking = true;
		}
		
		if(state.satiation == MAX_SATISFACTION && isEating) {
			isEating = false;
			audio.Stop();
			audio.loop = false;
			animator.SetBool("Eat", isEating);
			animator.SetBool("Idle", true);
		}
		
		if(queueTimerReset) {
			timer = 0;
			queueTimerReset = false;
		}
		
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
		
		if(ballState.isMoving && !isChasingBall && isIdle && animator.GetBool("Idle") && state.satiation > levelToStartEating && !isStroking) {
			if(Vector3.Distance(ball.transform.position, this.gameObject.transform.position) > chasingDistance) {
				chaseBall();
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
	
	public void eat() {
		isEating = true;
		isAtFoodLocation = true;
		animator.SetBool("Eat", isEating);
		animator.SetBool("Idle", false);
		audio.clip = sounds.purrSound;
		audio.loop = true;
		audio.Play();
	}
	
	public void setMovedToFood() {
		isMovingToFood = false;
		isRunning = false;
		animator.SetBool("Run", false);
		animator.SetBool("Idle", true);
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
		
		if(other.gameObject == eatLocation && !isEating) {
			isAtFoodLocation = true;
			if(state.satiation <= levelToStartEating) {
				if(Food.use.foodLevel > 0) {
					eat();
				} else {
					if(state.satiation > 0) {
						timeTilSatiationMeow =state.satiation*FEED_ALERT_TIME_SCALE;
					} else {
						timeTilSatiationMeow = minTimeTilSatiationMeow;
					}
				}
				
				if(state.satiation <= levelToStartEating && hungerAlertTimer >= timeTilSatiationMeow & isIdle) {
					animator.SetBool("Meow", true);
					sounds.randomMeow();
					hungerAlertTimer = 0;
				} else {
					hungerAlertTimer += Time.deltaTime;
				}
			}
		}
	}
	
	void OnTriggerExit(Collider other) {
		if(other.gameObject == eatLocation && !isEating) {
			isAtFoodLocation = false;
		}
	}
}
