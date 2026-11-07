{

	Init[()
	{

		if (GetPlayer().QuestAssigned(46) = false)
		{
			ClearMenu();
			AddStaticItem(428);
			AddStaticItem(179, false);
			AddMenuItem(429,"More10");
		}

		if ((GetPlayer().QuestAssigned(46) = true) and (GetPlayer().QuestSolved(46) = false))
		{
			ClearMenu();
			AddStaticItem(430);
			AddStaticItem(179, false);
			AddMenuItem(431,"MenuQuit");
		}

		if (GetPlayer().QuestCompleted(46) = true)
		{
			ClearMenu();
			AddStaticItem(432);
			AddStaticItem(179, false);
			AddMenuItem(386,"MenuQuit");
			return;
		}

		if ((GetPlayer().QuestAssigned(46) = true) and (GetPlayer().QuestSolved(46) = true))
		{
			ClearMenu();
			AddStaticItem(433);
			AddStaticItem(179, false);
			AddMenuItem(434,"More20");
		}
	}]

	More10[()
	{
		ClearMenu();
		AddStaticItem(435);
		AddStaticItem(179, false);
		AddMenuItem(436,"More11");
	}]

	More11[()
	{
		ClearMenu();
		AddStaticItem(437);
		AddStaticItem(179, false);
		AddMenuItem(423,"MenuQuit");
		AddMenuItem(438,"Accept");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(46);
		Quit();
	}]

	More20[()
	{
		ClearMenu();
		AddStaticItem(439);
		AddStaticItem(179, false);
		AddMenuItem(440,"More21");
	}]

	More21[()
	{
		ClearMenu();
		AddStaticItem(441);
		AddStaticItem(179, false);
		AddMenuItem(386,"MenuQuit");
		helena = Level.GetEntity("helena");
		helena.DestroyObjectMirror(helena);
		GetPlayer().AddExperience(2400);
		GetPlayer().SetQuestCompleted(46);
	}]

	MenuQuit[()
	{
		Quit();
	}]

}