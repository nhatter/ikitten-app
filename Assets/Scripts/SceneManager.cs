using UnityEngine;
using System.Collections;

public class SceneManager : MonoBehaviour {
	public static string DEFAULT_SCENE = "Default";
	static bool isLoadingScene = false;
	
	void Start() {
		Debug.Log("Starting SceneManager");
		MainSystem.load();
		CameraManager.use.fadeIn();

		
		if(!SaveDataModel.load(SaveDataModel.SAVES_DIR+SaveDataModel.DEFAULT_SAVE_FILE)) {
			if(PlayerModel.use.state.hasSelectedKitten) {
				GameObject iKitten = (GameObject) GameObject.Instantiate((GameObject)Resources.Load("iKitten/iKitten"));
				CameraManager.use.setCameraToFollow(iKitten);
			}
		}
	}
	
	public static void loadScene(string sceneName) {
		isLoadingScene = true;
		Application.LoadLevel(sceneName);
		Debug.Log("Finished loading "+sceneName);
	}
}
