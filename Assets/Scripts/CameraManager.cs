using UnityEngine;
using System.Collections;

public class CameraManager : MonoBehaviour {
	public static CameraManager use;
	
	GameObject iKitty;
	Camera[] cameras;
	int cameraIndex = 0;

	// Use this for initialization
	void Start () {
		cameras = Camera.allCameras;
		
		// Disable all other cameras
		foreach(Camera cam in cameras) {
			cam.enabled = false;
			cam.GetComponent<AudioListener>().enabled = false;
		}
		
		cameras[0].enabled = true;
		cameras[0].GetComponent<AudioListener>().enabled = true;
		
		iKitty = GameObject.Find("iKitty");
		
		use = this;
	}
	
	public void nextCamera() {
		cameras[cameraIndex].enabled = false;
		cameras[cameraIndex].GetComponent<AudioListener>().enabled = false;
		cameraIndex++;
		
		if(cameraIndex == cameras.Length) {
			cameraIndex = 0;
		}
		
		cameras[cameraIndex].enabled = true;
		cameras[cameraIndex].GetComponent<AudioListener>().enabled = true;
	}
	
	void Update() {
		//Camera.main.transform.LookAt(new Vector3(Camera.main.transform.position.x, iKitty.transform.position.y, iKitty.transform.position.z));
	}
}
