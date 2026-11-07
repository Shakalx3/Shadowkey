{
	Init[()
	{
		if(GetPlayer().QuestAssigned(35)=false)
		{
			ClearMenu();
			AddStaticItem(2242);
			AddStaticItem(2243);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreUses1");
		}
		else
		{
			if(GetPlayer().QuestSolved(35)=false)
			{
				ClearMenu();
				AddStaticItem(2244);
				AddStaticItem(2245);
				AddStaticItem(179, false);
				AddMenuItem(2246, "MenuQuit");
				AddMenuItem(2247, "Attacked");
			}
			else
			{
				if(GetPlayer().QuestCompleted(35)=false)
				{
					ClearMenu();
					AddStaticItem(2248);
					AddStaticItem(2249);
					AddStaticItem(179, false);
					AddMenuItem(1179, "Done");
				}
			}
		}
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(2250);
		AddStaticItem(2175);
		AddStaticItem(179, false);
		AddMenuItem(1036, "MenuQuit");
		AddMenuItem(2251, "Attacked");
		GetPlayer().SetQuestCompleted(35);
		GetPlayer().AddExperience(1250);
		GetPlayer().SetGold( GetPlayer().GetGold() + 900 );
		Level.saved_Dead_Wulfbris = 1;
	}]

	MoreUses1[()
	{
		ClearMenu();
		AddStaticItem(2252);
		AddStaticItem(2253);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreUses2");
	}]

	MoreUses2[()
	{
		ClearMenu();
		AddStaticItem(2254);
		AddStaticItem(179, false);
		AddMenuItem(1004, "MenuQuit");
		AddMenuItem(2255, "Accept");
		AddMenuItem(2256, "Attacked");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(35);
		Quit();
	}]

	Attacked[()
	{
		ClearMenu();
		GetPlayer().OpenMenu("Raiders\\\\yeln_attacked");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}