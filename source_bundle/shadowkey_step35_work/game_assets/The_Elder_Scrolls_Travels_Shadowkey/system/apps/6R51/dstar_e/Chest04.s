{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 4701 );
		AddObject( Item );

		Item = Level.CreateEntity( 4707 );
		AddObject( Item );

		Item = Level.CreateEntity( 4706 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}