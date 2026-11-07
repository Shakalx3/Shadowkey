{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(456);
		SetUseText(1922);
		SetUsable( true );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );
		
		Item = Level.CreateEntity( 702 );
		AddObject( Item );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );
		
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}