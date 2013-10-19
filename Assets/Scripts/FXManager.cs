using UnityEngine;
using System.Collections;

public class FXManager : MonoBehaviour {
	public static FXManager use;
	GameObject sparkleFX;
	
	// Use this for initialization
	void Start () {
		DontDestroyOnLoad(this);
		use = this;
		sparkleFX = GameObject.Find("Sparkle");
	}
	
	// Update is called once per frame
	void Update () {
		if(PlayerModel.use.isHappyFromStroking) {
			setEmit(sparkleFX, true);
			sparkleFX.transform.position = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, sparkleFX.transform.position.z));
		}
	}
	
	void setEmit(GameObject particleCollection, bool isEmitting) {
		foreach(ParticleEmitter emitter in particleCollection.GetComponentsInChildren<ParticleEmitter>()) {
			emitter.emit = isEmitting;
		}
	}
	
	public void sparkle(Vector3 position) {
		sparkleFX = GameObject.Find("Sparkle");
		sparkleFX.transform.position = position;
		setEmit(sparkleFX, true);
	}
}
