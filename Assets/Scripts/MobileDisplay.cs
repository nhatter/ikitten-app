using UnityEngine;
using System.Collections;

public class MobileDisplay {
	public static int width;
	public static int height;

	// Use this for initialization
	static MobileDisplay () {
		Screen.orientation = ScreenOrientation.LandscapeLeft;
		#if !UNITY_EDITOR
			width = Screen.height;
			height = Screen.width;
		#else
			width = Screen.width;
			height = Screen.height;
		#endif
	}
}
