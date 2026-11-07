{
	Init[ (s)
	{
		SetName(1663);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 703 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}