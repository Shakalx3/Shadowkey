{
	WAChest[0]
	
	Init[()
	{
		SetUseText(640);	
	}]

	OnUse[(s)
	{
		if(WAChest = 0)
		{
			OpenMenu("crypt1\\\\wachest");
			WAChest = 1;			
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