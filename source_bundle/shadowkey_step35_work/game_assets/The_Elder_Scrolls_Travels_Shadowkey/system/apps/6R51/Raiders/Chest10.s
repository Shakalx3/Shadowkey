{
	Loot10 [0]
	Init[ (s)
	{
		SetUseText(368);
		Item = Level.CreateEntity( 652 );
		AddObject( Item );
		Item = Level.CreateEntity( 627 );
		AddObject( Item );
		Item = Level.CreateEntity( 652 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{

		if( Loot10 = 0)
		{
			OpenMenu("LootMenu");
		}

	} ]

	MenuQuit[()
	{
		Quit();
	}]
}