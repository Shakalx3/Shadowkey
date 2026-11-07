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
			Scroll = Level.CreateEntity( 4009 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(20);
			AddObject(Scroll);
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
					Scroll = Level.CreateEntity( 51 );
					Scroll.SetScroll(true);
					Scroll.SetLevel(20);
					AddObject(Scroll);
				}
				else
				{
					if( whichItem < 66 )
					{
						Scroll = Level.CreateEntity( 4017 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(10);
						AddObject(Scroll);
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