using UnityEngine;
using System.Collections;

public class Voter : MonoBehaviour {
	public int featureId;
	bool isEnabled = false;
	public int voteCountToRepresent;
	
	public Material enabledMaterial;
	public Material disabledMaterial;
	
	public void setEnabled(bool isEnabled) {
		this.isEnabled = isEnabled;
		
		if(this.isEnabled) {
			this.gameObject.renderer.sharedMaterial = enabledMaterial;
		} else {
			this.gameObject.renderer.sharedMaterial = disabledMaterial;
		}
	}
}
