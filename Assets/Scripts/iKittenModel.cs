using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class iKittenModel : MonoBehaviour {
	public static iKittenModel anyKitten;

	private iKittenState state = new iKittenState();
	
	public bool isBeckoning = false;
	public bool isEating = false;
	public bool isIdle = true;
	public bool isPlayerInteracting = false;
	public bool haveCriticalNeed = false;
	
	public Animator animator;
	public AnimatorStateInfo stateInfo;
	public iKittenSounds sounds;
	public iKittenController controller;
	public WaypointController waypointController;
	
	public static Vector3 cameraPos;
	static float kittenLookAtCameraPosYOffset = -0.75f;
	public static float timeToLookToCamera = 1.5f;
	
	GameObject hats;
	GameObject mouthObjectPlaceholder;
	GameObject ballPlaceholder;
	public static GameObject food;
	public static GameObject eatLocation;
	public bool isAtMainLocation = false;
	GameObject bed;
	GameObject sleepLocation;
	public static GameObject itemsBox;
	Shader itemsBoxShader;
	public static GameObject torch;
	public static GameObject chaseObject;
	public static GameObject lightBlob;
	public static GameObject lightBlobCollider;
	public static Vector3 originalTorchPos;
	public static bool isTorchLit;
	
	public float hungerAlertTimer = 0.0f;
	bool queueTimerReset = false;
	
	public int idleNameHash = Animator.StringToHash("Base.A_idle");
	
	public static GameObject ball;
	Ball ballState;
	public bool isChasing = false;
	public bool isBallInMouth = false;
	public float chaseReactionTime = 1.0f;
	public float distanceToCatchBall = 0.01f;
	public float chaseReactionTimer = 0;
	public Vector3 ballInMouthOffset = new Vector3(0,0,0);
	public float chasingDistance = 2.0f;
	public bool hasCaughtChaseObject = false;
	
	public bool isRunning = false;
	public float runSpeed = 2.0f;
	float runSoundTimer = 0;
	public float runSoundTime = 0.2f;
	public float waypointLookTime = 1.0f;
	
	public bool isStroking = false;
	public float strokeAngleX = 0;
	public float maxStrokeAngleX = 35;
	public float minStrokeAngleX = -35;
	public float initialStrokeAngleX = 15;
	public float strokeAngleZ = 0;
	public float maxStrokeAngleZ = 35;
	public float minStrokeAngleZ = -35;
	public float initialStrokeAngleZ;
	public float notStrokingTimer = 0;
	public float timeToStopStroking = 3;
	public bool isStrokingBegan = false;
	public bool isHappyFromStroking = false;
	
	public float randomMeowTimer = 0;
	public float randomMeowTime;
	public static float minRandomMeowTime = 1.0f;
	public static float maxRandomMeowTime = 3.0f;
	
	public Transform head;
	
	bool ballisMoving = false;
	
	private iKittenNeed[] allNeeds;
	public iKittenNeed satiation;
	public iKittenNeed sleep;
	public iKittenNeed love;
	public iKittenNeed exercise;
	public iKittenNeed fun;
	public iKittenNeed hygiene;
	public iKittenNeed environment;
		
	// Use this for initialization
	void Start () {
		anyKitten = this;
		
		cacheGameObjectRefs();
		setupNeeds();
		passModelToState();
		
		randomMeowTime = minRandomMeowTime + Random.value*maxRandomMeowTime;
	}
	
	public void hideWornItems() {
		foreach(MeshRenderer renderer in hats.GetComponentsInChildren<MeshRenderer>()) {
			renderer.enabled = false;
		}
	}
	
	public void wearItem(string itemName) {
		GameObject itemPlaceholder = ComponentUtils.FindTransformInChildren(hats, itemName).gameObject;
		GameObject newItem = (GameObject) GameObject.Instantiate((GameObject) Resources.Load("Shop/Hats/"+itemName));
		newItem.transform.parent = hats.transform;
		newItem.transform.position = itemPlaceholder.transform.position;
		newItem.transform.localScale = itemPlaceholder.transform.localScale;

	}
	
	void prepareToSleep() {
		isRunning = false;
		animator.SetBool("Run", false);
		animator.SetBool("Jump", false);
		iTween.LookTo(this.gameObject, iTween.Hash("lookTarget", new Vector3(cameraPos.x, gameObject.transform.position.y, cameraPos.z), "lookSpeed", 3, "oncomplete", "fallSleep"));
	}
	
	void fallAsleep() {
		sleep.setMovedToMeetNeed();
		sleep.meetNeed();
		animator.SetBool("Idle", false);
	}
	
	// Update is called once per frame
	void LateUpdate () {
		cameraPos = Camera.main.transform.position;

		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		isIdle = (stateInfo.nameHash == Animator.StringToHash("Base.A_idle"));
		
		#if UNITY_IPHONE || UNITY_ANDROID
		if(animator.GetBool("Lick")) {
			Handheld.Vibrate();
		}
		#endif
		
		if(!PlayerModel.use.state.hasSelectedKitten) {
			head.LookAt(new Vector3(cameraPos.x, cameraPos.y+kittenLookAtCameraPosYOffset, cameraPos.z));
			animator.SetBool("Idle", true);
			
			if(randomMeowTimer > randomMeowTime) {
				animator.SetBool("Meow", true);
				randomMeowTimer = 0;
				randomMeowTime = minRandomMeowTime + Random.value*maxRandomMeowTime;
				sounds.randomMeow();
			} else {
				animator.SetBool("Meow", false);
			}
			
			randomMeowTimer += Time.deltaTime;
		} else {
			satiation.handleNeed();
			love.handleNeed();
			love.checkNeedSatisfied();
			fun.handleNeed();
			fun.checkNeedSatisfied();
			sleep.handleNeed();
		}
		
		if(isRunning && PlayerModel.use.state.hasSelectedKitten) {
			animator.SetBool("Run", true);
			animator.SetBool("Idle", false);
			
			if(isChasing) {
				chaseReactionTimer += Time.deltaTime;
				
				if(chaseReactionTimer > chaseReactionTime && !isBeckoning) {
					waypointController.addWaypoint(chaseObject.transform.position);
					waypointController.MoveToWaypoint();
					chaseReactionTimer= 0;
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
		
		if(chaseObject == ball && PlayerModel.use.state.hasSelectedKitten) {
			if(ballState.isMoving && stateInfo.nameHash == Animator.StringToHash("Base.A_idle") && !isChasing && isIdle && animator.GetBool("Idle") && (!haveCriticalNeed || fun.state.need < iKittenNeed.levelToStartMeetingNeed) && !isStroking) {
				if(Vector3.Distance(chaseObject.transform.position, this.gameObject.transform.position) > chasingDistance) {
					chase();
				}
			}
		}
		
		if(isChasing) {
			fun.inc();
			
			if(hasCaughtChaseObject) {
				isRunning = false;
				animator.SetBool("Run", false);
				animator.SetBool("Idle", true);
				waypointController.clearWaypoints();
				iTween.StopByName(this.gameObject, "WaypointController");
			} else {
				if(!isRunning) {
					chase();
				}
			}
			
			hasCaughtChaseObject = false;
		}
		
		if(!isIdle && !animator.GetBool("Idle") && !isRunning && !isChasing) {
			isPlayerInteracting = false;
			animator.SetBool("Idle", true);
			Debug.Log ("Kitten is now idle");
		}
		
		if(isStroking) {
			notStrokingTimer = 0;
			iKittenSounds.use.purr();
		} else {
			if(isStrokingBegan) {
				notStrokingTimer += Time.deltaTime;
				strokeAngleX = Mathf.LerpAngle(strokeAngleX, initialStrokeAngleX, 0.01f);
				strokeAngleZ = Mathf.LerpAngle(strokeAngleZ, initialStrokeAngleZ, 0.01f);
				animator.SetBool("Meow", false);
				animator.SetBool("Lick", false);
			}
		}
		
		isStroking = false;
		
		if(notStrokingTimer > timeToStopStroking) {
			Debug.Log("Stopped stoking kitten");
			animator.SetBool("Stroke", false);
			love.stopMeetingNeed();
			notStrokingTimer = 0;
			isStrokingBegan = false;
			PlayerModel.use.isHappyFromStroking = false;
			PlayerModel.use.strokePoints = 0;
			PlayerModel.use.stoppedIncreasingPoints = true;
		} else {
			if(isStrokingBegan) {
				head.localRotation = Quaternion.Euler(new Vector3(strokeAngleX, 0, strokeAngleZ));
			}
		}
		
	} // End of Update
	
	public static void adopt(GameObject kitten) {
		Debug.Log("Adopting kitten!");
		PlayerModel.use.state.hasSelectedKitten = true;
		iKittenModel.deleteOtherKittens(kitten);
		SaveDataModel.save(SaveDataModel.DEFAULT_SAVE_FILE, SceneManager.DEFAULT_SCENE);
		Application.LoadLevel("Default");
	}
		
		
	public static void deleteOtherKittens(GameObject kitten) {
		foreach(iKittenModel model in GameObject.FindObjectsOfType(typeof(iKittenModel))) {
			if(model.gameObject != kitten) {
				GameObject.DestroyImmediate(model.gameObject);
			}
		}
	}
	
	public void passModelToState() {
		foreach(iKittenNeed need in allNeeds) {
			if(need != null) {
				need.setModel(this);
			}
		}
	}
		
	public iKittenState getState() {
		return state;
	}
	
	public void setState(iKittenState newState) {
		this.state = newState;
		foreach(iKittenNeedState needState in state.needs) {
			switch(needState.needName) {
				case "Satiation":
					satiation.state = needState;
				break;
				
				case "Sleep":
					sleep.state = needState;
				break;
				
				case "Love":
					love.state = needState;
				break;
				
				case "Fun":
					fun.state = needState;
				break;
			}
		}
	}
	
	public void cacheGameObjectRefs() {
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
		waypointController = GetComponent<WaypointController>();
		ball = GameObject.Find ("WoolBall");
		if(ball != null) {
			ballState = ball.GetComponent<Ball>();
		}
		mouthObjectPlaceholder = GameObject.Find ("MouthObjectPlaceholder");
		lightBlob = GameObject.Find("LightBlob");
		lightBlobCollider = GameObject.Find("LightBlobCollider");
		ballPlaceholder = GameObject.Find("WoolBallPlaceholder");
		head = ComponentUtils.FindTransformInChildren(this.gameObject, "cu_cat_neck1");
		bed = GameObject.Find("Bed");
		sleepLocation = GameObject.Find("SleepLocation");
		hats = ComponentUtils.FindTransformInChildren(this.gameObject, "Hats").gameObject;
		eatLocation = GameObject.Find("EatLocation");
		torch = GameObject.Find("Torch"); 
		if(torch != null) {
			originalTorchPos = torch.transform.position;
		}
		itemsBox = GameObject.Find("ItemsBox");
		itemsBoxShader = itemsBox.GetComponentInChildren<Renderer>().sharedMaterial.shader;
	}
	
	public void setupNeeds() {
		allNeeds = GetComponents<iKittenNeed>();
		
		
		List<iKittenNeedState> allNeedStates = new List<iKittenNeedState>();
		foreach(iKittenNeed need in allNeeds) {
			_assignNeed(need);
			allNeedStates.Add(need.state);
		}
		
		// Record which states need saving
		state.needs = allNeedStates.ToArray();
		
		satiation.setNeedIncreasedAction(Food.use.moveFoodDown);
		satiation.setNeedObject(GameObject.Find("iKittyFood"));
		satiation.setNeedObjectTrigger(GameObject.Find("EatLocation"));
		
		sleep.setNeedObject(bed);
		sleep.setNeedObjectTrigger(sleepLocation);
		sleep.setAtNeedLocationAction( delegate(){
			waypointController.clearWaypoints();
			iTween.StopByName(this.gameObject, "WaypointController");
			animator.SetBool("Jump", true);
			Debug.Log("Kitten going to sleep");
			iTween.MoveTo(gameObject,iTween.Hash("delay", 0.75f,"name","JumpToBed","position",bed.transform.position,"time",0.5,"easetype","linear","oncomplete","prepareToSleep"));
		});
	}
	
	void _assignNeed(iKittenNeed need) {
		switch(need.state.needName) {
			case "Satiation":
				satiation = need;
			break;
			
			case "Sleep":
				sleep = need;
			break;
			
			case "Love":
				love = need;
			break;
			
			case "Fun":
				fun = need;
			break;
		}
	}
	
	public void catchBall() {
		//ball.rigidbody.velocity = Vector3.zero;
		isChasing = false;
		audio.Stop();
		pickupBall();
		Debug.Log("Kitten caught the ball");
	}
	
	public void beckon() {
		if(!isBeckoning) {
			isBeckoning = true;
			chase(eatLocation);
			MainSounds.use.audio.clip = MainSounds.use.beckonSound;
			MainSounds.use.audio.Play();
			waypointController.setOnCompleteAction(stopChasingObject);
			waypointController.setFinalLookTarget(new Vector3(Camera.main.transform.position.x, transform.position.y, Camera.main.transform.position.z));
		}
	}
	
	public void chase(GameObject newChaseObject) {
		chaseObject = newChaseObject;
		chase();
	}
	
	public void chase() {
		isChasing = true;
		Debug.Log("Kiten is chasing ball");
		isRunning = true;
		waypointController.setMoveSpeed(runSpeed);
		waypointController.setLookTime(waypointLookTime);
		waypointController.addWaypoint(chaseObject.transform.position);
		waypointController.addWaypoint(chaseObject.transform.position);
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
		stopChasingObject();
	}
	
	public void stopChasingObject() {
		waypointController.clearWaypoints();
		iTween.StopByName(this.gameObject, "WaypointController");
		animator.SetBool("Run",false);
		animator.SetBool("Idle",true);
		ballState.isMoving = false;
		isRunning = false;
		isChasing = false;
		PlayerModel.use.stoppedIncreasingPoints = true;
		fun.stopMeetingNeed();
		chaseObject = null;
		
		if(isBeckoning) {
			isBeckoning = false;
		}
	}
	
	public void stroke(float inputY, bool isXAxis) {
		if(!isStrokingBegan) {
			strokeAngleX = initialStrokeAngleX;
			initialStrokeAngleZ = head.transform.rotation.z;
			strokeAngleZ = initialStrokeAngleZ;
		}
		
		animator.SetBool("Idle", false);
		animator.SetBool("Stroke", true);
		
		if(isXAxis) {
			strokeAngleX += -inputY * iKittenController.use.touchStrokeScale;
			
			if(strokeAngleX > maxStrokeAngleX) {
				strokeAngleX = maxStrokeAngleX;
			}
			
			if(strokeAngleX < minStrokeAngleX) {
				strokeAngleX = minStrokeAngleX;
			}
		} else {
			strokeAngleZ += -inputY * iKittenController.use.touchStrokeScale;
			
			if(strokeAngleZ > maxStrokeAngleZ) {
				strokeAngleZ = maxStrokeAngleZ;
			}
			
			if(strokeAngleZ < minStrokeAngleZ) {
				strokeAngleZ = minStrokeAngleZ;
			}
		}
		
		isStroking = true;
		isStrokingBegan = true;
		notStrokingTimer = 0;
		PlayerModel.use.incStrokePoints();
		love.inc();
	}
	
	void OnTriggerEnter(Collider other) {
		
	}
	
	void OnTriggerStay(Collider other) {
		if(other.gameObject == eatLocation) {
			isAtMainLocation = true;
		}
		
		if(other.gameObject == ball && chaseObject == ball && isChasing && !isBallInMouth) {
			waypointController.clearWaypoints();
			catchBall();
			waypointController.addWaypoint(ballPlaceholder.transform.position);
			waypointController.setOnCompleteAction(dropBall);
			waypointController.MoveToWaypoint();
		}
		
		if(other.gameObject == lightBlobCollider && isChasing) {
			Debug.Log("Has caught chase object");
			hasCaughtChaseObject = true;
		}
		
		if(other.gameObject == itemsBox) {
			itemsBox.GetComponentInChildren<Renderer>().sharedMaterial.shader = Shaders.transparentShader;
		}
		
		satiation.checkIfHitNeedTrigger(other);
		sleep.checkIfHitNeedTrigger(other);
	}
	
	void OnTriggerExit(Collider other) {
		satiation.checkIfLeftNeedTrigger(other);
		sleep.checkIfLeftNeedTrigger(other);
		
		if(other.gameObject == eatLocation) {
			isAtMainLocation = false;
		}
		
		if(other.gameObject == itemsBox) {
			itemsBox.GetComponentInChildren<Renderer>().sharedMaterial.shader = itemsBoxShader;
		}
	}
}
