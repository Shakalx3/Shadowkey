{
	Hammer[0]
	
	Init[()
	{
		SetUsable(true);
		SetUseText(448);	
		SetMPUsable(true);
	}]

	OnUse[(s)
	{
		if(Hammer = 0)
		{
			OpenMenu("broken1\\\\loot4_menu");			
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