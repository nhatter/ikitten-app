using UnityEngine;

using System;
using System.Collections;

public class Tutorial : MonoBehaviour {
	public enum TutorialStage { WELCOME, STROKING, NEEDS, FUN, TORCH, TORCH_EXPLAIN, FOOD, FOOD_REFILL, ITEMS_WARNING, ITEMS, FEEDBACK, FEEDBACK_INSTRUCTION, FEEDBACK_REWARD, FINISHED };
	
	public static TutorialStage stage;
	public Tutorial use;
	
	void Start() {
		if(PlayerModel.use.state.hasFinishedTutorial) {
			Destroy(this);
		}
		
		Food.use.foodLevel = 0;
		Food.use.moveFoodDownToLevel();
		
		use = this;
	}
	
	void OnGUI() {
		GUI.skin = iKittenGUI.use.customSkin;
		handleStage();
	}
	
	void nextStage() {
		if(stage == TutorialStage.FINISHED) {
			iKittenGUI.use.hideMessage();
			PlayerModel.use.state.hasFinishedTutorial = true;
			Destroy(this);
		}
		
		int newStage = ((int)stage)+1;
		
		if(newStage < Enum.GetValues(typeof(TutorialStage)).Length) {
			stage = (TutorialStage) Enum.ToObject(typeof(TutorialStage), newStage);
			
			if(stage == TutorialStage.FEEDBACK) {
				ShopView.use.isActive = false;
			}
		}
	}
	
	void handleStage() {
		switch(stage) {
			case TutorialStage.WELCOME:
				iKittenGUI.use.displayMessage("Congratulations! You've adopted a kitten! Tap the screen to get its attention", "Next", nextStage);
			break;
			
			case TutorialStage.STROKING:
				if(iKittenModel.anyKitten.isAtMainLocation) {
					iKittenGUI.use.displayMessage("Kittens need love. Try stroking the side of its head or neck. Also, it might lick your finger.", "Next", nextStage);
				}
			break;
			
			case TutorialStage.NEEDS:
				if(PlayerModel.use.isHappyFromStroking) {
					iKittenGUI.use.displayMessage("Your kitten feels loved! Kittens have several needs: Love, Fun, Food and Sleep. Each time you meet a need, you get points.", "Next", nextStage);
				}
			break;
			
			case TutorialStage.FUN:
				iKittenGUI.use.displayMessage("Kittens enjoy chasing things, such as balls and lights.", "Next", nextStage);
			break;
			
			case TutorialStage.TORCH:
				iKittenGUI.use.displayMessage("Touch the torch to turn it on!", "Next", nextStage);
			break;
			
			case TutorialStage.TORCH_EXPLAIN:
				if(iKittenModel.isTorchLit) {
					iKittenGUI.use.displayMessage("Tilt your screen gently to move the torch and your kitten will chase after it. Click the torch to turn it off after!", "Cool!", nextStage);
				}
			break;
			
			case TutorialStage.FOOD:
				if(!iKittenModel.isTorchLit) {
					iKittenGUI.use.displayMessage("Occasionally, your kitten will get hungry. Make sure there is enough food in the food bowl.", "OK", nextStage);
				}
			break;
			
			case TutorialStage.FOOD_REFILL:
				if(!iKittenModel.isTorchLit) {
					iKittenGUI.use.displayMessage("Touch the box of food to refill the bowl!", "Sure!", nextStage);
				}
			break;
			
			case TutorialStage.ITEMS_WARNING:
				if(Food.use.foodLevel > 1) {
					iKittenModel.anyKitten.satiation.state.need = 3;
					iKittenGUI.use.displayMessage("You can buy wearable items for your kitten using points. Please do NOT dress up real-life pets as it may upset them!", "OK, I won't", nextStage);
				}
			break;
			
			case TutorialStage.ITEMS:
				iKittenGUI.use.displayMessage("Touch the 'Items' box to dress your kitten!", "Yey :)", nextStage);
			break;
			
			case TutorialStage.FEEDBACK:
				
				iKittenGUI.use.displayMessage("(Psst... want to know how to earn lots of points easily?)", "How?", nextStage);
			break;
			
			case TutorialStage.FEEDBACK_INSTRUCTION:
				iKittenGUI.use.displayMessage("Use the postbox to suggest something, or vote on what you want to see in the game next using the whiteboard.", "Tell me more", nextStage);
			break;
			
			case TutorialStage.FEEDBACK_REWARD:
				iKittenGUI.use.displayMessage("For *really* good suggestions, in future you might receive rare items, free expansion packs or even your name in the credits!", "OK", nextStage);
			break;
			
			case TutorialStage.FINISHED:
				if(!PlayerModel.use.state.hasFinishedTutorial) {
					iKittenGUI.use.displayMessage("Now take good care of your kitten. Don't forget to feed and love it!", "I will!", nextStage);
				}
			break;
		}
	}
}
