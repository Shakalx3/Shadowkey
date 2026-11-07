{	
	
	Init[ (s)
	{	
		//ClearMenu();
		MenuBackground(20);			
		
		id = GetPlayer().GetTemp();		
			
		//img=AddFloatingSprite(0, "", 110, 0, false);
		
		if (id = 0)
		{
			AddStaticItem(2015, true); //argonian
			//img.SetSprite(31);
		}
		
		if (id = 1)
		{
			AddStaticItem(2016, true); //argonian
			AddStaticItem(2017, true); //breton
			//img.SetSprite(33);
		}		
		
		if (id = 2)
		{
			AddStaticItem(2018, true); //dark elf
			//img.SetSprite(35);
		}		
		
		if (id = 3)
		{
			AddStaticItem(2019, true); //high elf
			//img.SetSprite(37);
		}		
		
		if (id = 4)
		{
			AddStaticItem(2020, true); //Khajit
			//img.SetSprite(39);
		}	
		
		if (id = 5)
		{
			AddStaticItem(2021, true); //Nord
			//img.SetSprite(41);
		}	
		
		if (id = 6)
		{
			AddStaticItem(2022, true); //Redguard
			//img.SetSprite(43);
		}	
		
		if (id = 7)
		{
			AddStaticItem(2023, true); //wood elf
			//img.SetSprite(45);
		}		
		
		//AddQuitButton("Back","MenuQuit");	
		SetPrevMenu("Menus\\\\ChooseRaceMenu");	//force prev menu

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

	} ]
	
	OnRightSoftKey[ (s)
	{
		MenuQuit();
	} ]	
		
	ShowRaceInfoBack[ ()
	{
		OpenMenu("Menus\\\\ChooseRaceMenu");
	}]
}