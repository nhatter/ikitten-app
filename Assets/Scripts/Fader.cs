using UnityEngine;
using System;

public class Fader : Changer {
	public Texture2D originalFadeOutTexture;
	public Texture2D fadeOutTexture;
	public static int drawDepth = -1000;
	private Color fadeColour = new Color(0.0f, 0.0f, 0.0f);
	
	public static Fader use;
	private bool isUsingCustomTexture = false;
	private Vector2 drawPosition = new Vector2(0,0);
	
	public override void showChange() {
		handleChange();
		
		GUI.color = new Color(fadeColour.r, fadeColour.b, fadeColour.g, changeValue);
	 
		GUI.depth = drawDepth;
		
		if(isUsingCustomTexture) {
			GUI.DrawTexture(new Rect(drawPosition.x, drawPosition.y, fadeOutTexture.width, fadeOutTexture.height), fadeOutTexture);
		} else {
			GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), fadeOutTexture);
		}
	}
	
	public void setFadeColour(Color newColour) {
		resetFadeTexture();
		fadeColour = newColour;
	}
	
	public void setDrawPosition(Vector2 drawPosition) {
		this.drawPosition = drawPosition;
	}
	
	public void setFadeTexture(Texture2D fadeOutTexture) {
		isUsingCustomTexture = true;
		originalFadeOutTexture = this.fadeOutTexture;
		this.fadeOutTexture = fadeOutTexture;
	}
	
	public void resetFadeTexture() {
		isUsingCustomTexture = false;
		drawPosition = new Vector2(0,0);
		this.fadeOutTexture = originalFadeOutTexture;
	}
	
	public void Start() {
		DontDestroyOnLoad(this);
		use = this;
		changeSpeed = 0.5f;
		isGUIfunction = true;
		changeValue = 1;
		originalFadeOutTexture = fadeOutTexture;
	}
}
