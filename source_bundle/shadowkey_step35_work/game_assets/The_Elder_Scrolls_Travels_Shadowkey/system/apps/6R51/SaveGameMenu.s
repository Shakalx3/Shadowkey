{
	myPopup
	slotNum
	outOfSpace
	failed
	doneSave
	activeItem

	Init[ (s)
	{
		MenuBackground(69);
		SetPrevMenu("MainMenu");
	} ]

	OnDisplay[ (s)
	{
		ClearMenu();
		activeItem=AddStaticItem(718,0);
		AddStaticItem(714,0);

		if( GameAvailableForLoad(0) )
		{
			AddMenuItem(3276,"SaveToSlot0");
		}
		else
		{
			AddMenuItem(3277, "SaveToSlot0");
		}
		if( GameAvailableForLoad(1) )
		{
			AddMenuItem(3278,"SaveToSlot1");
		}
		else
		{
			AddMenuItem(3277, "SaveToSlot1");
		}
		if( GameAvailableForLoad(2) )
		{
			AddMenuItem(3279,"SaveToSlot2");
		}
		else
		{
			AddMenuItem(3277, "SaveToSlot2");
		}
		if( GameAvailableForLoad(3) )
		{
			AddMenuItem(3280,"SaveToSlot3");
		}
		else
		{
			AddMenuItem(3277, "SaveToSlot3");
		}
		//AddMenuItem(3281, "MenuQuit");

		myPopup=CreatePopupMenu(15,75,150,60);
		myPopup.AddItem(4026);
		myPopup.AddItem(4010,"CancelSaveGame");	
		myPopup.AddItem(4009,"ConfirmSaveGame");
		myPopup.SetBack("CancelSaveGame");	
		myPopup.SetSelectable(0,false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(1);
		myPopup.SetBackground();

		outOfSpace=CreatePopupMenu(15,75,150,110);
		outOfSpace.AddItem(4027);
		outOfSpace.AddItem(4028,"CancelOutOfSpace");
		outOfSpace.SetBack("CancelOutOfSpace");
		outOfSpace.SetSelectable(0,false);
		outOfSpace.SetVisible(false);
		outOfSpace.SetSelectedItem(1);
		outOfSpace.SetBackground();

		failed=CreatePopupMenu(15,75,150,110);
		failed.AddItem(4057);
		failed.AddItem(4028,"SaveGameMenuBack");
		failed.SetBack("CancelFailed");
		failed.SetSelectable(0,false);
		failed.SetVisible(false);
		failed.SetSelectedItem(1);
		failed.SetBackground();
		failed.SetAutoAdjust(true);

		doneSave=CreatePopupMenu(15,75,150,60);
		doneSave.AddItem(4029);
		doneSave.AddItem(4028,"CancelDoneSave");
		doneSave.SetBack("CancelDoneSave");
		doneSave.SetSelectable(0,false);
		doneSave.SetVisible(false);
		doneSave.SetSelectedItem(1);
		doneSave.SetBackground();

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]

	SaveToSlot0[ (s)
	{
		slotNum = 0;
		if( GameAvailableForLoad( slotNum ) )
		{
			myPopup.SetVisible( true );
			myPopup.SetSelectedItem(1);
		}
		else
		{
			ActuallySaveGame( slotNum );
			//OnDisplay();
		}		
	} ]

	SaveToSlot1[ (s)
	{
		slotNum = 1;
		if( GameAvailableForLoad( slotNum ) )
		{
			myPopup.SetVisible( true );
			myPopup.SetSelectedItem(1);
		}
		else
		{
			ActuallySaveGame( slotNum );
			//OnDisplay();
		}		
	} ]

	SaveToSlot2[ (s)
	{
		slotNum = 2;
		if( GameAvailableForLoad( slotNum ) )
		{
			myPopup.SetVisible( true );
			myPopup.SetSelectedItem(1);
		}
		else
		{
			ActuallySaveGame( slotNum );
			//OnDisplay();
		}		
	} ]

	SaveToSlot3[ (s)
	{
		slotNum = 3;
		if( GameAvailableForLoad( slotNum ) )
		{
			myPopup.SetVisible( true );
			myPopup.SetSelectedItem(1);
		}
		else
		{
			ActuallySaveGame( slotNum );
			//OnDisplay();
		}		
	} ]

	SaveGameMenuBack[ (s)
	{
		OpenMenu("MainMenu");
	} ]

	ConfirmSaveGame[ (s)
	{
		myPopup.SetVisible( false );
		ActuallySaveGame( slotNum );
		//OnDisplay();
	} ]

	CancelSaveGame[ (s)
	{
		myPopup.SetVisible( false );
		SetSelectedItem(activeItem);
		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}
	} ]

	CancelOutOfSpace[ (s)
	{
		outOfSpace.SetVisible( false );
		SetSelectedItem(activeItem);
	} ]

	NotEnoughSpace[ (s)
	{
		outOfSpace.SetVisible( true );
		outOfSpace.SetSelectedItem(1);
	} ]

	CancelFailed[ (s)
	{
		failed.SetVisible( false );
		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}
	} ]

	SaveFailed[ (s)
	{
		failed.SetVisible( true );
	} ]

	DoneSave[ (s)
	{
		doneSave.SetVisible( true );
		doneSave.SetSelectedItem(1);
		//OpenMenu("MainMenu");
	} ]

	CancelDoneSave[ (s)
	{
		doneSave.SetVisible( false );
		//OnDisplay();
		OpenMenu("MainMenu");
	} ]
}