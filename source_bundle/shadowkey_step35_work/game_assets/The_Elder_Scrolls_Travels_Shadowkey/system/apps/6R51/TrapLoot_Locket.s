{
	Trapped [1]

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 801 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		if( Trapped = 1 )
		{
			GetPlayer().DoDamage( Random(3,14) );
			Trapped = 0;
			return;
		}
		OpenMenu("LootMenu");
	} ]
}