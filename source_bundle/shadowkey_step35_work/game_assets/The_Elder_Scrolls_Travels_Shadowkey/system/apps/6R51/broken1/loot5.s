{
	Longbow[0]
	
	Init[()
	{
		SetUsable(true);
		SetUseText(448);	
		SetMPUsable(true);
	}]

	OnUse[(s)
	{
		if(Longbow = 0)
		{
			OpenMenu("broken1\\\\loot5_menu");			
		}
		else
		{
			OpenMenu("broken1\\\\loot_empty_2");
		}
	}]
			
	MenuQuit[()
	{
		Quit();	
	}]
}