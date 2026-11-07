{
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);

		whichItem = Random(1,100);
		if(whichItem <= 20)
		{
			Item = Level.CreateEntity(558);
			AddObject(Item);
		}
		else
		{
			if(whichItem <= 35)
			{
				Item = Level.CreateEntity(654);
				AddObject(Item);
			}
			else
			{
				if(whichItem <= 55)
				{
					Scroll = Level.CreateEntity( 51 );
					Scroll.SetScroll(true);
					Scroll.SetLevel(10);
					AddObject(Scroll);
				}
				else
				{
					if(whichItem <= 65)
					{
						Scroll = Level.CreateEntity( 4022 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(10);
						AddObject(Scroll);
					}
					else
					{
						if(whichItem <= 88)
						{
							Item = Level.CreateEntity(907);
							AddObject(Item);
						}
						else
						{
							Item = Level.CreateEntity(614);
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