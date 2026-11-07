{
	Init[ (s)
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		Item = Level.CreateEntity( 51 );
		AddObject( Item );

	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}