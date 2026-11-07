{
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);

		whichItem = Random(1,100);
		if(whichItem <= 20)
		{
			Scroll = Level.CreateEntity( 4009 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(20);
			AddObject(Scroll);
		}
		else
		{
			if(whichItem <= 35)
			{
				Item = Level.CreateEntity(4734);
				AddObject(Item);
			}
			else
			{
				if(whichItem <= 55)
				{
					Scroll = Level.CreateEntity( 51 );
					Scroll.SetScroll(true);
					Scroll.SetLevel(20);
					AddObject(Scroll);
				}
				else
				{
					if(whichItem <= 65)
					{
						Scroll = Level.CreateEntity( 4017 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(10);
						AddObject(Scroll);
					}
					else
					{
						if(whichItem <= 88)
						{
							Item = Level.CreateEntity(4729);
							AddObject(Item);
						}
						else
						{
							Item = Level.CreateEntity(4736);
							AddObject(Item);
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