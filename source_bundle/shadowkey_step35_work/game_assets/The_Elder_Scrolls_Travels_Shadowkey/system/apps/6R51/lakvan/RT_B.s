{
	Init[ (s)
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);
		SetID("Container");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 708 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 51 )
			{
				Item = Level.CreateEntity( 4726 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 61 )
				{
					Item = Level.CreateEntity( 702 );
					AddObject( Item );
					Item = Level.CreateEntity( 702 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 86 )
					{
						Item = Level.CreateEntity( 703 );
						AddObject( Item );
						Item = Level.CreateEntity( 703 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 101 )
						{
							Item = Level.CreateEntity( 4730 );
							AddObject( Item );
						}
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