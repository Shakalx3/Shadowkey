{ 
	mainTitleItem
	menuActionPopup
	activeInventoryItem
	inventoryInfoPopup
	weaponsButton
	armorButton
	miscItemsButton
	consumableItemsButton
	spellsButton
	quitButton
	inventoryTable
	inventory
	activeButton
	confirmDropPopup
	defaultError[4058]
	errorPopup
	bIsEqupping[true]

	
	Init[ (s)
	{		
		MenuBackground(20);		
	} ]
	
	OnRightSoftKey[ (s)
	{
		MenuBack();
	} ]
		
	OnDisplay[ (s)
	{
		ClearMenu();
		image_item_active=24;
		image_item_dormant=25;
			
		x=3;
		y=10;
		
		mainTitleItem=AddTitle( 3802 );
		
		y = y + 15;		
		weaponsButton=AddButton( "", "WeaponsMenu", x, y, 47, 48);
		weaponsButton.SetActive(true);
		
		offsetX = 34;
		x = x + offsetX;
		armorButton=AddButton( "", "ArmorMenu", x, y, 49, 50);
				
		x = x + offsetX;
		consumableItemsButton=AddButton( "", "ConsumablesMenu", x, y, 51, 52);
		
		x = x + offsetX;
		spellsButton=AddButton( "", "SpellMenu", x, y, 53, 54);
		
		x = x + offsetX;
		miscItemsButton=AddButton( "", "MiscItemsMenu", x, y, 51, 52);
				
		y = y + 35;
		//AddInventoryListBox(0, y, 20, 4, "SelectedInventoryItem", true);			
		inventoryTable=AddTable(1, 5, 60, 180, 115);
		inventoryTable.AddColumn(140); //product name
		inventoryTable.AddColumn(70);  //title
		//inventoryTable.AddColumn(10);  //rating left
		//inventoryTable.AddColumn(10);  //rating right
		inventoryTable.SetCallback("SelectedInventoryItem");
		inventoryTable.SetRowSelect(true);
		inventoryTable.AutoWrapCells(false);
		//inventoryTable.SetLineWrap(true);
		
		SetInventoryList(inventoryTable);
				
		menuActionPopup = CreatePopupMenu(10,0,120,70,false);
		menuActionPopup.SetBackground();
		menuActionPopup.AddItem(3297,"UseItem");
		menuActionPopup.AddItem(4015,"PerformEquipAction");
		menuActionPopup.AddItem(4016,"DropInventoryItem");
		menuActionPopup.AddItem(4004,"ViewInventoryDescription");
		//menuActionPopup.AddItem(4017,"SendItem");
		menuActionPopup.AddItem(3281,"CloseMenuActionPopup");
		menuActionPopup.SetBack("CloseMenuActionPopup");
		menuActionPopup.SetVisible(false);	
		
		inventoryInfoPopup=CreatePopupMenu(0,0,150,60,false);
		inventoryInfoPopup.SetBackground();
		inventoryInfoPopup.AddItem(4007);
		inventoryInfoPopup.AddItem(3281,"CloseInfoPopup");		
		inventoryInfoPopup.SetVisible(false);
		inventoryInfoPopup.SetBack("CloseInfoPopup");
		inventoryInfoPopup.SetAutoAdjust(true);
				
		confirmDropPopup=CreatePopupMenu(0,0,150,60,false);
		confirmDropPopup.SetBackground();
		confirmDropPopup.AddItem(3961);
		confirmDropPopup.AddItem(1389,"CancelDrop");
		confirmDropPopup.AddItem(1375,"ConfirmDrop");				
		confirmDropPopup.SetVisible(false);
		confirmDropPopup.SetBack("CloseDropBox");
		confirmDropPopup.SetAutoAdjust(true);
						
		errorPopup=CreatePopupMenu(5,30,150,60,false);
		errorPopup.AddItem(defaultError,"");
		errorPopup.AddItem(3281,"HideErrorPopup");
		errorPopup.SetSelectable(0,false);
		errorPopup.SetSelectedItem(1);
		errorPopup.SetBack("HideErrorPopup");
		errorPopup.SetVisible(false);
								
		quitButton=AddQuitButton(3281,"MenuBack");
		
		self.WeaponsMenu();

		//ondisplay	
		menuActionPopup.SetVisible(false);
		inventoryInfoPopup.SetVisible(false);	
		self.WeaponsMenu();
		SetSelectedItem(weaponsButton);
		weaponsButton.SetActive(true);
	} ]


	MenuBack[ (s)
	{
		DisplayCharacterManager();
	} ]

	InventoryBack[ (s)
	{
		DisplayCharacterManager();
	} ]
		
	
	ArmorMenu[ (s)
	{
		mainTitleItem.SetLocalizedText(2991); //armor
		DisplayArmorMenu(armorButton);
		activeButton=armorButton;
	} ]	
	
	MiscItemsMenu[ (s)
	{
		mainTitleItem.SetLocalizedText(3804); //misc
		DisplayMiscItemsMenu(miscItemsButton);
		activeButton=miscItemsButton;
	} ]	
	
	ConsumablesMenu[ (s)
	{
		mainTitleItem.SetLocalizedText(3803); //consumable
		DisplayConsumablesMenu(consumableItemsButton);
		activeButton=consumableItemsButton;
	} ]		
	
	SpellMenu[ (s)
	{
		mainTitleItem.SetLocalizedText(2992);//spells
		DisplaySpellsPage(spellsButton);
		activeButton=spellsButton;
	} ]	
		
	WeaponsMenu[ (s)
	{
		mainTitleItem.SetLocalizedText(2990);
		DisplayWeaponsPage(weaponsButton);
		activeButton=weaponsButton;
	} ]
			
	SelectedInventoryItem[ ()
	{
		activeInventoryItem=inventoryTable.GetSelectedRow();
		inv = activeInventoryItem.GetAssociatedObject();
		menuActionPopup.SetToWidget(inventoryTable,10);
		menuActionPopup.UpdatePopupItem(2,"");
		
		if (inv != null)
		{
			type = inv.GetItemType();
			
			//is equipped in queue, etc
			bIsEquipped = activeInventoryItem.IsInventoryEquipped();
			bEnabled = activeInventoryItem.IsItemEnabledFor();
			menuActionPopup.SetSelectable(0, true);
			menuActionPopup.UpdatePopupItem(0,""); //Use
			bIsEqupping=true;
			
			if (inv.CanDrop() = false)
			{
				menuActionPopup.UpdatePopupItem(2,"");
			}
			else
			{
				menuActionPopup.UpdatePopupItem(2,4016);
			}
			
			if (bEnabled = false)
			{				
				menuActionPopup.UpdatePopupItem(0,"");
				menuActionPopup.UpdatePopupItem(1,"");
				menuActionPopup.SetVisible(true); 			
				return;				
			}
			
			if (type = 0)
			{
				bTravel = inv.CanTravel();
				if (not bTravel)
				{
					menuActionPopup.UpdatePopupItem(0,"");
					menuActionPopup.UpdatePopupItem(1,"");
					menuActionPopup.SetVisible(true); 
					return;
				}
			}
			
			if (type = 4) //IPT_Consumable
			{
				menuActionPopup.UpdatePopupItem(0,564); //Use
				menuActionPopup.SetVisible(true); 
			}
			
			if (type = 3) //IPT_Armor
			{
				karmor=inv.GetArmorText();
				menuActionPopup.SetVisible(true); 
				equipText = GetLocalizedString(3774)#" "; //Equip				
				if (bIsEquipped = true)
				{
					equipText = GetLocalizedString(3805)#" "; //UnEquip
					bIsEqupping=false;
				}
				
				menuActionPopup.UpdatePopupItem(1,equipText#karmor);
				return;															
			}
			else
			{				
				if (bEnabled = true)
				{
					if (bIsEquipped = true)
					{
						menuActionPopup.UpdatePopupItem(1,3805); //Unequip
						bIsEqupping=false;
					}
					else
					{
						menuActionPopup.UpdatePopupItem(1,3774); //Equip
					}
				}
			}
		}
		
		menuActionPopup.SetVisible(true); 
	} ]		
	
	CloseMenuActionPopup[ (s)
	{
		menuActionPopup.SetVisible(false);
		//SetFocusToFirstItem();
		SetSelectedItem(inventoryTable);
		RedrawPage(false);
	}]
	
	CheckForMsg[ ()
	{
		msgPopup=GetMessagePopup();
		if (msgPopup != null)
		{
			bShowingMsg=msgPopup.IsVisible();
		}
		else
		{
			bShowingMsg = false;
		}
		
		self.CloseMenuActionPopup();
		if (bShowingMsg = true)
		{
			msgPopup.SetVisible(true);
		}			
	}]
	
	UseItem[ ()
	{
		inv=activeInventoryItem.GetAssociatedObject();
		inventoryTable.RemoveRow(activeInventoryItem); //removes this row						
		inv.OnUsedBy(GetPlayer()); //call native function on consumable
		CheckForMsg();	
		//SetSelectedItem(consumableItemsButton);	
		rows = inventoryTable.GetMaxRows();
		if (rows > 0)
		{
			SetSelectedItem(inventoryTable);
		}
		else
		{
			SetSelectedItem(activeButton);
		}
	}]
	
	PerformEquipAction[ (s)
	{
		inv=activeInventoryItem.GetAssociatedObject();
		ret = UpdateEquipStatus(inv, bIsEqupping);
		if (ret = 2)
		{
			menuActionPopup.SetVisible(false);
			errorPopup.SetVisible(true);
			errorPopup.SetSelectedItem(1);	
			return;	
		}
		if (ret = 3)
		{
			//can't equip - just close menus
			menuActionPopup.SetVisible(false);
			return;
		}
		
		CheckForMsg();
	}]
	
	ConfirmDrop[ ()
	{
		//inventory=activeInventoryItem.GetAssociatedObject();
		activeInventoryItem.DropItem();
		confirmDropPopup.SetVisible(0);
		self.CloseMenuActionPopup();
		SetSelectedItem(weaponsButton);	
	}]
	
	CancelDrop[ ()
	{
		confirmDropPopup.SetVisible(0);
		SetSelectedItem(inventoryTable);
	}] 
	
	DropInventoryItem[ ()
	{
		//confirm drop
		inv = activeInventoryItem.GetAssociatedObject();
		if (inv.CanDrop() = false)
		{
			confirmDropPopup.SetVisible(0);
			self.CloseMenuActionPopup();		
			return;
		}
		
		self.CloseMenuActionPopup();
		confirmDropPopup.SetSelectable(0,false);
		confirmDropPopup.SetVisible(true);
		confirmDropPopup.SetToWidget(inventoryTable,5);
		confirmDropPopup.SetSelectedItem(1);
	}]
	
	ViewInventoryDescription[ (s)
	{
		description=activeInventoryItem.GetItemDescription();
		inventoryInfoPopup.UpdatePopupItem(0,description);
		inventoryInfoPopup.SetToWidget(inventoryTable,5);
		inventoryInfoPopup.SetSelectable(0, false);
		inventoryInfoPopup.SetVisible(true);
		inventoryInfoPopup.SetSelectedItem(1);
		menuActionPopup.SetVisible(false);
	}]
	
	
	CloseInfoPopup[ (s)
	{
		inventoryInfoPopup.SetVisible(false);
		//SetSelectedItem(inventoryTable);
		//RedrawPage();
		SetSelectedItem(inventoryTable);
	}]	
	
	OnMsgPopupClosed[ ()
	{
		menuActionPopup.SetVisible(false);
		inventoryInfoPopup.SetVisible(false);
		RedrawPage(false);
		SetSelectedItem(inventoryTable);
	}]
	
	CloseDropBox[ ()
	{
		confirmDropPopup.SetVisible(false);
		SetSelectedItem(inventoryTable);	
	}]
	
	HideErrorPopup[ ()
	{
		errorPopup.SetVisible(false);
		SetSelectedItem(inventoryTable);
	}]	
}