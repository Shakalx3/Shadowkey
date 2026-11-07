{
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);
		SetID("Chest");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Scroll = Level.CreateEntity( 4022 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(20);
			AddObject(Scroll);
		}
		else
		{
			if( whichItem < 38 )
			{
				Item = Level.CreateEntity( 4717 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 51 )
				{
					Item = Level.CreateEntity( 4720 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 61 )
					{
						Scroll = Level.CreateEntity( 4023 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(20);
						AddObject(Scroll);
					}
					else
					{
						if( whichItem < 86 )
						{
							Item = Level.CreateEntity( 4719 );
							AddObject( Item );
						}
						else
						{
							if( whichItem < 101 )
							{
								Scroll = Level.CreateEntity( 51 );
								Scroll.SetScroll(true);
								Scroll.SetLevel(20);
								AddObject(Scroll);
							}
						}
					}
				}
			}
		}
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}