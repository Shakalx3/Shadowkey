{
	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
		SetName(611);
		SetID("Chest10c");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 511 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 610 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 611 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 66 )
					{
						Item = Level.CreateEntity( 612 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 617 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 510 );
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