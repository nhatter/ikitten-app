using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class WaypointController : MonoBehaviour {
	public Queue<Vector3> waypoints = new Queue<Vector3>();
	public int rate = 50;
	public int rotateTime = 1;
	public bool isLooping = false;
	
	private Action onCompleteAction;
	private string onCompleteActionString;
	
	private Vector3 finalLookTarget;
	
	private int currentWaypoint = 0;
	Vector3 currentWayPointPos;
	
	private float moveSpeed = 1.0f;
	private float travelTime;
	private float lookTime = 2.0f;
	
	void OnDrawGizmos(){
		iTween.DrawLine(waypoints.ToArray(),Color.yellow);
	}
	
	public void setWaypoints(Queue<Vector3> newWaypoints) {
		waypoints = newWaypoints;
		currentWaypoint=0;
	}
	
	public void setFinalLookTarget(Vector3 lookTarget) {
		finalLookTarget = lookTarget;
	}
	
	public void MoveToWaypoint(){
		if(waypoints.Count > 0) {
			//Time = Distance / Rate:
			currentWayPointPos = waypoints.Dequeue();
			
			if(currentWaypoint == waypoints.Count - 1 && onCompleteAction != null) {
				onCompleteActionString = "onCompleteActionWrapper";
			} else {
				onCompleteActionString = "MoveToWaypoint";
			}
			
			travelTime = Vector3.Distance(transform.position, currentWayPointPos)/moveSpeed;
			currentWayPointPos = new Vector3(currentWayPointPos.x, 0, currentWayPointPos.z);
			iTween.MoveTo(gameObject,iTween.Hash("name","waypointController","position",currentWayPointPos,"time",travelTime,"easetype","linear","oncomplete",onCompleteActionString,"Looktarget",currentWayPointPos,"looktime", lookTime));
			
		} else {
			if(finalLookTarget != null) {
				iTween.LookTo(gameObject, finalLookTarget, rotateTime);
			}
		}
			
		//Move to next waypoint:
		currentWaypoint++;
		if(currentWaypoint>waypoints.Count-2 && isLooping){
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
	
	public void addWaypoint(Vector3 waypoint) {
		waypoints.Enqueue(waypoint);
	}
	
	public void clearWaypoints() {
		waypoints = new Queue<Vector3>();
	}
	
	public Vector3 getCurrentWaypoint() {
		return waypoints.Peek();
	}
		
	public void setMoveSpeed(float newMoveSpeed) {
		moveSpeed = newMoveSpeed;
	}
	
	public void setLookTime(float newLookTime) {
		lookTime = newLookTime;
	}
}







