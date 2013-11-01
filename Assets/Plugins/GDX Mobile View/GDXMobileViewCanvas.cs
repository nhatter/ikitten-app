using UnityEngine;
using UnityEditor;
using System.Collections;

public class GDXMobileViewCanvas : EditorWindow {
	static void Init() {
	}
	
	Texture2D deviceImage;
	Rect orientationRect;
	void OnGUI () {
		if(GDXMobileView.isSizeSet && GDXMobileView.scaledDeviceWidth > 0 && GDXMobileView.scaledDeviceHeight > 0) {
			if(GDXMobileView.orientations[GDXMobileView.selectedOrientationIndex] == "Horizontal") {
				deviceImage = GDXMobileView.devices[GDXMobileView.selectedDeviceIndex].getDeviceImageHorizontal();
				orientationRect = new Rect(0,0, GDXMobileView.scaledDeviceHeight, GDXMobileView.scaledDeviceWidth);
			} else {
				deviceImage = GDXMobileView.devices[GDXMobileView.selectedDeviceIndex].getDeviceImage();
				orientationRect = new Rect(0,0, GDXMobileView.scaledDeviceWidth, GDXMobileView.scaledDeviceHeight);
			}
			
			GUI.DrawTexture(orientationRect, deviceImage, ScaleMode.ScaleToFit);
		}
	}
}
