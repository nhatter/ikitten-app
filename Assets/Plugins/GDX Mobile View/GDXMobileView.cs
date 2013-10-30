using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;

public class GDXMobileView: EditorWindow {
	public static Dictionary<string, Vector2> deviceSize = new Dictionary<string, Vector2>();
	public static string[] deviceNames;
	public static Vector2[] deviceSizeArray;
	public static string[] orientations = {"Horizontal", "Vertical"};
	
	private Vector2 deviceCenter = new Vector2(200,150);
	
	private int selectedDeviceIndex = 0;
	private int selectedOrientationIndex = 0;
	private bool isActualSize = true;
	private static float dpi = 110.0f;
	
	private static float screenSize;
	private static float oldScreenSize;
	
	public static Texture2D deviceImage;

    float scaledDeviceWidth;
	float scaledDeviceHeight;
	bool isSizeSet = false;
   
	[MenuItem ("Window/Emulate Device Size...")]
	static void Init () {
       GDXMobileView window = (GDXMobileView)(EditorWindow.GetWindow(typeof(GDXMobileView)));
		
		deviceSize.Add("iPhone 3(GS)", new Vector2(320,480));
		deviceSize.Add("iPhone 4(S)", new Vector2(640,960));
		deviceSize.Add("iPhone 5(CS)", new Vector2(640,1136));
		deviceSize.Add("iPad Mini (1st Gen)", new Vector2(768,1024));
		deviceSize.Add("iPad Mini (2nd Gen)", new Vector2(1536,2048));
		deviceSize.Add("iPad Mini (1st/2nd Gen)", new Vector2(768,1024));
		deviceSize.Add("iPad Mini (3rd/4th Gen)", new Vector2(1536,2048));
		
		deviceSizeArray = new Vector2[deviceSize.Values.Count];
		deviceSize.Values.CopyTo(deviceSizeArray, 0);
		
		deviceNames = new string[deviceSize.Keys.Count];
		deviceSize.Keys.CopyTo(deviceNames, 0);
		
		deviceImage = (Texture2D) Resources.LoadAssetAtPath("Assets/Plugins/GDX Mobile View/Devices/iPhone 5.png", typeof(Texture2D));
	}
 
    public static EditorWindow GetMainGameView() {
       System.Type T = System.Type.GetType("UnityEditor.GameView,UnityEditor");
       System.Reflection.MethodInfo GetMainGameView = T.GetMethod("GetMainGameView",System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
       System.Object Res = GetMainGameView.Invoke(null,null);
       return (EditorWindow)Res;
    }
 
    void OnGUI () {
	     if(deviceNames == null) {
			return;
		}
	
	  EditorGUILayout.HelpBox("DPI measured as "+dpi+" dots per inch ", MessageType.Info);
	  screenSize = EditorGUILayout.FloatField("Screen Diagonal Size: ", screenSize);
	   if(screenSize != oldScreenSize) {
			dpi = Mathf.Sqrt((Mathf.Pow(Screen.currentResolution.width, 2) + Mathf.Pow(Screen.currentResolution.height, 2)))/screenSize;
			oldScreenSize = screenSize;
		}
		
      selectedDeviceIndex = EditorGUILayout.Popup("Device: ", selectedDeviceIndex, deviceNames);
	  selectedOrientationIndex = EditorGUILayout.Popup("Orientation: ", selectedOrientationIndex, orientations);
	  isActualSize = EditorGUILayout.Toggle("Actual Size: ", isActualSize);
		
	  if(isSizeSet) {
		if(orientations[selectedOrientationIndex] == "Horizontal") {
			GUIUtility.RotateAroundPivot(-90, new Vector2(deviceCenter.x+scaledDeviceWidth/2,deviceCenter.y+scaledDeviceHeight/2));
		}
	  	
		GUI.DrawTexture(new Rect(deviceCenter.x,deviceCenter.y, scaledDeviceWidth, scaledDeviceHeight), deviceImage, ScaleMode.ScaleToFit);
			
		if(orientations[selectedOrientationIndex] == "Horizontal") {
			GUIUtility.RotateAroundPivot(90, new Vector2(deviceCenter.x+scaledDeviceWidth/2,deviceCenter.y+scaledDeviceHeight/2));
		}
	  }
		
      if(GUILayout.Button("Emulate Display Size")) {
		isSizeSet = true;
			
        EditorWindow gameView = GetMainGameView();
        Rect pos = gameView.position;
		
		float realLifeScaleX = getRealLifeScaleX(1.97f, deviceSizeArray[selectedDeviceIndex].x, deviceSizeArray[selectedDeviceIndex].y);
	
		float aspectRatio = deviceSizeArray[selectedDeviceIndex].y / deviceSizeArray[selectedDeviceIndex].x;
		float scaledWidth = deviceSizeArray[selectedDeviceIndex].x * realLifeScaleX;
		float scaledHeight = scaledWidth * aspectRatio;
			
		float deviceAspectRatio = (float) deviceImage.height / (float) deviceImage.width ;
		float realLifeDeviceX = getRealLifeScaleX(2.31f, deviceImage.width, deviceImage.height);
		

		Debug.Log(""+selectedOrientationIndex);
		if(orientations[selectedOrientationIndex] == "Horizontal") {
			
        	pos.width = scaledHeight;
       		pos.height = scaledWidth;
			
			scaledDeviceWidth = deviceImage.width * realLifeDeviceX;
			scaledDeviceHeight = scaledDeviceWidth * deviceAspectRatio;
		} else {
			pos.width = scaledWidth;
       		pos.height = scaledHeight;
				
			scaledDeviceWidth = deviceImage.width * realLifeDeviceX;
			scaledDeviceHeight = scaledDeviceWidth * deviceAspectRatio;
		}
        GetMainGameView().position = pos;
      }
    }
	
	float getRealLifeScaleX(float targetPhysicalWidth, float width, float height) {
		float currentPhysicalWidth = width/dpi;
		float aspectRatio = height/width;
		float realLifeScaleX = targetPhysicalWidth / currentPhysicalWidth;
		return realLifeScaleX;
	}
 
}