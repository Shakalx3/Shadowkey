{
	Init[ (s)
	{
		SetUseText(863);
		SetUsable(true);
		SetName(864);

		whichItem = Random(1,100);
		if( whichItem < 10 )
		{
			Item = Level.CreateEntity( 701 );
				AddObject( Item );
		}
		else
		{
			if( whichItem < 50 )
			{
				Item = Level.CreateEntity( 700 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 65 )
				{
					Item = Level.CreateEntity( 709 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 95 )
					{
						Item = Level.CreateEntity( 710 );
						AddObject( Item );
					}
					else
					{
						Item = Level.CreateEntity( 707 );
						AddObject( Item );
					}
				}
			}
		}
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}