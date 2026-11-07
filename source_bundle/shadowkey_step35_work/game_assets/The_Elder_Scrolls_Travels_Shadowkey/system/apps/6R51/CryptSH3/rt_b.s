{
	Init[ (s)
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);
		SetID("Chest");

		whichItem = Random(1,100);
		if( whichItem < 16 )
		{
			Item = Level.CreateEntity( 707 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 29 )
			{
				Item = Level.CreateEntity( 4710 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 58 )
				{
					Item = Level.CreateEntity( 4726 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 76 )
					{
						Item = Level.CreateEntity( 703 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 88 )
						{
							Item = Level.CreateEntity( 4730 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 703 );
								AddObject( Item );
								Item = Level.CreateEntity( 702 );
								AddObject( Item );
								Item = Level.CreateEntity( 702 );
								AddObject( Item );
							}
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