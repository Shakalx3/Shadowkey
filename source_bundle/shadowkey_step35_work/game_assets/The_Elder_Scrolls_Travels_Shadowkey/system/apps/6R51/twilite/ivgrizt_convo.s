{
	Init[()
	{
		ClearMenu();
		if(GetPlayer().QuestAssigned(19)=false)
		{
			AddStaticItem(2627);
			AddStaticItem(2628);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreStink");
		}
		else
		{
			Head = GetPlayer().FindInventory("shahead");
			if(Head = null)
			{
				AddStaticItem(2629);
				AddStaticItem(2630);
				AddStaticItem(179, false);
				AddMenuItem(1483, "MenuQuit");
				AddMenuItem(2631, "MenuQuit");
			}
			else
			{
				AddStaticItem(2632);
				AddStaticItem(179, false);
				AddMenuItem(182, "MoreSolved1");
			}
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]

	MoreSolved1[()
	{
		ClearMenu();
		AddStaticItem(2633);
		AddStaticItem(179, false);
		Headdress = GetPlayer().FindInventory("shahead");
		GetPlayer().RemoveItem(Headdress);
		if(GetPlayer().QuestAssigned(13)=true)
		{
			AddMenuItem(182, "MoreSolved2");
		}
		else
		{
			AddMenuItem(182, "MoreSolved3");
		}
	}]

	MoreSolved2[()
	{
		ClearMenu();
		AddStaticItem(2634);
		AddStaticItem(2635);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreSolved3");
	}]

	MoreSolved3[()
	{
		ClearMenu();
		AddStaticItem(2636);
		AddStaticItem(2637);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetPlayer().AddExperience(600);
		GetPlayer().SetQuestSolved(19);
		GetPlayer().SetQuestCompleted(19);
		GetPlayer().SetQuestSolved(13);
		Goblin = Level.GetEntity("ivgrizt");
		Goblin.DestroyObjectMirror(Goblin);
	}]

	MoreStink[()
	{
		ClearMenu();
		AddStaticItem(2638);
		AddStaticItem(2639);
		AddStaticItem(179, false);
		AddMenuItem(2641, "GetHeaddress");
		AddMenuItem(2640, "MenuQuit");
	}]

	GetHeaddress[()
	{
		ClearMenu();
		AddStaticItem(2642);
		AddStaticItem(2643);
		AddStaticItem(179, false);
		AddMenuItem(2644, "Headdress1");
	}]

	Headdress1[()
	{
		ClearMenu();
		AddStaticItem(2645);
		AddStaticItem(2646);
		AddStaticItem(2647);
		AddStaticItem(179, false);
		AddMenuItem(2648, "Headdress2");
		if(GetPlayer().QuestAssigned(13)=true)
		{
			AddMenuItem(2649, "PackGone1");
		}
	}]

	Headdress2[()
	{
		ClearMenu();
		AddStaticItem(2650);
		AddStaticItem(2651);
		AddStaticItem(179, false);
		AddMenuItem(182, "Headdress3");
	}]

	Headdress3[()
	{
		ClearMenu();
		AddStaticItem(2652);
		AddStaticItem(179, false);
		AddMenuItem(182, "Headdress4");
	}]

	Headdress4[()
	{
		ClearMenu();
		AddStaticItem(2653);
		AddStaticItem(179, false);
		AddMenuItem(2654, "Headdress5");
}]

	Headdress5[()
	{
		ClearMenu();
		AddStaticItem(2655);
		AddStaticItem(2656);
		AddStaticItem(179, false);
		AddMenuItem(182, "Headdress6");
	}]

	Headdress6[()
	{
		ClearMenu();
		AddStaticItem(2657);
		AddStaticItem(179, false);
		AddMenuItem(2659, "AcceptHeaddress");
		AddMenuItem(2658, "MenuQuit");
	}]

	AcceptHeaddress[()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(19);
		Quit();
	}]

	PackGone1[()
	{
		ClearMenu();
		AddStaticItem(2660);
		AddStaticItem(2661);
		AddStaticItem(179, false);
		AddMenuItem(789, "PackGone2");
}]

	PackGone2[()
	{
		ClearMenu();
		AddStaticItem(2662);
		AddStaticItem(2663);
		AddStaticItem(179, false);
		AddMenuItem(2664, "PackGone3");
	}]

	PackGone3[()
	{
		ClearMenu();
		AddStaticItem(2665);
		AddStaticItem(2666);
		AddStaticItem(179, false);
		AddMenuItem(2667, "Headdress2");
	}]

}