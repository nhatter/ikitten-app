// PFC - prefrontal cortex
// Full Android Sensor Access for Unity3D
// Contact:
// 		contact.prefrontalcortex@gmail.com

using UnityEngine;
using System.Collections;

public class GyroCamera : MonoBehaviour {
	
	Vector3 baseCameraRotationOffset;

	// Use this for initialization
	void Start () {
		// Use mouselook if not using a mobile device
		SensorHelper.ActivateRotation();
		
		useGUILayout = false;
	}
	
	// Update is called once per frame
	void Update () {
		transform.eulerAngles = clampEulerAngles(new Vector3(SensorHelper.rotation.eulerAngles.x, SensorHelper.rotation.eulerAngles.y - baseCameraRotationOffset.y, SensorHelper.rotation.eulerAngles.z - baseCameraRotationOffset.z));
	}
	
	public void setBaseCameraRotationOffset(Vector3 baseRotation) {
		baseCameraRotationOffset = baseRotation;
	}
	
	Vector3 clampEulerAngles(Vector3 euler) {
		return new Vector3(wrapAngle(euler.x), wrapAngle(euler.y), wrapAngle(euler.z));
	}
	
	float wrapAngle (float angle) {
		float newAngle = angle;
			
	    while (newAngle < 0) {
	        newAngle += 360;
		}
		
	    while (newAngle >= 360) {
	        newAngle -= 360;
		}
		
	   	return newAngle;
	}
}