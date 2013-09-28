using UnityEngine;
using System.Collections;

public class iKittenModel : MonoBehaviour {
	public int MAX_SATISFACTION = 10;
	public float FEED_ALERT_TIME_SCALE = 2.0f;
	public int satiation = 10;
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
	
	public float timer = 0.0f;
	public float hungerAlertTimer = 0.0f;
	bool queueTimerReset = false;
	
	public int idleNameHash = Animator.StringToHash("Base.A_idle");
	
	GameObject ball;
	public bool isChasingBall = false;
	public float chaseBallReactionTime = 1.0f;
	public float distanceToCatchBall = 0.01f;
	public float chaseBallReactionTimer = 0;
	
	public float runSpeed = 2.0f;
	float runSoundTimer = 0;
	public float runSoundTime = 0.2f;
	public float waypointLookTime = 1.0f;

	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
		waypointController = GetComponent<WaypointController>();
		ball = GameObject.Find ("WoolBall");
	}
	
	// Update is called once per frame
	void Update () {
		timer += Time.deltaTime;
		hungerAlertTimer += Time.deltaTime;
		
		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		isIdle = (stateInfo.nameHash == Animator.StringToHash("Base.A_idle"));
		
		if(animator.GetBool("Lick")) {
			Handheld.Vibrate();
		}
		
		if(isEating && Food.use.foodLevel > 0) {
			if(timer >= timeTilSatiationIncrease) {
				Food.use.moveFoodDown();
				satiation++;
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
				satiation--;
				queueTimerReset = true;
			}
			
			if(satiation <= levelToStartEating && hungerAlertTimer >= timeTilSatiationMeow & isIdle && !audio.isPlaying) {
				animator.SetBool("Meow", true);
				sounds.randomMeow();
				hungerAlertTimer = 0;
			}
		}
		
		if(satiation <= levelToStartEating && isIdle && !audio.isPlaying) {
			if(!isEating && Food.use.foodLevel > 0) {
				isEating = true;
				animator.SetBool("Eat", isEating);
				audio.clip = sounds.purrSound;
				audio.loop = true;
				audio.Play();
			} else {
				if(satiation > 0) {
					timeTilSatiationMeow = satiation*FEED_ALERT_TIME_SCALE;
				} else {
					timeTilSatiationMeow = minTimeTilSatiationMeow;
				}
			}
		}
		
		if(satiation == MAX_SATISFACTION && isEating) {
			isEating = false;
			audio.Stop();
			audio.loop = false;
			animator.SetBool("Eat", isEating);
		}
		
		if(queueTimerReset) {
			timer = 0;
			queueTimerReset = false;
		}
		
		if(isChasingBall) {
			animator.SetBool("Run", true);
			animator.SetBool("Idle", false);
			
			chaseBallReactionTimer += Time.deltaTime;
			
			if(chaseBallReactionTimer > chaseBallReactionTime) {
				waypointController.addWaypoint(ball.transform.position);
				waypointController.MoveToWaypoint();
				chaseBallReactionTimer = 0;
			}

			if(runSoundTimer > runSoundTime) {
				runSoundTimer = 0;
			}
			
			if(runSoundTimer == 0) {
				audio.PlayOneShot(sounds.runSound);
			}
			
			runSoundTimer += Time.deltaTime;
		}
		
	} // End of Update
	
	public void catchBall() {
		ball.rigidbody.velocity = Vector3.zero;
		isChasingBall = false;
		animator.SetBool("Run", false);
		animator.SetBool("Idle", true);
		audio.Stop();
		Debug.Log("Kitten caught the ball");
	}
	
	public void chaseBall() {
		isChasingBall = true;
	}

	public void OnTriggerStay(Collider collider) {
		if(collider.gameObject == ball) {
			waypointController.clearWaypoints();
			catchBall();
			iTween.StopByName("waypointController");
		}
	}
}
