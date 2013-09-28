using UnityEngine;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public float touchDistance = 0.25f;
	
	Animator animator;
	iKittenSounds sounds;
	AnimatorStateInfo stateInfo;
	RaycastHit touchHitInfo;
	
	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator>();
		sounds = GetComponent<iKittenSounds>();
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetMouseButtonDown(0) || Input.touchCount > 0) {
			if(Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out touchHitInfo, touchDistance)) {
				Debug.Log(touchHitInfo.collider.gameObject.name);
				
				if(touchHitInfo.collider.gameObject == Food.use.gameObject) {
					Food.use.refillFood();
				}
				
				if(touchHitInfo.collider.gameObject.name == "cu_cat_tongue") {
					animator.SetBool("Lick", true);
				}
				
				if(touchHitInfo.collider.gameObject == this.gameObject) {
					animator.SetBool("Meow", true);
					sounds.randomMeow();
				}
			}
		} else {
			animator.SetBool("Meow", false);
			animator.SetBool("Lick", false);
		}
	}
}
