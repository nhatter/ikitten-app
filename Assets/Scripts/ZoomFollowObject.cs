using UnityEngine;
using System.Collections;

public class ZoomFollowObject : MonoBehaviour {
	public static ZoomFollowObject use;
	public GameObject targetObject;
	public float distanceFOVScale = 11.0f;
	float currentFieldOfView;
	public float distanceFromCamera;

	// Use this for initialization
	void Start () {
		currentFieldOfView = camera.fieldOfView;
		use = this;
	}
	
	// Update is called once per frame
	void Update () {
		transform.LookAt(new Vector3(targetObject.transform.position.x, transform.position.y, targetObject.transform.position.z));
		camera.fieldOfView = currentFieldOfView / CameraManager.use.distanceToKitten / distanceFOVScale;
	}
}
