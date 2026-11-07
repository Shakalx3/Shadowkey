{

	Init[()
	{

		if (GetPlayer().QuestAssigned(47) = false)
		{
			ClearMenu();
			AddStaticItem(482);
			AddStaticItem(179, false);
			AddMenuItem(182,"More10");
		}

		if ((GetPlayer().QuestAssigned(47) = true) and (GetPlayer().QuestSolved(47) = false))
		{
			ClearMenu();
			AddStaticItem(483);
			AddStaticItem(179, false);
			AddMenuItem(484,"MenuQuit");
		}

		if (GetPlayer().QuestCompleted(47) = true)
		{
			ClearMenu();
			AddStaticItem(417);
			AddStaticItem(179, false);
			AddMenuItem(386,"MenuQuit");
			return;
		}

		if (GetPlayer().QuestSolved(47) = true)
		{
			ClearMenu();
			AddStaticItem(485);
			AddStaticItem(179, false);
			AddMenuItem(486,"More20");
		}
	}]

	More10[()
	{
		ClearMenu();
		AddStaticItem(487);
		AddStaticItem(179, false);
		AddMenuItem(182,"More11");
	}]

	More11[()
	{
		ClearMenu();
		AddStaticItem(488);
		AddStaticItem(179, false);
		AddMenuItem(489,"More12");
	}]

	More12[()
	{
		ClearMenu();
		AddStaticItem(490);
		AddStaticItem(179, false);
		AddMenuItem(492,"Accept");
		AddMenuItem(491,"MenuQuit");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(47);
		Quit();
	}]

	More20[()
	{
		ClearMenu();
		AddStaticItem(493);
		AddStaticItem(179, false);
		AddMenuItem(182,"More21");
	}]

	More21[()
	{
		ClearMenu();
		AddStaticItem(494);
		AddStaticItem(179, false);
		AddMenuItem(495,"More22");
	}]

	More22[()
	{
		ClearMenu();
		AddStaticItem(496);
		AddStaticItem(179, false);
		AddMenuItem(386,"MenuQuit");
		meya = Level.GetEntity("meya");
		meya.DestroyObjectMirror(meya);
		GetPlayer().AddExperience(2400);
		GetPlayer().SetQuestCompleted(47);
	}]

	MenuQuit[()
	{
		Quit();
	}]

}