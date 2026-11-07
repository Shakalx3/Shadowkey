{
	Init[ (s)
	{
		SetName(2670);
		SetUseText(2670);
		SetUsable( true );

		Item = Level.CreateEntity( 518 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}