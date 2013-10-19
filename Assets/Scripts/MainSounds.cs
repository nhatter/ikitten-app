using UnityEngine;
using System.Collections;

public class MainSounds : MonoBehaviour {
	public static MainSounds use;
	public AudioClip goodSound;
	
	void Start() {
		DontDestroyOnLoad(this);
		use = this;
	}
}
