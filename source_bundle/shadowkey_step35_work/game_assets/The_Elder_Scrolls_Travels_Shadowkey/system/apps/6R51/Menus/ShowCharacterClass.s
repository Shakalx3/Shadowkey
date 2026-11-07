{	
	
	Init[ (s)
	{	
		//ClearMenu();
		MenuBackground(20);			
		
		id=GetPlayer().GetTemp();
		
		if (id = 0)
		{
			AddStaticItem(1996, true);
		}
		
		if (id = 1)
		{
			AddStaticItem(1997, true);
		}		
		
		if (id = 2)
		{
			AddStaticItem(1998, true);
		}		
		
		if (id = 3)
		{
			AddStaticItem(1999, true);
		}
				
		if (id = 4)
		{
			AddStaticItem(2000, true);
		}		
		
		if (id = 5)
		{
			AddStaticItem(2001, true);
		}	
				
		if (id = 6)
		{
			AddStaticItem(2002, true);
		}	

		if (id = 7)
		{
			AddStaticItem(2003, true);
		}	
		
		if (id = 8)
		{
			AddStaticItem(2004, true);
		}		
				
		AddStaticItem(714);
		//AddStaticItem(2005);
		AddStaticItem(2006, false);
		AddStaticItem(714);
		
		if (id = 0)
		{
			AddStaticItem(2007, true);
		}
				
		if (id = 1)
		{
			AddStaticItem(2008, true);
		}
		
		if (id = 2)
		{
			AddStaticItem(2007, true);
		}
		
		if (id = 3)
		{
			AddStaticItem(2009, true);
		}
				
		if (id = 4)
		{
			AddStaticItem(2010, true);
		}
		
		if (id = 5)
		{
			AddStaticItem(2011, true);
		}
		
		if (id = 6)
		{
			AddStaticItem(2012, true);
		}			
				
		if (id = 7)
		{
			AddStaticItem(2013, true);
		}
		
		if (id = 8)
		{
			AddStaticItem(2014, true);
		}
																	

		//AddQuitButton("Back","MenuQuit");	
		SetPrevMenu("Menus\\\\ChooseCharacterMenu"); //force prev menu	

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

	} ]
	
		
	ShowCharacterClassBack[ ()
	{
		OpenMenu("Menus\\\\ChooseCharacterMenu");
	}]
}