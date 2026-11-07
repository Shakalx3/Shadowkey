{
	firstItem
	modeItem
	selectedItem
	titleItem
	gpItem
	popup
	activeButton
	weaponsButton
	armorButton
	miscItemsButton
	consumableItemsButton
	spellsButton
	inventoryInfoPopup
	quitButton
	msgPopup
	quantity[1]
	productTable
	offsetX[35]
	originX[3]
	
	Init[ (s)
	{	
		MenuBackground(20);
	} ]

	BuySellBack[ (s)
	{
		MenuBack();
	} ]

	OnRightSoftKey[ (s)
	{
		MenuBack();
	} ]
	
	MenuBack[ (s)
	{
		Quit();
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		image_item_active=24;
		image_item_dormant=25;
		
		//originX=5;
		x=originX;
		y=10;
		offsetY=15;
				
		modeItem=AddFloatingText("Sell", "", x, y, false);
		titleItem=AddFloatingText("(Weapons)", "", 35, y, false);
		
		x=x+105;
		gpItem=AddFloatingText("0 gp", "", x, y, false);
				
		x=originX;
		y=y+offsetY;		
			
		weaponsButton=AddButton( "", "WeaponsMenu", x, y, 47, 48);
		weaponsButton.SetActive(true);
				
		//offsetX = 35;
		x = x + offsetX;
		armorButton=AddButton( "", "ArmorMenu", x, y, 49, 50);
		
		//x = x + offsetX;
		//miscItemsButton=AddButton( "3", "MiscItemsMenu", x, y, image_item_active, image_item_dormant);
		
		x = x + offsetX;
		consumableItemsButton=AddButton( "", "ConsumablesMenu", x, y, 51, 52);
		
		x = x + offsetX;
		spellsButton=AddButton( "", "SpellMenu", x, y, 53, 54);
				
		y = y + 35;
		//AddInventoryListBox(0, y, 20, 5, "SelectedItem");			
		productTable=AddTable(12, 5, 60, 180, 115);
		productTable.AddColumn(140); //product
		productTable.AddColumn(150);  //cost
		//productTable.AddColumn(80);  //quantity
		productTable.AddColumn(10);  //rating left
		productTable.AddColumn(10);  //rating right
		productTable.SetRowSelect(true);
		//productTable.SetLineWrap(true);
		productTable.SetCallback("SelectedItem");
		productTable.SetInset(15); //adjust down arrow within height
		productTable.AutoWrapCells(false);
		
		SetInventoryList(productTable);
		
		y=100;						
		popup=CreatePopupMenu(15,y,150,60,false);
		popup.SetBackground();
		popup.AddItem(4003);
		popup.AddItem(4003);	
		popup.AddItem(4004,"ShowPopup");	
		popup.AddItem(3281,"CancelPurchase");
		popup.SetBack("HideMainPopup");
		popup.SetVisible(false);
		
		inventoryInfoPopup=CreatePopupMenu(10,0,150,75,false);
		inventoryInfoPopup.SetBackground();
		inventoryInfoPopup.AddItem(4005);
		inventoryInfoPopup.AddItem(4006);
		inventoryInfoPopup.AddItem(4007);
		inventoryInfoPopup.SetSelectable(0,false);
		inventoryInfoPopup.SetSelectable(1,false);
		inventoryInfoPopup.SetSelectable(2,false);		
		inventoryInfoPopup.AddItem(3281,"CloseInfoPopup");	
		inventoryInfoPopup.SetSelectedItem(3);	
		inventoryInfoPopup.SetVisible(false);
		inventoryInfoPopup.SetBack("CloseInfoPopup");
		inventoryInfoPopup.SetAutoAdjust(true);
						
		msgPopup=CreatePopupMenu(4,60,170,60,false);
		msgPopup.SetBackground();
		msgPopup.AddItem(3297,"CloseMsgPopup");	//message
		msgPopup.AddItem(3297,"ForcePurchase");   //buy anyway
		msgPopup.AddItem(3297,"CloseMsgPopup");   //cancel
		msgPopup.SetBack("CloseMsgPopup");
		msgPopup.SetVisible(false);
		msgPopup.SetAutoAdjust(true);
								
		quitButton=AddQuitButton(3281,"MenuBack");					
	
		//ondisplay
		//hide all popups
		popup.SetVisible(false);
		msgPopup.SetVisible(false);
		inventoryInfoPopup.SetVisible(false);
			
		bBuyMode=IsBuyMode();
		
		x=originX;
		
		weaponCount = GetPlayer().GetProductCount(1); //IPT_Weapon	
		if (weaponCount = 0)
		{
			weaponsButton.SetVisible(false);
		}
		else
		{
			weaponsButton.SetX(x);
			x = x + offsetX;
		}					
				
		armorCount = GetPlayer().GetProductCount(3); //IPT_Armor	
		if (armorCount = 0)
		{
			armorButton.SetVisible(false);
		}
		else
		{
			armorButton.SetX(x);
			x = x + offsetX;			
		}
			
		potionCount = GetPlayer().GetProductCount(4); //IPT_Consumable	
		if (potionCount = 0)
		{
			consumableItemsButton.SetVisible(false);
		}
		else
		{
			consumableItemsButton.SetX(x);
			x = x + offsetX;			
		}
		
		spellCount = GetPlayer().GetProductCount(2); //IPT_Spell	
		if (spellCount = 0)
		{
			spellsButton.SetVisible(false);
		}
		else
		{
			spellsButton.SetX(x);
			x = x + offsetX;			
		}
				
		defaultStore = GetPlayer().GetDefaultStore();
																		
		if (bBuyMode=true)
		{
			popup.UpdatePopupItem(0, 3787,"BuyInv"); //buy
			popup.UpdatePopupItem(1, 3788,"BuyFiveItems"); //buy 5	
			modeItem.SetItemText("Buy");		
		}
		else
		{
			popup.UpdatePopupItem(0, 3789,"SellItem"); //sell
			//popup.UpdatePopupItem(1, 3790,"SellAll");	
			popup.UpdatePopupItem(1, "");	
			modeItem.SetItemText("Sell");		
		}
		
		SetGoldText(gpItem);
		//self.WeaponsMenu();
		//SetSelectedItem(weaponsButton);
		//weaponsButton.SetActive(true);
		
		if (defaultStore = 1)
		{
			self.WeaponsMenu();
			SetSelectedItem(weaponsButton);
		}
		if (defaultStore = 2)
		{
			self.SpellMenu();
			SetSelectedItem(spellsButton);
		}
		if (defaultStore = 3)
		{
			self.ArmorMenu();
			SetSelectedItem(armorButton);
		}
		if (defaultStore = 4)
		{
			self.ConsumablesMenu();
			SetSelectedItem(consumableItemsButton);
		}
				
		quitButton.SetVisible(true);
	}]
	
	WeaponsMenu[ ()
	{
		titleItem.SetLocalizedText(2990);
		DisplayWeaponsPage(weaponsButton);
		activeButton=weaponsButton;
	}]	

	ArmorMenu[ (s)
	{
		titleItem.SetLocalizedText(2991);
		DisplayArmorMenu(armorButton);
		activeButton=armorButton;
	} ]	
	
	MiscItemsMenu[ (s)
	{
		titleItem.SetLocalizedText(2994);
		DisplayMiscItemsMenu(miscItemsButton);
		activeButton=miscItemsButton;
	} ]	
	
	ConsumablesMenu[ (s)
	{
		titleItem.SetLocalizedText(2993);
		DisplayConsumablesMenu(consumableItemsButton);
		activeButton=consumableItemsButton;
	} ]		
	
	SpellMenu[ (s)
	{
		titleItem.SetLocalizedText(2992);
		DisplaySpellsPage(spellsButton);
		activeButton=spellsButton;
	} ]
		
	SelectedItem[ (cell)
	{
		quantity=1;	//reset # of items to buy
		//selectedItem=GetSelectedItem();
		selectedItem=cell;
		popup.SetSelectedItem(-1); //reset
		popup.SetVisible(true);	
		popup.SetToWidget(productTable,5);		
	}]
	
	BuyFiveItems[ ()
	{
		quantity=5;
		BuyInv();			
	} ]
	
	BuyInv[ ()
	{
		itemText=selectedItem.GetItemText();	
		//inv=selectedItem.GetAssociatedObject();
		//bCanUse = GetPlayer().IsItemEnabledFor(inv);
		bCanUse = selectedItem.IsItemEnabledFor();
		msgPopup.SetSelectable(0, true); //reset
		msgPopup.SetSelectable(1, true); //reset
		
		
		if (bCanUse = false)
		{			
			msgPopup.UpdatePopupItem(0, 3791); //your trade cannot use
			msgPopup.UpdatePopupItem(1, 3792);//Buy Anyway
			msgPopup.UpdatePopupItem(2, 3793);
			msgPopup.SetFocus(1);
			msgPopup.SetSelectable(0, false);
			msgPopup.SetVisible(true);
			return;
		}
		
		bBoughtItem=GetPlayer().BuyItem(itemText, quantity);	
		SetGoldText(gpItem);	
		msgPopup.SetVisible(true);
		
		if (bBoughtItem = 1)
		{
			//if (quantity = 5)
			msgPopup.UpdatePopupItem(0, GetLocalizedString(3794)#" "#itemText);
			msgPopup.UpdatePopupItem(1, GetLocalizedString(4080)#" "#quantity);
			
			msgPopup.SetSelectable(0, false);
			msgPopup.SetSelectable(1, false);
			//GetPlayer().PlaySound(60);		
		}
		if (bBoughtItem = 0)
		{
			msgPopup.UpdatePopupItem(0, 3795);//Not Enough Gold!
			msgPopup.UpdatePopupItem(1, "");
		}
		if (bBoughtItem = 2)
		{
			msgPopup.UpdatePopupItem(0, 3796);//not have that much in stock.
			msgPopup.UpdatePopupItem(1, "");
		}
		if (bBoughtItem = 3)
		{
			msgPopup.UpdatePopupItem(0, 3797);//You do not have enough room in your inventory.
			msgPopup.UpdatePopupItem(1, "");
		}
					
		//msgPopup.UpdatePopupItem(1, "");
		msgPopup.UpdatePopupItem(2, 3281);
		msgPopup.SetSelectedItem(2);
										
		HidePopup();
	}]
	
	ForcePurchase[ ()
	{
		itemText=selectedItem.GetItemText();							
		bBoughtItem=GetPlayer().BuyItem(itemText, quantity);	
		msgPopup.SetSelectable(0, true); //reset
		SetGoldText(gpItem);
		
		if (bBoughtItem = 1)
		{
			msgPopup.UpdatePopupItem(0, GetLocalizedString(3794)#" "#itemText);
			msgPopup.UpdatePopupItem(1, GetLocalizedString(4080)#" "#quantity);
			
			msgPopup.SetSelectable(0, false);
			msgPopup.SetSelectable(1, false);		
			msgPopup.SetVisible(true);
			//GetPlayer().PlaySound(60);		
		}
		if (bBoughtItem = 0)
		{
			msgPopup.UpdatePopupItem(0, 3795); //not enough gold
			msgPopup.SetVisible(true);
		}
		if (bBoughtItem = 2)
		{
			msgPopup.UpdatePopupItem(0, 3796);
			msgPopup.SetVisible(true);
		}
		if (bBoughtItem = 3)
		{
			msgPopup.UpdatePopupItem(0, 3797);
			msgPopup.SetVisible(true);
		}
				
		msgPopup.SetSelectable(0, false);			
		msgPopup.UpdatePopupItem(1, "");
		msgPopup.UpdatePopupItem(2, 3281);
		msgPopup.SetSelectedItem(2);
									
		HidePopup();		
	}]
		
	SellItem[ ()
	{
		inventory=selectedItem.GetAssociatedObject();
		if (inventory!=null)
		{	
			cost=inventory.GetMarketValue();	
			itemText=inventory.GetName();	
			bSoldItem=GetPlayer().SellItem(inventory);
			SetGoldText(gpItem);
			
			if (bSoldItem > 0)
			{
				msgPopup.UpdatePopupItem(0, GetLocalizedString(3798)#" "#itemText);
				msgPopup.UpdatePopupItem(1, GetLocalizedString(4080)#" "#bSoldItem);
			
				msgPopup.SetSelectable(0, false);
				msgPopup.SetSelectable(1, false);		
				
				msgPopup.SetVisible(true);
				//GetPlayer().PlaySound(60);				
			}
			else
			{
				msgPopup.UpdatePopupItem(0, 3799);//The merchant is not interested in purchasing the item.	
				msgPopup.UpdatePopupItem(1, "");
				msgPopup.SetVisible(true);				
			}		
						
			msgPopup.UpdatePopupItem(2, 3281);
			msgPopup.SetSelectedItem(2);				
		}
		
		HidePopup();
	}]
	
	SellAll[ ()
	{
		inventory=selectedItem.GetAssociatedObject();
		itemText=inventory.GetName();
		bSoldAll=GetPlayer().SellAllItems(inventory);
		SetGoldText(gpItem);
		
		if (bSoldAll > 0)
		{
			msgPopup.SetVisible(true);
			msgPopup.UpdatePopupItem(0, GetLocalizedString(3798)#" "#itemText);
			msgPopup.UpdatePopupItem(1, GetLocalizedString(4080)#" "#bSoldAll);
			
			msgPopup.SetSelectable(0, false);
			msgPopup.SetSelectable(1, false);
			//GetPlayer().PlaySound(60);		
		}
		else
		{			
			msgPopup.UpdatePopupItem(0, 3801);	
			msgPopup.UpdatePopupItem(1, "");
			msgPopup.SetSelectable(0, false);
		}
				
		msgPopup.SetVisible(true);		
		msgPopup.UpdatePopupItem(2, 3281);
		msgPopup.SetSelectedItem(2);							
		HidePopup();	
	}]
	
	CheckFocus[ ()
	{
		rows=productTable.GetMaxRows();
		if (rows > 0)
		{
			SetSelectedItem(productTable);
		}
		else
		{
			SetSelectedItem(activeButton);
		}	
	}]
	
	ShowPopup[ (s)
	{
		itemName=selectedItem.GetItemText();
		//myItem=GetPlayer().GetProduct(itemName);
		description=GetPlayer().GetItemDescription(itemName);
		//itemLongName=myItem.GetName();
		inventoryInfoPopup.UpdatePopupItem(0,itemName);
		inventoryInfoPopup.UpdatePopupItem(2,description);
		inventoryInfoPopup.SetSelectable(0, false);
		inventoryInfoPopup.SetSelectable(1, false);
		inventoryInfoPopup.SetFocus(3);
		inventoryInfoPopup.SetToWidget(productTable,5);
		//OverlapPopupMenu(inventoryInfoPopup);
		inventoryInfoPopup.SetVisible(true);
		popup.SetVisible(false);
		//selectedItem.SetVisible(false);
	}]

	CloseInfoPopup[ (s)
	{
		inventoryInfoPopup.SetVisible(false);
		//SetSelectedItem(weaponsButton);
		//RedrawPage();
		SetSelectedItem(productTable);
	}]
			
	HidePopup[ ()
	{
		popup.SetVisible(false);
		//msgPopup.SetVisible(false);
		//self.OnDisplay();	
		//SetSelectedItem(productTable);
	}]
	
	CancelPurchase[ ()
	{
		popup.SetVisible(false);
		SetSelectedItem(productTable);	
	}]

	HideMainPopup[ ()
	{
		popup.SetVisible(false);
		msgPopup.SetVisible(false);
		SetSelectedItem(productTable);
	}]
	
	CloseMsgPopup[ ()
	{
		popup.SetVisible(false);
		msgPopup.SetVisible(false);
		inventoryInfoPopup.SetVisible(false);
		//self.OnDisplay();		
		RedrawPage(false);
		SetSelectedItem(productTable);
		CheckFocus();
	}]
}