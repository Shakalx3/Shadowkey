{
	Init[()
	{
		if(GetPlayer().QuestAssigned(34)=false)
		{
			ClearMenu();
			AddStaticItem(2166);
			AddStaticItem(2167);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreUses1");
		}
		else
		{
			if(GetPlayer().QuestSolved(34)=false)
			{
				ClearMenu();
				AddStaticItem(2168);
				AddStaticItem(2169);
				AddStaticItem(179, false);
				AddMenuItem(2170, "MenuQuit");
				AddMenuItem(2171, "Attacked");
			}
			else
			{
				if(GetPlayer().QuestCompleted(34)=false)
				{
					ClearMenu();
					AddStaticItem(2172);
					AddStaticItem(179, false);
					AddMenuItem(2173, "Done");
				}
			}
		}
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(2174);
		AddStaticItem(2175);
		AddStaticItem(179, false);
		AddMenuItem(755, "MenuQuit");
		AddMenuItem(2176, "Attacked");
		GetPlayer().SetQuestCompleted(34);
		GetPlayer().AddExperience(1250);
		GetPlayer().SetGold( GetPlayer().GetGold() + 900 );
		Level.saved_Dead_Yelnicin = 1;

	}]

	MoreUses1[()
	{
		ClearMenu();
		AddStaticItem(2177);
		AddStaticItem(2178);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreUses2");
	}]

	MoreUses2[()
	{
		ClearMenu();
		AddStaticItem(2179);
		AddStaticItem(179, false);
		AddMenuItem(1004, "MenuQuit");
		AddMenuItem(2180, "Accept");
		AddMenuItem(2181, "Attacked");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(34);
		Quit();
	}]

	Attacked[()
	{
		ClearMenu();
		GetPlayer().OpenMenu("Raiders\\\\devron_attacked");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}