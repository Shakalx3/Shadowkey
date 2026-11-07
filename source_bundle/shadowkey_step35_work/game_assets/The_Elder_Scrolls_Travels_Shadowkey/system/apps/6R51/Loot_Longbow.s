{
	Init[ (s)
	{
		SetName(611);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 517 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}