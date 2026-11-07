{	
	Init[ (s)
	{	
		//MenuBackground(20);					
		ClearMenu();
		AddStaticItem(1990);
	

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

	} ]
	
	OnRightSoftKey[ (s)
	{
		MenuQuit();
	} ]	
		
	MenuQuit[ ()
	{
		Quit();
	}]

	DoorLockedMenuBack[ ()
	{
		MenuQuit();
	} ]

}