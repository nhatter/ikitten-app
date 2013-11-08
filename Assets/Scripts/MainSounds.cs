using UnityEngine;
using System.Collections;

public class MainSounds : MonoBehaviour {
	public static MainSounds use;
	public AudioClip goodSound;
	public AudioClip beckonSound;
	public AudioClip foodSound;
	
	void Start() {
		DontDestroyOnLoad(this);
		use = this;
	}
}
