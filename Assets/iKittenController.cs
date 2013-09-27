using UnityEngine;
using System.Collections;

public class iKittenController : MonoBehaviour {
	public Animator animator;
	public AudioClip[] meowSounds;
	public float touchDistance = 0.25f;
	
	AnimatorStateInfo stateInfo;
	RaycastHit touchHitInfo;
	
	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetMouseButtonDown(0) || Input.touchCount > 0) {
			if(Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out touchHitInfo, touchDistance)) {
									Debug.Log(touchHitInfo.collider.gameObject.name);

				if(touchHitInfo.collider.gameObject == this.gameObject) {
					animator.SetBool("Meow", true);
					audio.PlayOneShot(randomMeow());
				} else {
				}
			}
		} else {
			animator.SetBool("Meow", false);
		}
	}
				
	AudioClip randomMeow() {
		int randomIndex = (int) Mathf.Round(Random.value*meowSounds.Length-1);
		if(randomIndex > meowSounds.Length) {
			randomIndex = meowSounds.Length;
		}
		
		if(randomIndex < 0) {
			randomIndex = 0;
		}
				
		return meowSounds[randomIndex];
	}
}
