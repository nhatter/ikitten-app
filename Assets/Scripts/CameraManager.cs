using UnityEngine;
using System.Collections;

public class CameraManager : MonoBehaviour {
	public static CameraManager use;
	
	Camera[] cameras;
	int cameraIndex = 0;
	
	FollowObject followCameraSettings;

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
		
		followCameraSettings = GameObject.Find("FollowCamera").GetComponent<FollowObject>();
				
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
	
	public void setCameraToFollow(GameObject targetObject) {
		followCameraSettings.targetObject = targetObject;
	}
}
