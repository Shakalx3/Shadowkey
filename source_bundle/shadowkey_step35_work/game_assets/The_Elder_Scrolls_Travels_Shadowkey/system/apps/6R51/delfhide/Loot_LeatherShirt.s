{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 606 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}