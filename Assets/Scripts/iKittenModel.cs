using UnityEngine;
using System.Collections;

public class iKittenModel : MonoBehaviour {
	public int MAX_SATISFACTION = 10;
	public int satiation = 10;
	public int timeTilSatiationIncrease = 5;
	public int timeTilSatiationDecrease = 5;
	public int levelToStartEating = 3;
	
	public bool isEating = false;
	
	Animator animator;
	AnimatorStateInfo stateInfo;
	iKittenSounds sounds;

	
	float timer;

	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
	}
	
	// Update is called once per frame
	void Update () {
		timer += Time.deltaTime;

		
		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		if(isEating && Food.use.foodLevel > 0) {
			if(timer >= timeTilSatiationIncrease) {
				Food.use.moveFoodDown();
				satiation++;
				timer = 0;
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
				timer = 0;
			}
		}
		
		if(satiation <= levelToStartEating && !isEating && Food.use.foodLevel > 0) {
			isEating = true;
			animator.SetBool("Eat", isEating);
			audio.clip = sounds.purrSound;
			audio.loop = true;
			audio.Play();
		}
		
		if(satiation == MAX_SATISFACTION) {
			isEating = false;
			audio.Stop();
			audio.loop = false;
			animator.SetBool("Eat", isEating);
		}
	}
}
