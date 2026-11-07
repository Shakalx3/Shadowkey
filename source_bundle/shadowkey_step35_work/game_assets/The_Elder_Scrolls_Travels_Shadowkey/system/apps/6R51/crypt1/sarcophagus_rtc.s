{
	Init[ (s)
	{
		SetUseText(612);
		SetUsable(true);
		SetName(613);
		SetID("Sarc");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 4009 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 712 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 51 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 66 )
					{
						Item = Level.CreateEntity( 4017 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 4729 );
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
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}