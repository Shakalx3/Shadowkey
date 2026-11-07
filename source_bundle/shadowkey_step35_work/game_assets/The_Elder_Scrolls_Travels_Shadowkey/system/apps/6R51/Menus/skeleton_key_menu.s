{	
	Init[ (s)
	{				
		ClearMenu();
		AddStaticItem(2987);
		//AddMenuItem(386,"MenuQuit");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]
	
	skeleton_key_menuBack[ ()
	{
		Quit();
	}]

}