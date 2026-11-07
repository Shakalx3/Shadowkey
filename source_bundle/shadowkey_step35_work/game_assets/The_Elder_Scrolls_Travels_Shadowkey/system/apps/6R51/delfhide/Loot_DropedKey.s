{
	Init[ (s)
	{
		SetName(749);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 804 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}