{
	Init[ (s)
	{
		SetName(611);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 510 );
		AddObject( Item );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}