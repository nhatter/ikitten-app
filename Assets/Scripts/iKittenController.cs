using UnityEngine;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public float touchDistance = 0.25f;
	
	Animator animator;
	iKittenModel model;
	iKittenSounds sounds;
	AnimatorStateInfo stateInfo;
	RaycastHit touchHitInfo;
	
	// Use this for initialization
	void Start () {
		model = GetComponent<iKittenModel>();
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
	}
	
	// Update is called once per frame
	void Update () {
		stateInfo = animator.GetCurrentAnimatorStateInfo(0);
		
		if(!model.isIdle && stateInfo.nameHash == Animator.StringToHash("Base.A_idle") && !animator.GetBool("Idle")) {
			model.isPlayerInteracting = false;
			animator.SetBool("Idle", true);
			Debug.Log ("Kitten is now idle");
		}
		
		if(Input.GetMouseButtonDown(0) || Input.touchCount > 0) {
			if(Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out touchHitInfo, touchDistance)) {
				Debug.Log(touchHitInfo.collider.gameObject.name);
				
				if(touchHitInfo.collider.gameObject == Food.use.gameObject) {
					Food.use.refillFood();
					model.isIdle = false;
				}
				
				if(model.isIdle && animator.GetBool("Idle")) {
					if(touchHitInfo.collider.gameObject.name == "cu_cat_tongue") {
						animator.SetBool("Lick", true);
						animator.SetBool("Idle", false);
						audio.PlayOneShot(sounds.lickSound);
						model.isIdle = false;
						model.timer = 0;
					}
					
					if(touchHitInfo.collider.gameObject == this.gameObject) {
						animator.SetBool("Meow", true);
						animator.SetBool("Idle", false);
						sounds.randomMeow();
						model.isIdle = false;
						model.timer = 0;
					}
				}
			}
		} else {
			animator.SetBool("Meow", false);
			animator.SetBool("Lick", false);
		}
	}
}
