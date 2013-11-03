using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Serialization;


public class InventoryModel : MonoBehaviour {
	string ITEM_ICONS_PATH = "Shop/Icons/";
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
	
	public void buyItem(int itemId) {
		addItem(obtainableItems[""+itemId].getName(), true);
	}
	
	public void addItem(string itemKey, bool isPurchase) {
		string itemName = itemKey;
		if(itemKey.Contains("_")) {
			string[] itemValues = itemKey.Split('_');
			itemName = itemValues[0];
		}
		
		Item item;
		if(obtainableItems.TryGetValue(itemName, out item)) {
			int quantity = item.getQuantity();
			obtainableItems[itemName].setQuantity(++quantity);
			
			if(isPurchase) {
				PlayerModel.use.state.happyPoints -= item.cost;
			}
			
			hasInventoryChanged = true;
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
				if(!inventory.ContainsKey(item.getName())) {
					inventory.Add(item.getName(), item.getQuantity());
				}
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
		
		int itemId = 0;
		foreach(Item item in storedItemsContainer.items) {
			item.setIcon((Texture2D) Resources.Load(ITEM_ICONS_PATH+"Hats/"+item.name.Replace(" ","")));
			obtainableItems.Add(item.getName(), item);
			obtainableItems.Add(""+itemId, item);
			itemId++;
		}
		
		hasInventoryChanged = true;
	}
	
	public void loadInventory(SerialisableDictionary<string, int> inventory) {
		foreach(KeyValuePair<string, int> storedItem in inventory) {
			if(obtainableItems.ContainsKey(storedItem.Key)) {
				obtainableItems[storedItem.Key].setQuantity(storedItem.Value);
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
