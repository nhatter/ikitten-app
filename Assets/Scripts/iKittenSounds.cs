using UnityEngine;
using System.Collections;

public class iKittenSounds : MonoBehaviour {
	public static iKittenSounds use;
	public AudioClip[] meowSounds;
	public AudioClip purrSound;
	public AudioClip lickSound;
	public AudioClip runSound;
	public bool isPlaying = false;
	
	void Start() {
		use = this;
	}
	
	public void randomMeow() {
		int randomIndex = (int) Mathf.Round(Random.value*meowSounds.Length-1);
		if(randomIndex > meowSounds.Length) {
			randomIndex = meowSounds.Length;
		}
		
		if(randomIndex < 0) {
			randomIndex = 0;
		}
				
		audio.PlayOneShot(meowSounds[randomIndex]);
	}
	
	public void purr() {
		if(!isPlaying) {
			audio.clip = purrSound;
			audio.loop = true;
			audio.Play();
			isPlaying = true;
		}
	}
	
	public void stop() {
		audio.Stop();
		isPlaying = false;
	}
}
