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
	
	public float timer = 0.0f;
	public float hungerAlertTimer = 0.0f;
	bool queueTimerReset = false;
	
	public int idleNameHash = Animator.StringToHash("Base.A_idle");

	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
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
			
			if(hungerAlertTimer >= timeTilSatiationMeow & isIdle && !audio.isPlaying) {
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
		
	} // End of Update
}
