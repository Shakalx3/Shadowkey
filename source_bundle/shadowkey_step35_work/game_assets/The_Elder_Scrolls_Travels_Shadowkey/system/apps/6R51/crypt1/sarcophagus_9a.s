{
	Sarc [0]
	
	Init[ (s)
	{
		SetUseText(612);
		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 1200, 1600 ) );
		AddObject( Item );		
	} ]

	OnUse[ (s)
	{

		if(Sarc = 0)
		{
			slotMenu=OpenMenu("LootMenu");
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
	
	DelayReached[ (s)
	{
		Level.CreateEntity(924, GetPositionX() + 500, GetPositionY() + 500, GetPositionZ());
		//if (creature != null)
		//{
		//	creature.SetVelocity(0,0,-200);
		//}		
	}]
}