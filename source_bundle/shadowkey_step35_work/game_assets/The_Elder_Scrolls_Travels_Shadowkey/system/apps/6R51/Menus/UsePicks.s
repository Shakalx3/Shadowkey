{
	Init[ (s)
	{
		AddStaticItem(3555);
		AddStaticItem(179, false);
		//AddMenuItem(386, "Quit");
		AddMenuItem(3556, "Pick");
		
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);		
	} ]

	Pick[ ()
	{
		if (GetOpener() != null)
		{
			if (GetPlayer().CanDisarmTrap(GetOpener().resistDisarm) = true)
			{
				GetOpener().LockPicked();
			}
			else
			{
				key = GetPlayer().FindInventory("skelkey");
				if (key != null)
				{
					GetOpener().UseKey();
				}
				else
				{
					GetOpener().MagicDamage();
				}
			}
		}
	}]
	
	UsePicksBack[ (s)
	{
		Quit();
	} ]	
}