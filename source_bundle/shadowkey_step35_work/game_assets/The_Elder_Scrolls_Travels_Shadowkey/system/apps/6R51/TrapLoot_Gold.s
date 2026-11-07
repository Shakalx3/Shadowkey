{
	Trapped [1]
	chance[5]
	
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 23, 50 ) );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
/*
		if( Trapped = 1 )
		{

			if (GetPlayer().CanAvoidTrap(chance) = true)
			{
				doNothing=0;
			}

			if ( GetPlayer().CanDisarmTrap(chance) = true )
			{
				Trapped=0;
			}
			else
			{
				GetPlayer().DoDamage( Random(3,14) );
				Trapped = 0;
				return;
			}
		}
*/
		OpenMenu("LootMenu");
	} ]
}