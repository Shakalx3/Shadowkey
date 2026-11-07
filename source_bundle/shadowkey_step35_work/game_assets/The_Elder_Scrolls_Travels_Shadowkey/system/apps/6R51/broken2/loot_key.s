{
	Init[()
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		Item = Level.CreateEntity( 917 );
		AddObject( Item );

		Item = Level.CreateEntity( 714 );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}