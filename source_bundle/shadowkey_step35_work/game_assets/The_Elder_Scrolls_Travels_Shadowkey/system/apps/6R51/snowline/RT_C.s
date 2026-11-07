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
				Item = Level.CreateEntity( 654 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Scroll = Level.CreateEntity( 51 );
					Scroll.SetScroll(true);
					Scroll.SetLevel(10);
					AddObject(Scroll);
				}
				else
				{
					if( whichItem < 66 )
					{
						Scroll = Level.CreateEntity( 4022 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(10);
						AddObject(Scroll);
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 905 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 614 );
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