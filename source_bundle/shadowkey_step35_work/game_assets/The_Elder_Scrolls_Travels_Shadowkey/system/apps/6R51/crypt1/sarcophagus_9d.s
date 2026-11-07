{
	Sarc [0]
	Init[ (s)
	{
		SetUseText(612);
		
		if(Sarc = 0)
		{
			Item = Level.CreateEntity( 52 );
			Item.SetQuantity( Random( 1200, 1600 ) );
			AddObject( Item );		
		}		
	} ]

	OnUse[ (s)
	{
		if(Sarc = 0)
		{
			OpenMenu("LootMenu");
			Delay( 1, 1 );
			Sarc = 1;
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
		Level.CreateEntity(258, GetPositionX() + 500, GetPositionY() + 500, GetPositionZ());	
	}]
}