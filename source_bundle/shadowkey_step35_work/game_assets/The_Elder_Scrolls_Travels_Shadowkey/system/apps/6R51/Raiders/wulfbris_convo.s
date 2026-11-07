{
	Init[()
	{
		if(GetPlayer().QuestAssigned(33)=false)
		{
			ClearMenu();
			AddStaticItem(2223);
			AddStaticItem(2224);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreUses1");
		}
		else
		{
			if(GetPlayer().QuestSolved(33)=false)
			{
				ClearMenu();
				AddStaticItem(2225);
				AddStaticItem(2226);
				AddStaticItem(179, false);
				AddMenuItem(2227, "MenuQuit");
				AddMenuItem(2228, "Attacked");
			}
			else
			{
				if(GetPlayer().QuestCompleted(33)=false)
				{
					ClearMenu();
					AddStaticItem(2229);
					AddStaticItem(179, false);
					AddMenuItem(2230, "Done");
				}
			}
		}
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(2231);
		AddStaticItem(2175);
		AddStaticItem(179, false);
		AddMenuItem(1082, "MenuQuit");
		AddMenuItem(2232, "Attacked");
		GetPlayer().SetQuestCompleted(33);
		GetPlayer().AddExperience(1250);
		GetPlayer().SetGold( GetPlayer().GetGold() + 900 );
		Level.saved_Dead_Devron = 1;
	}]

	MoreUses1[()
	{
		ClearMenu();
		AddStaticItem(2233);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreUses2");
	}]

	MoreUses2[()
	{
		ClearMenu();
		AddStaticItem(2234);
		AddStaticItem(179, false);
		AddMenuItem(1004, "MenuQuit");
		AddMenuItem(2235, "Accept");
		AddMenuItem(3711, "Attacked");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(33);
		Quit();
	}]

	Attacked[()
	{
		ClearMenu();
		GetPlayer().OpenMenu("Raiders\\\\wulf_attacked");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}