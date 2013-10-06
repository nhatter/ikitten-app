using UnityEngine;
using System.Collections;

public class PlayerModel : MonoBehaviour {
	public static PlayerModel use;
	
	public int happyPoints;
	public int money;
	public int strokePoints;
	
	public int strokePointsToGainHappyPoints = 10000;
	public int happyPointsGainedFromStroking = 100;
	public bool isHappyFromStroking = false;
	
	void Start() {
		use = this;
	}
	
	public void incStrokePoints() {
		strokePoints += (int) (Time.deltaTime * 1000);
		
		if(strokePoints >= strokePointsToGainHappyPoints) {
			isHappyFromStroking = true;
			happyPoints += happyPointsGainedFromStroking;
			strokePoints = 0;
		}
	}
}
