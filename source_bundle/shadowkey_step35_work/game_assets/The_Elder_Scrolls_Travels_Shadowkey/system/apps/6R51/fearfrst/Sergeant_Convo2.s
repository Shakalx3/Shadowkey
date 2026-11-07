{
	Init[()
	{
		if(Level.saved_Done = 1)
		{
			AddStaticItem(3243);
			AddStaticItem(179, false);
			AddMenuItem(3244, "Quit");
			AddMenuItem(3245, "NoDeal");
		}
		else
		{
			if(GetPlayer().QuestAssigned(21) = false)
			{
				AddStaticItem(3246);
				AddStaticItem(179, false);
				AddMenuItem(3248, "Quit");
				AddMenuItem(3247, "NoDeal");
			}
			else
			{
				if(GetPlayer().QuestSolved(21) = true)
				{
					AddStaticItem(1378);
					AddStaticItem(179, false);
					AddMenuItem(1380, "Gruntfest");
					AddMenuItem(1379, "Quit");
				}
				else
				{
					if(GetPlayer().QuestAssigned(21) = true)
					{
						AddStaticItem(1381);
						AddStaticItem(179, false);
						AddMenuItem(182, "More2");
					}
				}
			}
		}
	}]
	Gruntfest[()
	{
		ClearMenu();
		AddStaticItem(1382);
		AddStaticItem(179, false);
		AddMenuItem(1384, "Gruntfest2");
		AddMenuItem(1383, "Quit");
	}]
	Gruntfest2[()
	{
		ClearMenu();
		AddStaticItem(1385);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]
	More1[()
	{
		ClearMenu();
		Item = Level.CreateEntity(702);
		GetPlayer().PickupItem( Item );
		AddStaticItem(1386);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		Level.saved_Done = 1;
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(1388);
		AddStaticItem(179, false);
		AddMenuItem(1375, "Yes");
		AddMenuItem(1389, "Will");
		//AddMenuItem(1390, "StrikeQuickly");
	}]
	Yes[()
	{
		Level.GetEntity("sarge").SetAggressive(true);
		Level.GetEntity("sarge").SetUsable(false);
		Quit();
	}]
	Will[()
	{
		ClearMenu();
		AddStaticItem(1391);
		AddStaticItem(179, false);
		AddMenuItem(1392, "Loot6");
		AddMenuItem(1393, "NoDeal");
	}]
	Loot6[()
	{
		ClearMenu();
		AddStaticItem(1394);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
	}]
	Take[()
	{
		wi = Level.CreateEntity( 807 );
		GetPlayer().PickupItem(wi);
		GetPlayer().SetQuestSolved(21);
		Quit();
	}]
	NoDeal[()
	{
		Level.GetEntity("sarge").SetAggressive(true);
		Level.GetEntity("sarge").SetUsable(false);
		Quit();
	}]
	StrikeQuickly[()
	{
		ClearMenu();
		AddStaticItem(1395);
		AddStaticItem(179, false);
		AddMenuItem(386, "Okay");
	}]
	Okay[()
	{
		Level.GetEntity("sarge").SetAggressive(true);
		Level.GetEntity("sarge").SetUsable(false);
		health = Level.GetEntity("sarge").GetHealth();
		SetHealth(health - 21);
	}]
}