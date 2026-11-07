{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );

		Item = Level.CreateEntity( 4717 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}