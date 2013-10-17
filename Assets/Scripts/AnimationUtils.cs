using UnityEngine;
using System.Collections;

public class AnimationUtils : MonoBehaviour {
	public static string getEnabledBool(Animator animator, string[] states) {
		foreach(string state in states) {
			if(animator.GetBool(state) && state!="Idle") {
				return state;
			}
		}
		
		// No state enabled so return Idle by default
		return "Idle";
	}
	
	public static void disableAllStates(Animator animator, string[] states) {
		foreach(string state in states) {
			animator.SetBool(state, false);
		}
	}
}
