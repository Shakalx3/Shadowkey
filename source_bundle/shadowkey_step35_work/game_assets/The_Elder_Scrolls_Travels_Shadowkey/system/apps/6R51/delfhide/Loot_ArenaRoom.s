{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 529 );
		AddObject( Item );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );

		Item = Level.CreateEntity( 703 );
		AddObject( Item );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 201, 320 ) );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}