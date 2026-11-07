{
	Sarc [0]
	Init[ (s)
	{
		SetUseText(612);
	} ]

	OnUse[ (s)
	{

		if(Sarc = 0)
		{
			OpenMenu("crypt1\\\\Loot01");
			Delay( 1, 1 );
		}
		else
		{
			OpenMenu("NoLoot");
		}

	} ]

	MenuQuit[()
	{	
		Quit();		
	}]
	
	DelayReached[(s)
	{
		Level.CreateEntity(264, GetPositionX() + 500, GetPositionY() + 500, GetPositionZ());	
	}]
}