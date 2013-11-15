using UnityEngine;
using System;
using System.Collections;

public class ShopView : MonoBehaviour {
	public static ShopView use;
	public GUISkin customSkin;
	public bool isActive = true;
	public AudioClip buySound;

	GUIContent[] itemIcons;
	GUIStyle shopContainerStyle;
	GUIStyle itemStyle;
	GUIStyle itemBackgroundStyle;
	GUIStyle buyIconStyle;
	
	Rect shopContainerPos;
	Rect shopScrollViewPos;
	Rect buyButtonPos;
	Rect tooExpensiveMessagePos;
	Rect doneButtonPos;
	float shopScreenWidth;
	
	// Use this for initialization
	void Start () {
		itemStyle = customSkin.GetStyle("ItemIcon");
		itemBackgroundStyle = customSkin.GetStyle("ItemIconBackground");
		shopContainerStyle = customSkin.GetStyle("ShopContainer");
		buyIconStyle = customSkin.GetStyle("BuyIcon");
		shopScreenWidth = shopContainerStyle.fixedWidth;
		shopContainerPos = new Rect(shopContainerStyle.margin.left, shopContainerStyle.margin.top, shopScreenWidth, MobileDisplay.height-(shopContainerStyle.margin.top*2));
		shopScrollViewPos = new Rect(shopContainerPos.x, shopContainerPos.y+shopContainerStyle.fontSize*2, shopScreenWidth, shopContainerPos.height-shopContainerStyle.fontSize*2);
		buyButtonPos = new Rect(MobileDisplay.width-buyIconStyle.fixedWidth, MobileDisplay.height-buyIconStyle.fixedHeight, buyIconStyle.fixedWidth, buyIconStyle.fixedHeight);
		doneButtonPos = new Rect(MobileDisplay.width-100, 2, 100, 100);
		tooExpensiveMessagePos = new Rect(shopContainerPos.x+shopScreenWidth, 50, MobileDisplay.width-(shopContainerPos.x+shopScreenWidth), MobileDisplay.height-50);
		generateIcons();
		use = this;
	}
	
	bool iconsGenerated = false;
	void generateIcons() {
		int i = 0;
		itemIcons = new GUIContent[InventoryModel.use.obtainableItems.Values.Count/2];
		int itemId;
		Item item;
		foreach(string itemKey in InventoryModel.use.obtainableItems.Keys) {
			if(int.TryParse(itemKey, out itemId)) {
				item = InventoryModel.use.obtainableItems[""+itemId];
				itemIcons[i] = new GUIContent((item.getQuantity() > 0 ? "" : ""+item.cost), item.getIcon());
				i++;
			}
		}
		
		iconsGenerated = true;
		
	}
	
	void updateIcon(int itemIndex) {
		Item item = InventoryModel.use.obtainableItems[""+itemIndex];
		itemIcons[itemIndex] = new GUIContent((item.getQuantity() > 0 ? "" : ""+item.cost), item.getIcon());
	}
	
	Vector2 shopScrollPos;
	
	int itemSelectIndex = 0;
	int oldItemSelectIndex = 0;
	
	void OnGUI() {
		if(!iconsGenerated || iKittenModel.anyKitten == null || !isActive) {
			return;
		}
		
		GUI.skin = customSkin;
		
		if(InventoryModel.use.getInventoryChanged()) {
			generateIcons();
		}
		
		GUI.Box(shopContainerPos, "Items", "ShopContainer");
		GUI.BeginGroup(shopScrollViewPos, "", "ShopContainer");
		shopScrollPos = GUILayout.BeginScrollView(shopScrollPos, GUILayout.Width(shopScreenWidth), GUILayout.Height(shopScrollViewPos.height));
		
		if(Input.touchCount > 0) {
			if(Input.GetTouch(0).phase == TouchPhase.Moved) {
				shopScrollPos.y += Input.GetTouch(0).deltaPosition.y;
			}
		}
		
		itemSelectIndex = GUILayout.SelectionGrid(itemSelectIndex, itemIcons, 2, "ItemIconBackground");
		if(itemSelectIndex != oldItemSelectIndex) {
			iKittenModel.anyKitten.hideWornItems();
			iKittenModel.anyKitten.wearItem(InventoryModel.use.obtainableItems[""+itemSelectIndex].getInternalName());
			oldItemSelectIndex = itemSelectIndex;
		}

		
		GUILayout.EndScrollView();
		GUI.EndGroup();
		

		if(isOwnedItem(itemSelectIndex)) {
			iKittenModel.anyKitten.equipItem(itemSelectIndex);
		} else {
			if(GUI.Button(buyButtonPos, "", (isAffordableItem(itemSelectIndex) ? "BuyIcon" : "CannotBuyIcon"))) {
				if(isAffordableItem(itemSelectIndex)) {
					InventoryModel.use.buyItem(itemSelectIndex);
					MainSounds.use.audio.PlayOneShot(buySound);
					updateIcon(itemSelectIndex);
					iKittenModel.anyKitten.equipItem(itemSelectIndex);
				} else {
					iKittenGUI.use.displayMessage(tooExpensiveMessagePos,"You don't have enough points to buy that yet :(", "OK");
				}
			}
		}
		
		if(GUI.Button(doneButtonPos, "Done", "DoneButton")) {
			disable();
		}
	}
	
	public void disable() {
		iKittenGUI.use.hideScore();
		iKittenModel.anyKitten.hideWornItems();
		
		string equippedItemName = iKittenModel.anyKitten.getEquippedItemName();
		if(equippedItemName != "") {
			iKittenModel.anyKitten.wearItem(equippedItemName);
		}
		
		isActive = false;
	}
	
	public void enable() {
		iKittenGUI.use.showScore();
		isActive = true;
	}
	
	bool isAffordableItem(int itemIndex) {
		return PlayerModel.use.state.happyPoints >= InventoryModel.use.obtainableItems[""+itemIndex].cost;
	}
	
	bool isOwnedItem(int itemIndex) {
		return InventoryModel.use.obtainableItems[""+itemIndex].getQuantity() > 0;
	}
	
}
