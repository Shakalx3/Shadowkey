{
	Init[ (s)
	{
		SetUseText(610);
		SetUsable(true);
		SetName(946);
		SetID("Container");

		whichItem = Random(1,100);
		if( whichItem < 17 )
		{
			Item = Level.CreateEntity( 712 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 38 )
			{
				Item = Level.CreateEntity( 4701 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 51 )
				{
					Item = Level.CreateEntity( 4722 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 61 )
					{
						Item = Level.CreateEntity( 704 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 71 )
						{
							Item = Level.CreateEntity( 705 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 86 )
							{
								Item = Level.CreateEntity( 709 );
								AddObject( Item );
							}
							else
							{
								if( whichItem < 101 )
								{
									Item = Level.CreateEntity( 705 );
									AddObject( Item );
								}
							}
						}
					}
				}
			}
		}
	} ]

	OnUse[ (s)
	{
		OpenMenu("dstar_e\\\\Thief_LootMenu");
	} ]
}