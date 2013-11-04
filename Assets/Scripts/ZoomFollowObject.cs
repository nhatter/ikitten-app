using UnityEngine;
using System.Collections;

public class ZoomFollowObject : MonoBehaviour {
	public static ZoomFollowObject use;
	public GameObject targetObject;
	public float distanceFOVScale = 0.25f;
	float defaultFOVScale;
	public float shopViewFOV = 0.125f;
	float currentFieldOfView;
	public float distanceFromCamera;

	// Use this for initialization
	void Start () {
		currentFieldOfView = camera.fieldOfView;
		defaultFOVScale = distanceFOVScale;
		use = this;
	}
	
	// Update is called once per frame
	void Update () {
		transform.LookAt(new Vector3(targetObject.transform.position.x, transform.position.y, targetObject.transform.position.z));
		camera.fieldOfView = currentFieldOfView / CameraManager.use.distanceToKitten / distanceFOVScale;
	}
	
	public void useNormalFOV() {
		distanceFOVScale = defaultFOVScale;
	}
	
	public void useShopViewFOV() {
		distanceFOVScale = shopViewFOV;
	}
}
