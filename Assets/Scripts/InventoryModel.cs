using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Serialization;


public class InventoryModel : MonoBehaviour {
	public AudioClip foundItemSound;
	
	public static InventoryModel use;
	static string ITEMS_XML = "items";
	public Dictionary<string, Item> obtainableItems = new Dictionary<string, Item>();
	private GameObject foundItem;
	private bool hasInventoryChanged = false;
	
	void Start() {
		loadObtainableItems();
		use = this;
	}
	
	public void loadUsableItems() {

	}
	
	public void addItem(string itemKey) {
		string itemName = itemKey;
		if(itemKey.Contains("_")) {
			string[] itemValues = itemKey.Split('_');
			itemName = itemValues[0];
		}
		
		Item item;
		if(obtainableItems.TryGetValue(itemName, out item)) {
			int quantity = item.getQuantity();
			item.setQuantity(++quantity);
		} else {
			Debug.Log(itemKey+" does not have an inventory entry. Cannot add to inventory.");
		}
	}
	
	public void setFoundItem(GameObject newItem) {
		foundItem = newItem;
		audio.PlayOneShot(foundItemSound);
	}
	
	public GameObject getFoundItem() {
		return foundItem;
	}

	public void resetFoundItem() {
		foundItem = null;
	}

	public SerialisableDictionary<string, int> getSerialisableInventory() {
		SerialisableDictionary<string, int> inventory = new SerialisableDictionary<string, int>();
		foreach(Item item in obtainableItems.Values) {
			if(item.getQuantity() > 0) {
				inventory.Add(item.getName(), item.getQuantity());
			}
		}
		
		return inventory;
	}
	
	public Dictionary<string, Item> getInventory() {
		Dictionary<string, Item> inventory = new Dictionary<string, Item>();
		Item storedItem;
		foreach(Item item in obtainableItems.Values) {
			if(item.getQuantity() > 0) {
				if(inventory.TryGetValue(item.getName(), out storedItem)) {
					inventory.Remove(item.getName());
					item.setQuantity(storedItem.getQuantity()+item.getQuantity());
					inventory.Add(item.getName(), item);
				} else {
					inventory.Add(item.getName(), item);
				}
			}
		}
		
		return inventory;
	}
	
	public void loadObtainableItems() {
		TextAsset textAsset = (TextAsset) Resources.Load(ITEMS_XML, typeof(TextAsset));
		ItemsXMLContainer storedItemsContainer = XMLManager.LoadFromText<ItemsXMLContainer>(textAsset.text);
		foreach(Item item in storedItemsContainer.items) {
			obtainableItems.Add(item.getName(), item);
			Debug.Log ("ID "+item.getName());
		}
	}
	
	public void loadInventory(SerialisableDictionary<string, int> inventory) {
		foreach(KeyValuePair<string, int> storedItem in inventory) {
			Item item;
			if(obtainableItems.TryGetValue(storedItem.Key, out item)) {
				obtainableItems.Remove(storedItem.Key);
				item.setQuantity(storedItem.Value);
				obtainableItems.Add(storedItem.Key, item);
			}
		}
	}
	
	public bool getInventoryChanged() {
		if(hasInventoryChanged) {
			hasInventoryChanged = false;
			return true;
		}
		
		return false;
	}
	
	public void setInventoryChanged() {
		hasInventoryChanged = true;
	}
}
