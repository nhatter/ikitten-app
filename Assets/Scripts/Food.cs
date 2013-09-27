using UnityEngine;
using System.Collections;

public class Food : MonoBehaviour {
	public static Food use;
	
	public int MAX_FOOD_LEVEL = 10;
	public int foodLevel;
	private float foodPosYDecrements;
	
	private float MIN_FOOD_Y_POS = 0.002338029f;
	private float ORIGINAL_FOOD_Y_POS;
		
	// Use this for initialization
	void Start () {
		ORIGINAL_FOOD_Y_POS = transform.position.y;
		foodLevel = MAX_FOOD_LEVEL;
		foodPosYDecrements = (transform.position.y - MIN_FOOD_Y_POS) / foodLevel;
		use = this;
	}
	
	public void moveFoodDown() {
		foodLevel--;
		if(foodLevel > 0) {
			this.transform.Translate(0, -foodPosYDecrements, 0);
		}
	}
	
	public void refillFood() {
		foodLevel = MAX_FOOD_LEVEL;
		this.transform.position = new Vector3(this.transform.position.x, ORIGINAL_FOOD_Y_POS, this.transform.position.z);
	}
}
