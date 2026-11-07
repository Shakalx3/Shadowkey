{
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);

		whichItem = Random(1,100);
		if(whichItem <= 15)
		{
			Item = Level.CreateEntity(707);
			AddObject(Item);
		}
		else
		{
			if(whichItem <= 50)
			{
				Item = Level.CreateEntity(702);
				AddObject(Item);
			}
			else
			{
				if(whichItem <= 75)
				{
					Item = Level.CreateEntity(703);
					AddObject(Item);
				}
				else
				{
					Item = Level.CreateEntity(4734);
					AddObject(Item);
				}
			}
		}
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}