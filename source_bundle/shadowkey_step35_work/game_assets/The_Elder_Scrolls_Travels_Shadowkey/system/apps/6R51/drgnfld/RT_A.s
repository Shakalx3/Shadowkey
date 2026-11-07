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
			Item = Level.CreateEntity( 712 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 4701 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 4722 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 66 )
					{
						Item = Level.CreateEntity( 704 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 705 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 709 );
								AddObject( Item );
							}
							else
							{
								if( whichItem < 66 )
								{
									Scroll = Level.CreateEntity( 51 );
									Scroll.SetScroll(true);
									Scroll.SetLevel(10);
									AddObject(Scroll);
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
		OpenMenu("LootMenu");
	} ]
}