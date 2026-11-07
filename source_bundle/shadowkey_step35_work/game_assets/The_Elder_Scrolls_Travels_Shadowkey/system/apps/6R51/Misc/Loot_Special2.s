{
	Init[ (s)
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		whichItem = Random(1,100);
		if( whichItem < 34 )
		{
			Item = Level.CreateEntity( 4601 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 67 )
			{
				Item = Level.CreateEntity( 4604 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 101 )
				{
					Item = Level.CreateEntity( 4605 );
					AddObject( Item );
				}
			}
		}
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}