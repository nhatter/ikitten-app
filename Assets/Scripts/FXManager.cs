using UnityEngine;
using System.Collections;

public class FXManager : MonoBehaviour {
	GameObject sparkle;
	
	// Use this for initialization
	void Start () {
		sparkle = GameObject.Find("Sparkle");
	}
	
	// Update is called once per frame
	void Update () {
		if(PlayerModel.use.isHappyFromStroking) {
			setEmit(sparkle, true);
			sparkle.transform.position = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, sparkle.transform.position.z));
		} else {
			setEmit(sparkle, false);
		}
	}
	
	void setEmit(GameObject particleCollection, bool isEmitting) {
		Debug.Log("Setting "+particleCollection.name+" to emit");
		foreach(ParticleEmitter emitter in particleCollection.GetComponentsInChildren<ParticleEmitter>()) {
			emitter.emit = isEmitting;
		}
	}
}
