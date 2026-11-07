{
	Init[ (s)
	{
		SetUseText(865);
		SetName(368);
		SetUsable( true );

		Item = Level.CreateEntity( 721 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}