using System;
using System.Collections;
using System.Collections.Generic;

[Serializable]
public class SaveData {
	public SerialisableDictionary<string, int> inventory;
	public string sceneName;
	public SerialisableDictionary<string, iKittenState> stats;
	public PlayerModelState playerState;
}