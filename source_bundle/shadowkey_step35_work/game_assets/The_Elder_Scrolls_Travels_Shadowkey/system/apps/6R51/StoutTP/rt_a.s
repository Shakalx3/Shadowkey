{
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);

		whichItem = Random(1,100);
		if(whichItem <= 20)
		{
			Scroll = Level.CreateEntity( 4022 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(10);
			AddObject(Scroll);
		}
		else
		{
			if(whichItem <= 37)
			{
				Item = Level.CreateEntity(4704);
				AddObject(Item);
			}
			else
			{
				if(whichItem <= 50)
				{
					Item = Level.CreateEntity(4703);
					AddObject(Item);
				}
				else
				{
					if(whichItem <= 60)
					{
						Scroll = Level.CreateEntity( 4023 );
						Scroll.SetScroll(true);
						Scroll.SetLevel(10);
						AddObject(Scroll);
					}
					else
					{
						if(whichItem <= 85)
						{
							Item = Level.CreateEntity(4707);
							AddObject(Item);
						}
						else
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
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}