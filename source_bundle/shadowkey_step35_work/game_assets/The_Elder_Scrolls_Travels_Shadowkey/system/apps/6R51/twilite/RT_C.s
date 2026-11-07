{
	Init[ (s)
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);
		SetID("Chest");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 558 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 683 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 645 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 66 )
					{
						Scroll = Level.CreateEntity( 4002 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(10);
						AddObject(Scroll);
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 560 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 621 );
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