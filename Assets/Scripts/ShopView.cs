using UnityEngine;
using System.Collections;

public class ShopView : MonoBehaviour {
	public GUISkin customSkin;
	
	GUIContent[] itemIcons;
	GUIStyle shopContainerStyle;
	GUIStyle itemStyle;
	GUIStyle itemBackgroundStyle;
	
	Rect shopContainerPos;
	Rect shopScrollViewPos;
	int shopScreenWidth = Mathf.RoundToInt(Screen.width/3);
	
	// Use this for initialization
	void Start () {
		itemStyle = customSkin.GetStyle("ItemIcon");
		itemBackgroundStyle = customSkin.GetStyle("ItemIconBackground");
		shopContainerStyle = customSkin.GetStyle("ShopContainer");
		shopContainerPos = new Rect(shopContainerStyle.margin.left, shopContainerStyle.margin.top, shopContainerStyle.fixedWidth, Screen.height-(shopContainerStyle.margin.top*2));
		shopScrollViewPos = new Rect(shopContainerPos.x, shopContainerPos.y+shopContainerStyle.fontSize*2, shopContainerStyle.fixedWidth, shopContainerPos.height-shopContainerStyle.fontSize*2);
		
		generateIcons();
	}
	
	bool iconsGenerated = false;
	void generateIcons() {
		int i = 0;
		itemIcons = new GUIContent[InventoryModel.use.obtainableItems.Values.Count];
		
		foreach(Item item in InventoryModel.use.obtainableItems.Values) {
			itemIcons[i] = new GUIContent(""+item.cost, item.getIcon());
			i++;
		}
		
		iconsGenerated = true;
		
	}
	
	Vector2 shopScrollPos;
	
	int itemSelectIndex = 0;
	int oldItemSelectIndex = 0;
	
	void OnGUI() {
		if(!iconsGenerated) {
			return;
		}
		
		GUI.skin = customSkin;
		GUI.Box(shopContainerPos, "Shop", "ShopContainer");
		GUI.BeginGroup(shopScrollViewPos, "", "ShopContainer");
		shopScrollPos = GUILayout.BeginScrollView(shopScrollPos, GUILayout.Width(shopScreenWidth), GUILayout.Height(shopScrollViewPos.height));
		
		itemSelectIndex = GUILayout.SelectionGrid(itemSelectIndex, itemIcons, 2, "ItemIconBackground");
		if(itemSelectIndex != oldItemSelectIndex) {
			iKittenModel.anyKitten.hideWornItems();
			iKittenModel.anyKitten.wearItem(InventoryModel.use.obtainableItemsArray[itemSelectIndex].getInternalName());
			oldItemSelectIndex = itemSelectIndex;
		}

		
		GUILayout.EndScrollView();
		GUI.EndGroup();
	}
}
