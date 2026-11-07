{
	Chest[0]
	
	Init[()
	{
		SetUseText(368);	
	}]

	OnUse[(s)
	{
		if(Chest = 0)
		{
			OpenMenu("broken2\\\\loot_skey2_menu");			
		}
		else
		{
			OpenMenu("broken2\\\\loot_empty");
		}
	}]
			
	MenuQuit[()
	{
		Quit();	
	}]
}