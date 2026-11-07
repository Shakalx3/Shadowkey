{
	Init[()
	{
		MenuBackground(20);	
	}]
	
	OnDisplay[()
	{
		ClearMenu();
		OpenEditText("CharName", "Alpha.txt", 30, 160, 50, 150);
		SetPrevMenu("Menus\\\\ChoosePortraitMenu");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
		SetUseHoriz(true);
	}]

	OnRightSoftKey[ (s)
	{
		GetPlayer().SetPlayerName(GetPlayer().GetCharName());
		OpenMenu("Menus\\\\ChoosePortraitMenu");
	} ]	
		
	Done[()
	{
		if (GetPlayer().GetCharName() = "")
		{
			return;
		}
			
		GetPlayer().SetPlayerName(GetPlayer().GetCharName());
		OpenMenu("Menus\\\\NewGameMenu");
	}]

	NameCharBack[ (s)
	{
		GetPlayer().SetPlayerName(GetPlayer().GetCharName());
		OpenMenu("Menus\\\\ChoosePortraitMenu");
	} ]
}