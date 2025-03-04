﻿using UnityEngine;
using System;
using System.Collections;

public class CameraManager : MonoBehaviour {
	public static CameraManager use;
	
	public float cameraFadeTime = 2.0f;
	private Action fadeOutAction;
	
	public float distanceToKitten;
	
	GameObject followCamera;
	Camera[] cameras;
	int cameraIndex = 0;
	
	Camera torchCamera;
	Camera featureCamera;
	Camera manualCamera;
	
	ZoomFollowObject followCameraSettings;
	
	public bool isManualCameraEnabled = false;

	// Use this for initialization
	void Start () {
		iTween.CameraFadeAdd();
		
		cameras = Camera.allCameras;
		
		// Disable all other cameras
		foreach(Camera cam in cameras) {
			if(cam.name != "GradientCam") {
				cam.enabled = false;
			}
			
			if(cam.GetComponent<AudioListener>() != null) {
				cam.GetComponent<AudioListener>().enabled = false;
			}
			
			switch(cam.name) {
				case "TorchCamera":
					torchCamera = cam;
				break;
				
				case "FeatureCamera":
					featureCamera = cam;
				break;
				
				case "ManualCamera":
					manualCamera = cam;
				break;
			}
		}
		
		
		
		followCamera = GameObject.Find("FollowCamera");
		if(followCamera != null) {
			followCameraSettings = followCamera.GetComponent<ZoomFollowObject>();
			followCamera.camera.enabled = true;
			followCamera.GetComponent<AudioListener>().enabled = true;
		} else {
			cameras[0].enabled = true;
			if(cameras[0].GetComponent<AudioListener>() != null) {
				cameras[0].GetComponent<AudioListener>().enabled = true;
			}
		}
		setCameraToFollow(GameObject.Find("iKitten"));
		use = this;
	}
	
	void Update() {
		if(iKittenModel.anyKitten != null) {
			distanceToKitten = Vector3.Distance(Camera.main.transform.position, iKittenModel.anyKitten.transform.position);
		}
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
		if(followCamera != null) {
			followCameraSettings.targetObject = targetObject;
		}
	}
	
	public void fadeIn() {
		iTween.CameraFadeFrom(iTween.Hash("amount",1, "time", cameraFadeTime));
	}
	
	public void fadeOutThen(Action action) {
		fadeOutAction = action;
		iTween.CameraFadeTo(iTween.Hash("amount",1, "time", cameraFadeTime, "oncomplete","fadeOutWrapper", "oncompletetarget", this.gameObject));
	}
	
	public void fadeOutWrapper() {
		Debug.Log("Calling fadeOutAction");
		fadeOutAction();
	}
	
	public void disableAllCameras() {
		foreach(Camera cam in cameras) {
			cam.enabled = false;
		}
	}
	
	public void enableTorchCamera() {
		disableAllCameras();
		torchCamera.enabled = true;
		//torchCamera.GetComponent<FollowObject>().enabled = true;
	}
	
	public void disableTorchCamera() {
		disableAllCameras();
		followCamera.camera.enabled = true;
		//torchCamera.GetComponent<FollowObject>().enabled = false;
	}
	
	public void enableFeatureCamera() {
		disableAllCameras();
		featureCamera.enabled = true;
	}
	
	public void disableFeatureCamera() {
		disableAllCameras();
		followCamera.camera.enabled = true;
	}
	
	public void toggleManualCamera() {
		disableAllCameras();
		isManualCameraEnabled = !isManualCameraEnabled;
		manualCamera.camera.enabled = isManualCameraEnabled;

		if(manualCamera.camera.enabled) {
			manualCamera.GetComponent<GyroCamera>().setBaseCameraRotationOffset(SensorHelper.rotation.eulerAngles - followCamera.transform.eulerAngles);
			manualCamera.transform.position = followCamera.transform.position;
		} else {
			followCamera.camera.enabled = true;
		}
	
	}
}
