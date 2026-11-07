{
	firstItem
	selectedItem
	popup
	quitButton
	
	Init[ (s)
	{	
		MenuBackground(20);
	} ]

	OnRightSoftKey[ ()
	{
		MenuBack();
	}]
	
	MenuBack[ (s)
	{
		DisplayCharacterManager();
	} ]

	ActionQueueBack[ ()
	{
		DisplayCharacterManager();
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		x=5;
		y=30;
		offsetY=15;
		
		if (IsRightQueue() = true)
		{
			AddTitle(3779);
		}
		else
		{
			AddTitle(3778);
		}
		
		firstItem=AddFloatingText("item", "ShowPopup", x, y, true);
		
		y=y+offsetY;
		 AddFloatingText("item", "ShowPopup", x, y, true);
		
		y=y+offsetY;
		AddFloatingText("item", "ShowPopup", x, y, true);

		y=y+offsetY;
		AddFloatingText("item", "ShowPopup", x, y, true);

		y=y+offsetY;
		AddFloatingText("item", "ShowPopup", x, y, true);
		
		popup=CreatePopupMenu(x,y,150,70,false);
		popup.AddItem(3999,"DropItem");
		popup.AddItem(4000,"ItemUp");	
		popup.AddItem(4001,"ItemDown");
		popup.AddItem(3281,"HidePopup");
		popup.SetBack("HidePopup");
		popup.SetVisible(false);
				
		quitButton=AddQuitButton(3281,"MenuBack");					


		//Ondisplay
		SetSelectedItem(firstItem);
		UpdateTextItems();	
		quitButton.SetEnabled(true);
	}]
	
	RelocateItem[ ()
	{
		inventory = selectedItem.GetAssociatedObject();
		if (inventory != null)
		{
			GetPlayer().MoveToOtherQueue(inventory);
		}
		
		self.HidePopup();
	}]
	
	DropItem[ ()
	{
		inventory = selectedItem.GetAssociatedObject();
		if (inventory != null)
		{
			GetPlayer().RemoveItemFromQueue(inventory);
		}		
		
		self.HidePopup();	
	}]
	
	ShowPopup[ ()
	{
		selectedItem=GetSelectedItem();
		if (selectedItem = firstItem)
		{
			popup.UpdatePopupItem(1,"");
		}
		else
		{
			popup.UpdatePopupItem(1,4000);
		}
		
		lastItem = GetLastItem();
		if (selectedItem = lastItem)
		{
			popup.UpdatePopupItem(2,"");
		}
		else
		{
			popup.UpdatePopupItem(2,4001);
		}
				
		popup.SetVisible(true);
		//popup.SetToWidget(selectedItem,5,10);
		//OverlapPopupMenu(popup);		
	}]
	
	HidePopup[ ()
	{
		popup.SetVisible(false);
		self.OnDisplay();		
	}]
	
	ItemUp[ ()
	{
		bRet = MoveItem(selectedItem.GetAssociatedObject(), true);
		if (bRet)
		{
			HidePopup();
		}
	}]

	ItemDown[ ()
	{
		bRet = MoveItem(selectedItem.GetAssociatedObject(), false);
		if (bRet)
		{
			HidePopup();
		}		
	}]
	
	OnRightSoftKey[ (s)
	{
		DisplayCharacterManager();
	} ]	
}