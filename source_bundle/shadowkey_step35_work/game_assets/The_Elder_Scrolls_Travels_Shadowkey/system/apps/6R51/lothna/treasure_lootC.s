{

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		rand = Random(1,6);

		if (rand = 1)
		{
			Item = Level.CreateEntity( 4735 ); //crystal
			AddObject( Item );
		}

		if (rand = 2)
		{
			Item = Level.CreateEntity( 669 ); //shield
			AddObject( Item );
		}

		if (rand = 3)
		{
			Item = Level.CreateEntity( 51 ); //heal wound
			AddObject( Item );
		}

		if (rand = 4)
		{
			Item = Level.CreateEntity( 4022 ); //frenzy
			AddObject( Item );
		}

		if (rand = 5)
		{
			Item = Level.CreateEntity( 4017 );
			AddObject( Item );
		}

		if (rand = 6)
		{
			Item = Level.CreateEntity( 4729 );
			AddObject( Item );
		}
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}