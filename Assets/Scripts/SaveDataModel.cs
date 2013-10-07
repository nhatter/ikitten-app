using UnityEngine;
using System.IO;

public class SaveDataModel : MonoBehaviour {
#if UNITY_IPHONE
	public static string SAVES_DIR = Application.dataPath + "/../../Documents/";
#else
	public static string SAVES_DIR = "Saves/";
#endif

	public static SaveData saveData = new SaveData();
	private static bool isLoadingSave = false;
	private static string lastSave;
	
	void Start() {
		createSavesDir();
		load(SAVES_DIR+"iKitten.xml");
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
	
	public static void save (string saveFile) {
		saveData.inventory = InventoryModel.use.getSerialisableInventory();
		saveData.levelName = Application.loadedLevelName;
		saveData.stats = PlayerModel.use.getSerialisableParty();
		XMLManager.Save<SaveData>(saveData, SAVES_DIR+saveFile);
		lastSave = SAVES_DIR+saveFile;
		Debug.Log("Saving game");
	}
	
	public static void load (string saveFile) {
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
			//loadScene();
		} else {
			Debug.Log("No save file found - not loading.");
		}
	}
	
	public static void loadScene() {
		Debug.Log("Loading Scene");
		Application.LoadLevel(saveData.levelName);
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

