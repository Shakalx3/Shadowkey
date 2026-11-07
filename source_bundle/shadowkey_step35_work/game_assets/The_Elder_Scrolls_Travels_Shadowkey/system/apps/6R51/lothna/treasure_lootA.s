{

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		rand = Random(1,6);

		if (rand = 1)
		{
			Item = Level.CreateEntity( 4711 ); //tremble weed
			AddObject( Item );
		}
		
		if (rand = 2)
		{
			Item = Level.CreateEntity( 4712 ); //goblin wax
			AddObject( Item );		
		}
		
		if (rand = 3)
		{
			Item = Level.CreateEntity( 4708 ); //fox herb
			AddObject( Item );		
		}
		
		if (rand = 4)
		{
			Item = Level.CreateEntity( 4022 ); //frenzy
			AddObject( Item );		
		}
				
		if (rand = 5)
		{
			Item = Level.CreateEntity( 4706 ); //deathsnow dust
			AddObject( Item );		
		}
		
		if (rand = 6)
		{
			Item = Level.CreateEntity( 51 ); //heal wound
			AddObject( Item );		
		}								
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}