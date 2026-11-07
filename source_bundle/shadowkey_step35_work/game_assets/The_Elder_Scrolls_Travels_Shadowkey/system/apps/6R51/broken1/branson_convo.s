{
	Init[()
	{

		if ( (GetPlayer().QuestAssigned(45) = false) )
		{
			ClearMenu();
			AddStaticItem(413);
			AddStaticItem(179, false);
			AddMenuItem(414,"More10");
		}

		if ( (GetPlayer().QuestAssigned(45) = true) and (GetPlayer().QuestSolved(45) = false) )
		{
			ClearMenu();
			AddStaticItem(415 );
			AddStaticItem(179, false);
			AddMenuItem(416, "MenuQuit");
		}

		if (GetPlayer().QuestCompleted(45) = true)
		{
			ClearMenu();
			AddStaticItem(417);
			AddStaticItem(179, false);
			AddMenuItem(386,"MenuQuit");
			return;
		}

		if ( (GetPlayer().QuestAssigned(45) = true) and (GetPlayer().QuestSolved(45) = true) )
		{
			ClearMenu();
			AddStaticItem(418 );
			AddStaticItem(179, false);
			AddMenuItem(419, "More20");
		}
	}]

	More10[()
	{
		ClearMenu();
		AddStaticItem(420);
		AddStaticItem(179, false);
		AddMenuItem(421,"More11");
	}]

	More11[()
	{
		ClearMenu();
		AddStaticItem(422);
		AddStaticItem(179, false);
		AddMenuItem(423,"MenuQuit");
		AddMenuItem(424,"Accept");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(45);
		Quit();
	}]

	More20[()
	{
		ClearMenu();
		AddStaticItem(425);
		AddStaticItem(179, false);
		AddMenuItem(182, "More21");
	}]

	More21[()
	{
		ClearMenu();
		AddStaticItem(426);
		AddStaticItem(427);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
		branson = Level.GetEntity("branson");
		branson.DestroyObjectMirror(branson);
		GetPlayer().AddExperience(2400);
		GetPlayer().SetQuestCompleted(45);
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}