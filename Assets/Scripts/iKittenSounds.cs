using UnityEngine;
using System.Collections;

public class iKittenSounds : MonoBehaviour {
	public AudioClip[] meowSounds;
	public AudioClip purrSound;
	public AudioClip lickSound;
	
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
}
