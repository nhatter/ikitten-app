﻿using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;

public class GDXMobileView: EditorWindow {
	public static string DEVICE_IMAGES_PATH = "Assets/Plugins/GDX Mobile View/Devices/";
	public static Vector2 UNITY_GAMEVIEW_BORDER = new Vector2(4, 18);
	
	public static GDXMobileViewCanvas canvas;
	
	public static MobileDevice[] devices;
	public static string[] deviceNames;

	public static string[] orientations = {"Horizontal", "Vertical"};
	
	private Vector2 deviceCenter = new Vector2(200,150);
	
	public static int selectedDeviceIndex = 0;
	public static int selectedOrientationIndex = 0;
	private bool isActualSize = true;
	private bool isCompensatingForBorders = true;
	private static float dpi = 110.0f;
	
	private static float screenSize;
	private static float oldScreenSize;
	
    public static float scaledDeviceWidth;
	public static float scaledDeviceHeight;
	public static bool isSizeSet = false;
	
	static bool isInit = false;
   
	[MenuItem ("Window/GDX Mobile View")]
	static void Init () {
        GDXMobileView window = (GDXMobileView)(EditorWindow.GetWindow(typeof(GDXMobileView)));
	 	 canvas = (GDXMobileViewCanvas)(EditorWindow.GetWindow(typeof(GDXMobileViewCanvas)));

		
		List<MobileDevice> deviceList = new List<MobileDevice>();
		deviceList.Add(new MobileDevice("Apple/iPhone 3", new Vector2(320,480), 3.5f, 2.44f));
		deviceList.Add(new MobileDevice("Apple/iPhone 4", new Vector2(640,960), 3.5f, 2.31f));
		deviceList.Add(new MobileDevice("Apple/iPhone 5", new Vector2(640,1136),4, 2.31f));
		deviceList.Add(new MobileDevice("Apple/iPad Mini (1st Gen)", new Vector2(768,1024), 7.9f, 5.3f, "Apple/iPad Mini"));
		deviceList.Add(new MobileDevice("Apple/iPad Mini (2nd Gen)", new Vector2(1536,2048), 7.9f, 5.3f, "Apple/iPad Mini"));
		deviceList.Add(new MobileDevice("Apple/iPad (1st Gen)", new Vector2(768,1024), 9.7f, 7.47f, "Apple/iPad"));
		deviceList.Add(new MobileDevice("Apple/iPad (2nd Gen)", new Vector2(768,1024), 9.7f, 7.31f, "Apple/iPad"));
		deviceList.Add(new MobileDevice("Apple/iPad (3rd and 4th Gen)", new Vector2(1536,2048), 9.7f, 7.31f, "Apple/iPad"));
		deviceList.Add(new MobileDevice("Apple/iPad Air (5th Gen)", new Vector2(1536,2048), 9.7f, 6.67f, "Apple/iPad Mini"));

		devices = new MobileDevice[deviceList.Count];
		deviceList.CopyTo(devices, 0);
		
		deviceNames = new string[devices.Length];
		for(int i=0; i<devices.Length; i++) {
			deviceNames[i] = devices[i].name;
		}
		
		isInit = true;
	}
 
    public static EditorWindow GetMainGameView() {
       System.Type T = System.Type.GetType("UnityEditor.GameView,UnityEditor");
       System.Reflection.MethodInfo GetMainGameView = T.GetMethod("GetMainGameView",System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
       System.Object Res = GetMainGameView.Invoke(null,null);
       return (EditorWindow)Res;
    }
 
    void OnGUI () {
	  if(!isInit) {
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
	  isCompensatingForBorders = EditorGUILayout.Toggle("Compensate for GameView Border: ", isCompensatingForBorders);
		
      if(GUILayout.Button("Emulate Display Size")) {
		isSizeSet = true;
			
        EditorWindow gameView = GetMainGameView();
        Rect pos = gameView.position;
		
		float realLifeScaleX = getToScaleXFromDiag(devices[selectedDeviceIndex].diagonal, devices[selectedDeviceIndex].resolution.x, devices[selectedDeviceIndex].resolution.y);
	
		float aspectRatio = devices[selectedDeviceIndex].resolution.y / devices[selectedDeviceIndex].resolution.x;
		float scaledWidth = devices[selectedDeviceIndex].resolution.x * realLifeScaleX;
		float scaledHeight = scaledWidth * aspectRatio;
			
		float deviceAspectRatio = (float) devices[selectedDeviceIndex].getDeviceImage().height / (float) devices[selectedDeviceIndex].getDeviceImage().width ;
		float realLifeDeviceX = getToScaleXFromWidth(devices[selectedDeviceIndex].physicalWidth, devices[selectedDeviceIndex].getDeviceImage().width, devices[selectedDeviceIndex].getDeviceImage().height);
		

		Debug.Log(""+selectedOrientationIndex);
		if(orientations[selectedOrientationIndex] == "Horizontal") {
			
        	pos.width = scaledHeight;
       		pos.height = scaledWidth;
			
			if(isCompensatingForBorders) {
				pos.width += UNITY_GAMEVIEW_BORDER.x;
				pos.height += UNITY_GAMEVIEW_BORDER.y;
			}
			
			scaledDeviceWidth = devices[selectedDeviceIndex].getDeviceImage().width * realLifeDeviceX;
			scaledDeviceHeight = scaledDeviceWidth * deviceAspectRatio;		
		
			canvas.position = new Rect(canvas.position.x, canvas.position.y, scaledDeviceHeight, scaledDeviceWidth);

		} else {
			pos.width = scaledWidth;
       		pos.height = scaledHeight;
				
			if(isCompensatingForBorders) {
				pos.width += UNITY_GAMEVIEW_BORDER.y;
				pos.height += UNITY_GAMEVIEW_BORDER.x;
			}
				
			scaledDeviceWidth = devices[selectedDeviceIndex].getDeviceImage().width * realLifeDeviceX;
			scaledDeviceHeight = scaledDeviceWidth * deviceAspectRatio;
				
			canvas.position = new Rect(canvas.position.x, canvas.position.y, scaledDeviceWidth, scaledDeviceHeight);
		}
			
        GetMainGameView().position = pos;
      }
    }
	
	float getToScaleXFromDiag(float targetDiagonal, float width, float height) {
		float currentPhysicalWidth = width/dpi;
		float currentPhysicalHeight = height/dpi;
		float currentPhysicalDiagonal = Mathf.Sqrt(Mathf.Pow(currentPhysicalWidth,2) + Mathf.Pow(currentPhysicalHeight, 2));
		return targetDiagonal / currentPhysicalDiagonal;
	}
	
	float getToScaleXFromWidth(float targetPhysicalWidth, float width, float height) {
		float currentPhysicalWidth = width/dpi;
		float aspectRatio = height/width;
		float realLifeScaleX = targetPhysicalWidth / currentPhysicalWidth;
		return realLifeScaleX;
	}
	
	public class MobileDevice {
		public string name;
		public Vector2 resolution;
		public float diagonal;
		public float physicalWidth;
		private Texture2D deviceImage;
		private Texture2D deviceImageHorizontal;
		
		public MobileDevice(string name, Vector2 resolution, float diagonal, float physicalWidth, string commonDeviceImage = "") {
			this.name = name;
			this.resolution = resolution;
			this.diagonal = diagonal;
			this.physicalWidth = physicalWidth;
			this.deviceImage = (Texture2D) Resources.LoadAssetAtPath(DEVICE_IMAGES_PATH + (commonDeviceImage != "" ? commonDeviceImage : name) + ".png", typeof(Texture2D));
			this.deviceImageHorizontal = transposeTexture();

		}
		
		public Texture2D getDeviceImage() {
			return deviceImage;
		}
		
		public Texture2D getDeviceImageHorizontal() {
			return deviceImageHorizontal;
		}
		
		public override string ToString () {
			return name;
		}
		
		public Texture2D transposeTexture() {
			Texture2D newTexture = new Texture2D(this.deviceImage.height, this.deviceImage.width, TextureFormat.RGBA32, true);
			Color32[] deviceImagePixels = this.deviceImage.GetPixels32();
			Color32[,] deviceImageGrid = new Color32[this.deviceImage.height, this.deviceImage.width];
			Color32[,] newDeviceImageGrid = new Color32[this.deviceImage.width, this.deviceImage.height];
			
			int imageY = deviceImage.height;
			int imageX = 0;

			for(int i=0;i<this.deviceImage.height*this.deviceImage.width;i++) {
				if(i!=0 && i % (deviceImage.width) == 0) {
					imageY--;
					imageX = 0;
				}
			
				if(imageY < deviceImage.height && imageX < deviceImage.width) {
					deviceImageGrid[imageY,imageX] = deviceImagePixels[i];
				}
				
				imageX++;
			}
			
			for(int j=0;j<deviceImage.height;j++) {
				for(int i=0;i<deviceImage.width;i++) {
					newDeviceImageGrid[i,j] = deviceImageGrid[j,i];
				}
			}
			
			int pixelCount = 0;
			foreach(Color pixel in newDeviceImageGrid) {
				deviceImagePixels[pixelCount] = pixel;
				pixelCount++;
			}
			
			newTexture.SetPixels32(deviceImagePixels);
			newTexture.Apply();
			return newTexture;
		}
		
	}
}