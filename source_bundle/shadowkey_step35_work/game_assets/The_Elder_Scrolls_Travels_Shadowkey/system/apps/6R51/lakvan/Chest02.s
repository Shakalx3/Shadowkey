{
	Loot2 [0]
	Init[ (s)
	{
		SetUseText(368);
		SetName(368);

		Item = Level.CreateEntity( 705 );
		AddObject( Item );

		Item = Level.CreateEntity( 705 );
		AddObject( Item );

		Item = Level.CreateEntity( 4736 );
		AddObject( Item );

		Item = Level.CreateEntity( 4736 );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	}]
}