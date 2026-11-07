{
	saved_SummonMe[0]
	Init[ ()
	{
		SetName(943);
		SetUseText(944);
		SetUsable( true );

		Item = Level.CreateEntity( 528 );
		AddObject( Item );

		Item = Level.CreateEntity( 613 );
		AddObject( Item );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( 1200 );
		AddObject( Item );
	} ]

	OnUse[ ()
	{
		if( not IsMultiplayerClient() )
		{
			OpenMenu("LootMenu");
			Delay( 1, 1 );
		}
	} ]

	DelayReached[ (s)
	{
		if(saved_SummonMe = 0)
		{
			Level.CreateEntity(272, GetPositionX() - 400, GetPositionY() + 400, GetPositionZ());
			saved_SummonMe = 1;
		}
	} ]
}