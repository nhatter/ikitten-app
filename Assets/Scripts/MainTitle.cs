using UnityEngine;
using System.Collections;

public class MainTitle : MonoBehaviour {
	public GUISkin skin;
	public float fadeSpeed = 2.0f;
	
	Rect gdxLogoPos;
	bool isShowingFluffy = true;
	bool isFadingToNextScreen = false;
	
	void Start() {
		gdxLogoPos = new Rect(MobileDisplay.width/2-skin.GetStyle("GDXLogo").fixedWidth/2, MobileDisplay.height/2-skin.GetStyle("GDXLogo").fixedHeight/2, skin.GetStyle("GDXLogo").fixedWidth, skin.GetStyle("GDXLogo").fixedHeight);
		
		Fader.use.setChangeSpeed(fadeSpeed);
		Fader.use.InOutThen(delegate() {
			isShowingFluffy = false;
		});
	}
	
	void Update() {
		if(!isShowingFluffy && !isFadingToNextScreen) {
			Fader.use.InOutThen(delegate() {
				Fader.use.In();
				CreateUsername.use.enable();
				Destroy(this);
			});
			
			isFadingToNextScreen = true;
		}
	}
	
	void OnGUI() {
		GUI.skin = skin;
		
		if(isShowingFluffy) {
			GUI.Box(gdxLogoPos, "", "FluffyLogo");
		} else {
			GUI.Box(gdxLogoPos, "", "GDXLogo");
		}
		
		Fader.use.showChange();
	}
}
