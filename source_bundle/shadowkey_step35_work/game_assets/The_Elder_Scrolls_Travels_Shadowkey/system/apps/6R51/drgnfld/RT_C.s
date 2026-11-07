{
	Init[ (s)
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);
		SetID("Bones");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 649 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 661 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 655 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 66 )
					{
						Scroll = Level.CreateEntity( 50 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(5);
						AddObject(Scroll);
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 619 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 503 );
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