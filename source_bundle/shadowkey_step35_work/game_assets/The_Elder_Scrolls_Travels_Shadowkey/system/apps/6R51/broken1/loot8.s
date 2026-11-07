{
	Chest[0]
	
	Init[()
	{
		SetUseText(368);	
		SetMPUsable(true);
	}]

	OnUse[(s)
	{
		if(Chest = 0)
		{
			OpenMenu("broken1\\\\loot8_menu");			
		}
		else
		{
			OpenMenu("broken1\\\\loot_empty");
		}
	}]
			
	MenuQuit[()
	{
		Quit();	
	}]
}