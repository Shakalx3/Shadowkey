{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 704 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}