using UnityEngine;
using System.IO;

public class SaveDataModel : MonoBehaviour {
#if UNITY_IPHONE
	public static string SAVES_DIR = Application.dataPath + "/../../Documents/";
#else
	public static string SAVES_DIR = "Saves/";
#endif
	public static string DEFAULT_SAVE_FILE = "anyfluffy.xml";
	public static SaveData saveData = new SaveData();
	private static bool isLoadingSave = false;
	private static string lastSave;
	
	void Start() {
		createSavesDir();
	}
	
	void createSavesDir() {
		if(!System.IO.Directory.Exists(SaveDataModel.SAVES_DIR)) {
			System.IO.Directory.CreateDirectory(SaveDataModel.SAVES_DIR);
		}
	}
	
	public static FileInfo[] getSaves() {
		DirectoryInfo directoryInfo = new DirectoryInfo(SAVES_DIR);
		return directoryInfo.GetFiles();
	}
	
	static void saveToFile(string saveFile) {
		XMLManager.Save<SaveData>(saveData, SAVES_DIR+saveFile);
		lastSave = SAVES_DIR+saveFile;
		Debug.Log("Saving game");
	}
	
	static void prepareSaveData() {
		saveData.inventory = InventoryModel.use.getSerialisableInventory();
		saveData.sceneName = Application.loadedLevelName;
		saveData.stats = PlayerModel.use.getSerialisableParty();
		saveData.playerState = PlayerModel.use.state;
	}
	
	public static void save(string saveFile, string sceneName) {
		prepareSaveData();
		saveData.sceneName = sceneName;
		saveToFile(saveFile);
	}
	
	public static void save (string saveFile) {
		prepareSaveData();
		saveToFile(saveFile);
	}
	
	public static bool load (string saveFile) {
		string saveFilePath = "";
		if(!Debug.isDebugBuild) {
			saveFilePath = SAVES_DIR;
		}
		saveFilePath += saveFile;
		
		if(File.Exists(saveFilePath)) {
			saveData = XMLManager.Load<SaveData>(saveFilePath);
			Debug.Log("Loading game");
			lastSave = saveFile;
			PlayerModel.use.loadSerialisedParty(saveData.stats);
			PlayerModel.use.state = saveData.playerState;
			iKittenGUI.use.isActive = true;
			if(saveData.sceneName != Application.loadedLevelName) {
				SceneManager.loadScene(saveData.sceneName);
			}
			return true;
		} else {
			Debug.Log("No save file found - not loading.");
			return false;
		}
	}
	
	public static void loadScene() {
		Debug.Log("Loading Scene");
		Application.LoadLevel(saveData.sceneName);
		isLoadingSave = true;
	}
	
	public static void findLastSave() {
		System.DateTime latestDate = new System.DateTime(1970,01,01);
		foreach(FileInfo fileInfo in getSaves()) {
			if(latestDate.CompareTo(fileInfo.LastWriteTime) < 0) {
				latestDate = fileInfo.LastWriteTime;
				lastSave = fileInfo.ToString();
			}
		}
	}
	
	public static bool isLoading() {
		return isLoadingSave;
	}
	
	public static void finishLoading() {
		isLoadingSave = false;
	}
	
	public static string getLastSave() {
		if(lastSave == null) {
			findLastSave();
		}
		
		return lastSave;
	}
	
	public static void loadLastSave() {
		load(lastSave);
	}
}

