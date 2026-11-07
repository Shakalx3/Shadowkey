{
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);

		whichItem = Random(1,100);
		if(whichItem <= 20)
		{
			Item = Level.CreateEntity(711);
			AddObject(Item);
		}
		else
		{
			if(whichItem <= 50)
			{
				Item = Level.CreateEntity(4732);
				AddObject(Item);
			}
			else
			{
				if(whichItem <= 60)
				{
					Item = Level.CreateEntity(4733);
					AddObject(Item);
				}
				else
				{
					if(whichItem <= 85)
					{
						Item = Level.CreateEntity(4706);
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
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}