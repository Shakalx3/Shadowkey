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
			Item = Level.CreateEntity( 641 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 679 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 667 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 66 )
					{
						Scroll = Level.CreateEntity( 4036 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(8);
						AddObject(Scroll);
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 534 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 4024 );
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