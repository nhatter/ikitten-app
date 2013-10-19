using UnityEngine;
using System.Collections;

public class MainTitle : MonoBehaviour {
	public GUISkin skin;
	public float fadeSpeed = 0.05f;
	
	Rect gdxLogoPos;
	bool isShowingGDX = true;
	bool isShowingFluffy = false;
	bool isLoadingGame = false;
	
	void Start() {
		gdxLogoPos = new Rect(Screen.width/2-skin.GetStyle("GDXLogo").fixedWidth/2, Screen.height/2-skin.GetStyle("GDXLogo").fixedHeight/2, skin.GetStyle("GDXLogo").fixedWidth, skin.GetStyle("GDXLogo").fixedHeight);
		
		Fader.use.setChangeSpeed(fadeSpeed);
		Fader.use.InOutThen(delegate() {
			toggleShowingGDX();
		});
	}
	
	void Update() {
		if(!isShowingGDX && !isLoadingGame) {
			isLoadingGame = true;
			Fader.use.InOutThen(delegate() {
				isShowingFluffy = false;
				Application.LoadLevel("Adoption");
			});
		}
	}
	
	void OnGUI() {
		GUI.skin = skin;
		if(isShowingGDX) {
			GUI.Box(gdxLogoPos, "", "GDXLogo");
		}
		
		if(isShowingFluffy) {
			GUI.Box(gdxLogoPos, "", "FluffyLogo");
		}
		
		Fader.use.showChange();
	}
	
	void toggleShowingGDX() {
		isShowingGDX = false;
		isShowingFluffy = true;
	}
}
