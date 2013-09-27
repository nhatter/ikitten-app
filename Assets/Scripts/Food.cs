using UnityEngine;
using System.Collections;

public class Food : MonoBehaviour {
	public static Food use;
	
	public int foodLevel = 10;
	private float foodPosYDecrements;
	
	private float MIN_FOOD_Y_POS = 0.002338029f;
		
	// Use this for initialization
	void Start () {
		foodPosYDecrements = (transform.position.y - MIN_FOOD_Y_POS) / foodLevel;
		use = this;
	}
	
	public void moveFoodDown() {
		foodLevel--;
		if(foodLevel > 0) {
			this.transform.Translate(0, -foodPosYDecrements, 0);
		}
	}
}
