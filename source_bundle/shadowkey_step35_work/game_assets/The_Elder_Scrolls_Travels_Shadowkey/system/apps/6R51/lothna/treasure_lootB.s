{

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		rand = Random(1,6);

		if (rand = 1)
		{
			Item = Level.CreateEntity( 707 ); //smack water
			AddObject( Item );
		}
		
		if (rand = 2)
		{
			Item = Level.CreateEntity( 702 ); //healing potion
			AddObject( Item );		
		}
		
		if (rand = 3)
		{
			Item = Level.CreateEntity( 4726 ); //restorative
			AddObject( Item );		
		}
		
		if (rand = 4)
		{
			Item = Level.CreateEntity( 4022 ); //frenzy
			AddObject( Item );		
		}
				
		if (rand = 5)
		{
			Item = Level.CreateEntity( 703 ); 
			AddObject( Item );		
		}
		
		if (rand = 6)
		{
			Item = Level.CreateEntity( 708 ); //frenzy
			AddObject( Item );		
		}								
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}