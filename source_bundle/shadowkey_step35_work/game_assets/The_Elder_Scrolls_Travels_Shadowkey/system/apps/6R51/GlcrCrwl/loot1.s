{
	Init[ (s)
	{
		SetName(610);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 918 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}