using System;
using System.Collections;
using System.Collections.Generic;

[Serializable]
public class SaveData {
	public SerialisableDictionary<string, int> inventory;
	public string levelName;
	public SerialisableDictionary<string, iKittenState> stats;
}