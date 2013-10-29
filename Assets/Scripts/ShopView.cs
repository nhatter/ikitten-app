using UnityEngine;
using System.Collections;

public class ShopView : MonoBehaviour {
	public GUISkin customSkin;

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
		shopContainerPos = new Rect(shopContainerStyle.margin.left, shopContainerStyle.margin.top, Screen.width/3, Screen.height-(shopContainerStyle.margin.top*2));
		shopScrollViewPos = new Rect(shopContainerPos.x, shopContainerPos.y+shopContainerStyle.fontSize*2, Screen.width/3, Screen.height-(shopContainerStyle.margin.top*2)-shopContainerStyle.fontSize*2);

	}
	
	Vector2 shopScrollPos;
	void OnGUI() {
		GUI.skin = customSkin;
		GUI.Box(shopContainerPos, "Shop", "ShopContainer");
		GUI.BeginGroup(shopScrollViewPos, "", "ShopContainer");
		shopScrollPos = GUILayout.BeginScrollView(shopScrollPos, GUILayout.Width(shopScreenWidth));
		GUILayout.BeginVertical();
			foreach(Item item in InventoryModel.use.obtainableItems.Values) {
				itemStyle.normal.background = item.getIcon();
				GUILayout.BeginHorizontal();

				if(GUILayout.Button("", itemStyle)) {
					iKittenModel.anyKitten.hideWornItems();
					iKittenModel.anyKitten.wearItem(item.name.Replace(" ", ""));
				}
			
				GUILayout.Label(""+item.cost, "ItemCost");
				GUILayout.EndHorizontal();

			}
		GUILayout.EndVertical();
		GUI.EndScrollView();
		GUI.EndGroup();
	}
}
