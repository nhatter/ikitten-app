using UnityEngine;
using System;

public class Changer : MonoBehaviour {
	//--------------------------------------------------------------------
	//private variables
	//--------------------------------------------------------------------
	
	protected enum FadeMode { IN_OUT_THEN, NORMAL };
	
	protected float maxValue = 1.0f;
	
	protected float minValue = 0.0f;
	
	protected float changeValue = 1.0f; 
	
	protected float changeSpeed = 1.0f;
	 
	private int changeDir = 1;

	private Action changedOutFunction;

	private Action changedInFunction;
	
	private bool queueChangeOut = false;
	
	private bool queueChangeIn = false;
	
	protected bool isGUIfunction = true;
	
	protected bool isChanging = false;
	
	protected FadeMode fadeMode = FadeMode.NORMAL;

	//--------------------------------------------------------------------
	//            Runtime voids
	//--------------------------------------------------------------------
	 
	//--------------------------------------------------------------------
	
	void Update() {
		if(isGUIfunction || !isChanging) {
			return;
		}
		
		handleChange();
		showChange();
	}
	 
	void OnGUI() {
		if(!isGUIfunction || !isChanging) {
			return;
		}
		
		handleChange();
		showChange();
	}
	
	public void handleChange() {
		changeValue += changeDir * changeSpeed * Time.deltaTime;	
		changeValue = Mathf.Clamp (changeValue, minValue, maxValue);
		if(changedOutFunction!=null && changeValue == maxValue) {
			changedOutFunction();
			changedOutFunction = null;

			Debug.Log ("Calling changedOutFunction");
			if(queueChangeIn) {
				In();
				queueChangeIn = false;
			} else {
				isChanging = false;
			}
		}
		
		if((changedInFunction!=null || fadeMode == FadeMode.IN_OUT_THEN) && changeValue == minValue) {
			if(fadeMode != FadeMode.IN_OUT_THEN) {
				changedInFunction();
				changedInFunction = null;
			}
			
			if(queueChangeOut) {
				Out();
				queueChangeOut = false;
			} else {
				isChanging = false;
			}
		}
	}
	
	public virtual void showChange() {
	}
	 
	//--------------------------------------------------------------------
	 
	public void In(){
		changeValue = maxValue-0.01f;
		changeDir = -1;
		isChanging = true;
	}
	 
	//--------------------------------------------------------------------
	 
	public void Out(){
		fadeMode = FadeMode.NORMAL;
		changeValue = minValue+0.01f;
		changeDir = 1;
		isChanging = true;
	}
	
	public void InThen(Action func) {
		In();
		fadeMode = FadeMode.NORMAL;
		changedInFunction = func;
		queueChangeOut = false;
		isChanging = true;
	}
	
	public void OutThen(Action func) {
		Out();
		fadeMode = FadeMode.NORMAL;
		changedOutFunction = func;
		queueChangeIn = false;
		isChanging = true;
	}

	public void OutThenIn(Action func) {
		Out();
		fadeMode = FadeMode.NORMAL;
		changedOutFunction = func;
		queueChangeIn = true;
		isChanging = true;
	}

	public void InThenOut(Action func) {
		In();
		fadeMode = FadeMode.NORMAL;
		changedInFunction = func;
		queueChangeOut = true;
		isChanging = true;
	}
	
	public void InOutThen(Action func) {
		In();
		fadeMode = FadeMode.IN_OUT_THEN;
		changedOutFunction = func;
		queueChangeOut = true;
		isChanging = true;
	}

	public float getChangeLevel() {
		return changeValue;
	}
	
	public void setChangeValue(float changeValue) {
		this.changeValue = changeValue;
	}
	
	public void setMaxValue(float maxValue) {
		this.maxValue = maxValue;
	}
	
	public void setMinValue(float minValue) {
		this.minValue = minValue;
	}
	
	public void setChangeSpeed(float speed) {
		changeSpeed = speed;
	}
}
