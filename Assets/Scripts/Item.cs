using UnityEngine;

public class Item {
	public string name;
	public string description = "";
	public bool isKeyItem = false;
	private int quantity;
	
	public Item() {}
	
	public Item(string name, string description) {
		this.name = name;
		this.description = description;
	}
	
	public Item(string name) {
		this.name = name;
	}
	
	public string getName() {
		return name;
	}
	
	public string getDescription() {
		return description;
	}
	
	public static string generateID(string itemName) {
		return (Application.loadedLevelName+"_"+itemName);
	}
	
	public int getQuantity() {
		return quantity;
	}
	
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public bool getKeyItem() {
		return isKeyItem;
	}
}
