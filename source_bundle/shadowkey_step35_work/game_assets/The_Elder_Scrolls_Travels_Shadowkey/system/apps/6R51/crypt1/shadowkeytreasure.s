{
	SkChest[0]
	
	Init[()
	{
		SetUseText(640);	
	}]

	OnUse[(s)
	{
		if(SkChest = 0)
		{
			OpenMenu("crypt1\\\\skchest");			
		}
		else
		{
			OpenMenu("crypt1\\\\NoLoot");
		}
	}]
			
	
	MenuQuit[()
	{
		Quit();	
	}]
}