{
	popupTurnOn
	popupTurnOff

	Init[ (s)
	{
		//ClearMenu();
		MenuBackground(20);
		SetPrevMenu("Menus\\\\MultiPlayerMenu");
	} ]

	OnDisplay[ (s)
	{
		ClearMenu();
		AddStaticItem(3496,false);
		AddStaticItem(714);
		if( GetBluetoothStatus() )
		{
			AddMenuItem(3497, "AskTurnOff");
		}
		else
		{
			AddMenuItem(3498, "AskTurnOn");
		}
		AddStaticItem(3499);
		AddStaticItem(GetBluetoothName(),false);

		popupTurnOn=CreatePopupMenu(15,95,150,40);
		popupTurnOn.AddItem(4077,"TurnOn");
		popupTurnOn.AddItem(4078,"CloseBTPopup");		
		popupTurnOn.SetBack("CloseBTPopup");
		popupTurnOn.SetVisible(false);
		popupTurnOn.SetSelectedItem(0);
		popupTurnOn.SetBackground();

		popupTurnOff=CreatePopupMenu(15,95,150,40);
		popupTurnOff.AddItem(4077,"TurnOff");
		popupTurnOff.AddItem(4078,"CloseBTPopup");
		popupTurnOff.SetBack("CloseBTPopup");
		popupTurnOff.SetVisible(false);
		popupTurnOff.SetSelectedItem(0);
		popupTurnOff.SetBackground();

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
		UnFadeMusic();
	} ]

	MenuQuit[ (s)
	{
		OpenMenu("Menus\\\\MultiPlayerMenu");
	} ]

	TurnOff[ (s)
	{
		SetBluetooth( false );
		OnDisplay();
	} ]

	TurnOn[ (s)
	{
		SetBluetooth( true );
		OnDisplay();
	} ]

	BluetoothBack[ (s)
	{
		OpenMenu("Menus\\\\MultiPlayerMenu");
	} ]

	AskTurnOn[ (s)
	{
		popupTurnOn.SetVisible( true );
		popupTurnOn.SetSelectedItem(0);
	} ]

	AskTurnOff[ (s)
	{
		popupTurnOff.SetVisible( true );
		popupTurnOff.SetSelectedItem(0);
	} ]

	CloseBTPopup[ (s)
	{
		if( popupTurnOn.IsVisible() )
		{
			popupTurnOn.SetVisible( false );
		}
		if( popupTurnOff.IsVisible() )
		{
			popupTurnOff.SetVisible( false );
		}

		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}
	} ]
}