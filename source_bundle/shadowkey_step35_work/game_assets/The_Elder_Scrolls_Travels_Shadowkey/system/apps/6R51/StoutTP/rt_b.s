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
			if(whichItem <= 28)
			{
				Item = Level.CreateEntity(4714);
				AddObject(Item);
			}
			else
			{
				if(whichItem <= 57)
				{
					Item = Level.CreateEntity(4726);
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
						if(whichItem <= 87)
						{
							Item = Level.CreateEntity(4730);
							AddObject(Item);
						}
						else
						{
							Item = Level.CreateEntity(702);
							AddObject(Item);

							Item = Level.CreateEntity(702);
							AddObject(Item);

							Item = Level.CreateEntity(703);
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