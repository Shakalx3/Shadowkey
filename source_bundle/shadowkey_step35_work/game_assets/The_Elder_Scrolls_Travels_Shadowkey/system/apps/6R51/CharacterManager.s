{
	statsButton
	equipButton
	leftActionItem
	rightActionItem
	actionQueuePopup
	selectedItem
	rightQueueSelected[false]
	nameButton
	healthItem
	magickaItem
	enduranceItem
	gpItem
	portrait
	classInfoItem
	lvItem
	
	Init[ (s)
	{	
		MenuBackground(20);							
	} ]
	
	GetHealthText[ ()
	{
		return GetLocalizedString(3064) # " " # GetPlayer().GetHealth()#"/"#GetPlayer().GetMaxHealth();
	}]
	
	GetMagickaText[ ()
	{
		return GetLocalizedString(3066) # " " # GetPlayer().GetMagicka()#"/"#GetPlayer().GetMaxMagicka();
	}]
	
	GetFatigueText[ ()
	{
		return GetLocalizedString(3065) # " " # GetPlayer().GetFatigue()#"/"#GetPlayer().GetMaxFatigue();
	}]
	
	GetLevelText[ ()
	{
		return GetLocalizedString(3068) # " " # GetPlayer().GetLevel();
	}]	

	GetGoldText[ ()
	{
		return GetLocalizedString(3069) # " " # GetPlayer().GetGold();
	}]
	
	OnDisplay[ (s)
	{	
		ClearMenu();
		originX=8;
		x=originX;
		y=10;
		offsetY=12;
		image_item_active=24;
		image_item_dormant=25;				
		
		//nameButton = AddFloatingText("cymric", "", x, y, false);
				
		portrait=AddFloatingSprite(0, "", 109, 0, false);
		
		healthText = GetHealthText();
		healthItem = AddFloatingText(healthText, "", x, y, false); //health		
				
		nextColumnX=65;	
		
		y=y+offsetY;
		magickaText = GetMagickaText();
		AddFloatingText(magickaText, "", x, y, false);		//magicka
		
		y=y+offsetY;		
		enduranceText = GetFatigueText();
		enduranceItem=AddFloatingText(enduranceText, "", x, y, false);
		
		y=y+offsetY;
		//className = GetPlayer().GetPlayerClassName();
		classInfoItem = AddFloatingText("unknown", "", originX, y, false);
				
		y=y+offsetY;
		levelText=GetLevelText();
		AddFloatingText(levelText, "", x, y, false);
						
		y=y+offsetY;
		goldText=GetGoldText();
		bCanDropGold = false;
		if (GetPlayer().GetGold() > 25)
		{
			bCanDropGold = true;
		}
		
		AddFloatingText(goldText, "DropGold", x, y, bCanDropGold); //gold	
					
		nameButton = AddButton("Cymric","",100,y);
		nameButton.SetWidth(76);
		nameButton.SetHeight(19);		
		nameButton.SetInvokeMethodOnFocus(false);
		nameButton.ShowBorder(0);
		nameButton.SetHAdjust(6);
		nameButton.SetSelectable( false );
					
					
		originX=10;	
		x=originX;
		y=y+30;
		statsButton = AddButton(3043,"CMStatsScreen",x,y); //stats
		statsButton.SetWidth(80);
		statsButton.SetHeight(23);		
		statsButton.SetInvokeMethodOnFocus(false);
		statsButton.ShowBorder(true);
		
		x = x + 80;
		equipButton = AddButton(3774,"CMEquipScreen",x,y); //equip
		equipButton.SetWidth(80);
		equipButton.SetHeight(23);
		equipButton.SetInvokeMethodOnFocus(false);	
		equipButton.ShowBorder(true);
		
		//left hand
		x=originX;
		y=y+23;		
		leftActionItem=AddItemButton( 0, "LeftQueueSelected", x, y, 80,60);	
		textArea=leftActionItem.GetTextArea();
		textArea.SetTextWidth(11);		
		
		//right hand
		x=x+80;	
		rightActionItem=AddItemButton( 0, "RightQueueSelected", x, y, 80,60);	
		textArea=rightActionItem.GetTextArea();
		textArea.SetTextWidth(11);
			
		x=originX;
		actionQueuePopup=CreatePopupMenu(x,y,150,55,false);
		actionQueuePopup.SetBackground();
		actionQueuePopup.AddItem(3775,"DisplayQueue");	
		//actionQueuePopup.AddItem(3776,"ResetQueue");
		//actionQueuePopup.AddItem(3777,"DisplayRemoved");
		actionQueuePopup.AddItem(3281,"HideActionQueuePopup");
		actionQueuePopup.SetBack("HideActionQueuePopup");
		actionQueuePopup.SetVisible(false);
				
		y=y+25+30;
		questButton = AddButton(3773,"CMQuestLog",68,y);
		questButton.SetWidth(54);
		questButton.SetHeight(13);		
		questButton.SetInvokeMethodOnFocus(false);
		questButton.ShowBorder(true);
		questButton.SetHAdjust(8);
							
		AddQuitButton(3281,"MenuExit");

		//ondisplay	
		actionQueuePopup.SetVisible(false);
		
		myname=GetPlayer().GetPlayerName();
		myname=TrimText(myname, 9);
		nameButton.SetItemText(myname);				
		
		
		dagger=GetPlayer().GetLeftItem();
		if (dagger!=null)
		{
			id = dagger.GetIcon();
			leftActionItem.SetSprite(id);
			text=dagger.GetName();
			leftActionItem.SetItemText(text);
			
			textArea=leftActionItem.GetTextArea();
			textArea.SetTrimText(true);
		}
		else
		{
			leftActionItem.SetLocalizedText(3778);
			leftActionItem.SetSprite(-1);
		}
		
		otherItem=GetPlayer().GetRightItem();
		if (otherItem!=null)
		{
			id = otherItem.GetIcon();
			rightActionItem.SetSprite(id);
			text=otherItem.GetName();
			rightActionItem.SetItemText(text);
			
			textArea=rightActionItem.GetTextArea();
			textArea.SetTrimText(true);			
		}
		else
		{
			rightActionItem.SetLocalizedText(3779);
			rightActionItem.SetSprite(-1);
		}	
		
		id = GetPlayer().GetPortraitID();
		portrait.SetSprite(id);		

		classInfoItem.SetItemText(GetPlayer().GetPlayerClassName());
	}]
	
	OnRightSoftKey[ (s)
	{
		MenuExit();
		OpenMainMenu();
	} ]
		
	MenuExit[ (s)
	{
		Quit();
	} ]
	
	CMQuestLog[ (s)
	{
		DisplayQuestLog();
	}]
		
	CMStatsScreen[ (s)
	{
		DisplayStatsScreen();
	} ]
	
	CMEquipScreen[ (s)
	{
		DisplayInventory();
	} ]	
	
	LeftQueueSelected[ (s)
	{		
		selectedItem=GetSelectedItem();
		SetLeftActionQueue();
		leftActionItem.SetVisible(false);
		rightActionItem.SetVisible(false);
		//actionQueuePopup.SetVisible(true);
		//SetSelectedItem(actionQueuePopup);
		ShowActionQueue();
	}]
	
	RightQueueSelected[ (s)
	{
		selectedItem=GetSelectedItem();
		SetRightActionQueue();
		leftActionItem.SetVisible(false);
		rightActionItem.SetVisible(false);
		//actionQueuePopup.SetVisible(true);
		//SetSelectedItem(actionQueuePopup);
		ShowActionQueue();		
	}]
	
	HideActionQueuePopup[ (s)
	{
		leftActionItem.SetVisible(true);
		rightActionItem.SetVisible(true);
		actionQueuePopup.SetVisible(false);
		SetSelectedItem(leftActionItem);	
	}]
	
	DisplayQueue[ (s)
	{
		ShowActionQueue();
	}]
	
	DisplayRemoved[ ()
	{
		ShowRemovedQueue();
	}]
	
	ResetQueue[ ()
	{
		GetPlayer().ResetQueue(rightQueueSelected);
		self.HideActionQueuePopup();
		self.OnDisplay();			
	}]
	
	DropGold[ ()
	{
		Quit();
		GetPlayer().OpenMenu("Menus\\\\DropGoldMenu");
	}]

	CharacterManagerBack[ ()
	{
		Quit();
	}]
}