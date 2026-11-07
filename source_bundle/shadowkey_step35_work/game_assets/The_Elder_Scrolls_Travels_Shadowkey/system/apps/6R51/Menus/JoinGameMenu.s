{
	Init[ (s)
	{
		//ClearMenu();
		MenuBackground(20);
		SetPrevMenu("Menus\\\\MultiPlayerMenu");
	} ]

	OnDisplay[ ()
	{
		ClearMenu();

		if( MPBluetoothInUse() )
		{
			AddStaticItem(3523, false );
			AddStaticItem(3951);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
			CloseMPJoinMenu();
		}
		else
		{
			AddStaticItem(3523,false,99);
			AddStaticItem( GetBluetoothName(), false, 99 );
			//AddStaticItem(714);
			AddStaticItem(3524,false,99);
			AddStaticItem(714);
			AddMenuItem(3525,"JoinGame1");
			AddMenuItem(3525,"JoinGame2");
			AddMenuItem(3525,"JoinGame3");
			AddMenuItem(3525,"JoinGame4");
			AddStaticItem(714);
			//AddMenuItem(3526, "Retry");
			//AddMenuItem(3281, "MenuBack");

			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
			MPBeginJoin();
		}
	} ]

	JoinGame1[ (s)
	{
		JoinGame(0);
	} ]

	JoinGame2[ (s)
	{
		JoinGame(1);
	} ]

	JoinGame3[ (s)
	{
		JoinGame(2);
	} ]

	JoinGame4[ (s)
	{
		JoinGame(3);
	} ]

	Retry[ (s)
	{
		MPBeginJoin();
	} ]

	JoinGameMenuBack[ (s)
	{
		CloseMPJoinMenu();
		OpenMenu("Menus\\\\MultiPlayerMenu");
	} ]

	JoinTimeout[ (s)
	{
		ClearMenu();
		AddStaticItem(3811);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]
}