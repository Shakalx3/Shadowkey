{
	myClient [0]
	myPopup

	Init[ (s)
	{
		MenuBackground(20);
		SetPrevMenu("Menus\\\\MultiPlayerMenu");

	} ]
	
	OnDisplay[ (s)
	{
		ClearMenu();

		if( MPBluetoothInUse() )
		{
			AddStaticItem(3703, false );
			AddStaticItem(3951);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
		}
		else
		{
			AddStaticItem(3703,false,99);
			AddStaticItem(GetBluetoothName(),false,99);
	
			AddMenuItem(714,"Reject1");
			SetSelectable(2,false);
			AddMenuItem(714,"Reject2");
			SetSelectable(3,false);
			AddMenuItem(714,"Reject3");
			SetSelectable(4,false);
			AddMenuItem(714,"Reject4");
			SetSelectable(5,false);

			AddStaticItem(714,0);
			AddStaticItem(714,0);
			AddStaticItem(714,0);

			AddStaticItem(3704,false,99);

			AddMenuItem(3520, "Connect");
			AddMenuItem(1995, "StartTheGame");
			//AddMenuItem(3281, "ExitMenu");

			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);

			MPBeginHost();
		}

		myPopup=CreatePopupMenu(15,75,150,90);
		myPopup.AddItem(4039);
		myPopup.AddItem(1389,"DontReject");
		myPopup.AddItem(434,"DoReject");		
		myPopup.SetBack("DontReject");
		myPopup.SetSelectable(0,false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(1);
		myPopup.SetBackground();
	} ]

	HostGameMenuBack[ (s)
	{
		CloseMPHostMenu();
		OpenMenu("Menus\\\\MultiPlayerMenu");
	} ]

	Connect[ (s)
	{
		MPHostConnect();
	} ]

	StartTheGame[ (s)
	{
		MPHostPlay();
	} ]

	BluetoothInUse[ (s)
	{
		ClearMenu();
		AddStaticItem(3521,false);
		AddStaticItem(3522);
		AddMenuItem(3281, "ExitMenu");
	} ]

	Reject[ (s)
	{
		myClient = GetSelectedItemNumber();
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem(1);
		//RejectClient();
	} ]

	Reject1[ (s)
	{
		myClient = 2;
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem(1);
	} ]

	Reject2[ (s)
	{
		myClient = 3;
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem(1);
	} ]

	Reject3[ (s)
	{
		myClient = 4;
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem(1);
	} ]

	Reject4[ (s)
	{
		myClient = 5;
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem(1);
	} ]

	DontReject[ (s)
	{
		if( myPopup.IsVisible() )
		{
			myPopup.SetVisible( false );
			prevItem = GetPrevItem();
			if (prevItem != null)
			{
				SetSelectedItem(prevItem);
			}
		}
		else
		{
			HostGameMenuBack();
		}
	} ]

	DoReject[ (s)
	{
		myPopup.SetVisible( false );
		RejectClient( myClient );
	} ]
}