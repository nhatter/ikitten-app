using UnityEngine;
using System;
using System.Collections;

public class WaypointController : MonoBehaviour {
	public Vector3[] waypoints;
	public int rate = 20;
	public int rotateTime = 1;
	public bool isLooping = false;
	
	private Action onCompleteAction;
	private string onCompleteActionString;
	
	private Vector3 finalLookTarget;
	
	private int currentWaypoint = 0;
	
	void OnDrawGizmos(){
		iTween.DrawLine(waypoints,Color.yellow);
	}
	
	public void setWaypoints(Vector3[] newWaypoints) {
		waypoints = newWaypoints;
		currentWaypoint=0;
	}
	
	public void setFinalLookTarget(Vector3 lookTarget) {
		finalLookTarget = lookTarget;
	}
	
	public void MoveToWaypoint(){			
		if(currentWaypoint < waypoints.Length) {
			//Time = Distance / Rate:
			float travelTime = Vector3.Distance(transform.position, waypoints[currentWaypoint])/rate;
			if(currentWaypoint == waypoints.Length - 1 && onCompleteAction != null) {
				onCompleteActionString = "onCompleteActionWrapper";
			} else {
				onCompleteActionString = "MoveToWaypoint";
			}
			iTween.MoveTo(gameObject,iTween.Hash("position",waypoints[currentWaypoint],"time",travelTime,"easetype","linear","oncomplete",onCompleteActionString,"Looktarget",waypoints[currentWaypoint],"looktime",.4));
		} else {
			if(finalLookTarget != null) {
				iTween.LookTo(gameObject, finalLookTarget, rotateTime);
			}
		}
			
		//Move to next waypoint:
		currentWaypoint++;
		if(currentWaypoint>waypoints.Length-2 && isLooping){
			currentWaypoint=0;
		}
	}
	
	public void setOnCompleteAction(Action action) {
		onCompleteAction = action;
	}
	
	public void onCompleteActionWrapper() {
		onCompleteAction();
		MoveToWaypoint();
	}
}







