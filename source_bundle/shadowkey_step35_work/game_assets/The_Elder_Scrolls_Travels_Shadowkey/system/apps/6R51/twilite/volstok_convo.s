{
	Init[()
	{
		ClearMenu();
		if(GetPlayer().QuestAssigned(20)=false)
		{
			AddStaticItem(2730);
			AddStaticItem(2731);
			AddStaticItem(179, false);
			AddMenuItem(2312, "ShadowKey1");
		}
		else
		{
			if(GetPlayer().QuestSolved(20)=false)
			{
				AddStaticItem(2732);
				AddStaticItem(179, false);
				AddMenuItem(182, "Expectant");
			}
			else
			{
				AddStaticItem(2733);
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
		AddStaticItem(2734);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreSolved2");
	}]

	MoreSolved2[()
	{
		ClearMenu();
		Level.GetEntity("volstok").SetModel(23);
		AddStaticItem(2735);
		AddStaticItem(2736);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreSolved3");
	}]

	MoreSolved3[()
	{
		ClearMenu();
		AddStaticItem(2737);
		AddStaticItem(2738);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreSolved4");
	}]

	MoreSolved4[()
	{
		ClearMenu();
		AddStaticItem(2739);
		AddStaticItem(2740);
		AddStaticItem(2741);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetPlayer().AddExperience(900);
		GetPlayer().SetQuestCompleted(20);
		Volstok = Level.GetEntity("volstok");
		Volstok.DestroyObjectMirror(Volstok);
	}]

	Expectant[()
	{
		ClearMenu();
		AddStaticItem(2742);
		AddStaticItem(179, false);
		AddMenuItem(2743, "MenuQuit");
	}]

	ShadowKey1[()
	{
		ClearMenu();
		AddStaticItem(2744);
		AddStaticItem(179, false);
		AddMenuItem(2745, "ShadowKey2");
	}]

	ShadowKey2[()
	{
		ClearMenu();
		AddStaticItem(2746);
		AddStaticItem(179, false);
		AddMenuItem(2748, "AcceptShadowKey");
		AddMenuItem(2747, "MenuQuit");
	}]

	AcceptShadowKey[()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(20);
		Quit();
	}]
}