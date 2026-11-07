{
	Init[()
	{
		ClearMenu();
		if(GetPlayer().QuestAssigned(18)=false)
		{
			AddStaticItem(2601);
			AddStaticItem(179, false);
			if(GetPlayer().QuestAssigned(13)=true)
			{
				AddMenuItem(2602, "SeeIvgrizt");
			}
			else
			{
				AddMenuItem(3304, "ScrollOfDawn");
			}
			AddMenuItem(2603, "AgroQuit");
		}
		else
		{
			if(GetPlayer().QuestSolved(18)=false)
			{
				AddStaticItem(2604);
				AddStaticItem(179, false);
				AddMenuItem(182, "MoreNotSolved");
			}
			else
			{
				AddStaticItem(2605);
				AddStaticItem(179, false);
				if(GetPlayer().QuestAssigned(13)=true)
				{
					AddMenuItem(182, "MoreSolved1");
				}
				else
				{
					AddMenuItem(182, "MoreSolved2");
				}
			}
		}
	}]

	MoreSolved1[()
	{
		ClearMenu();
	AddStaticItem(2606);
		AddStaticItem(2607);
		AddStaticItem(2608);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreSolved2");
	}]

	MoreSolved2[()
	{
		ClearMenu();
		AddStaticItem(2609);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreSolved3");
	}]

	MoreSolved3[()
	{
		ClearMenu();
		AddStaticItem(2610);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		Item = Level.CreateEntity( 702 );
		GetPlayer().PickupItem( Item );
		GetPlayer().SetGold( GetPlayer().GetGold() + 80 );
		GetPlayer().AddExperience(500);
		GetPlayer().SetQuestCompleted(18);
		Goblin = Level.GetEntity("gobtalk");
		Goblin.DestroyObjectMirror(Goblin);
	}]

	MoreNotSolved[()
	{
		ClearMenu();
		AddStaticItem(1800);
		AddStaticItem(179, false);
		AddMenuItem(1801, "MenuQuit");
	}]

	SeeIvgrizt[()
	{
		ClearMenu();
		AddStaticItem(2612);
		AddStaticItem(2613);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreIvgrizt");
	}]

	MoreIvgrizt[()
	{
		ClearMenu();
		AddStaticItem(2614);
		AddStaticItem(2615);
		AddStaticItem(179, false);
		AddMenuItem(2616, "ScrollOfDawn");
		AddMenuItem(2617, "AgroQuit");
	}]

	ScrollOfDawn[()
	{
		ClearMenu();
		AddStaticItem(2618);
		AddStaticItem(2619);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreScrollOfDawn");
	}]

	MoreScrollOfDawn[()
	{
		ClearMenu();
		AddStaticItem(2620);
		AddStaticItem(2621);
		AddStaticItem(179, false);
		AddMenuItem(2622, "MenuQuit");
		GetPlayer().SetQuestAssigned(18);
	}]

	MenuQuit[()
	{
		Quit();
	}]

	AgroQuit[()
	{
		Level.GetEntity("gobtalk").SetAggressive(true);
		Level.GetEntity("gobtalk").SetUsable(false);
		Level.GetEntity("gobtalk").SetInvulnerable(false);
		GetOpener().saved_aggro = 1;
		GetPlayer().saved_Goblin = 1;
		Quit();
	}]
}