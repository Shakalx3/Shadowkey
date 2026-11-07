{
	Init[ (s)
	{
		if( GetPlayer().QuestAssigned(6) = false )
		{
			ClearMenu();
			AddStaticItem(387);
			AddStaticItem(179, false);
			AddMenuItem(182, "More1");
			return;
		}
		if( GetPlayer().QuestCompleted(6) = true )
		{
			ClearMenu();
			AddStaticItem(388);
			AddStaticItem(179, false);
			AddMenuItem(389, "Quit");
		}
		else
		{
			if( GetPlayer().QuestSolved(6) = true )
			{
				ClearMenu();
				AddStaticItem(390);
				AddStaticItem(179, false);
				AddMenuItem(182, "Dragon1");
			}
			else
			{
				ClearMenu();
				AddStaticItem(391);
				AddStaticItem(179, false);
				AddMenuItem(392, "Quit");
			}
		}
	} ]

	More1[ (s)
	{
		ClearMenu();
		AddStaticItem(393);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(394);
		AddStaticItem(179, false);
		AddMenuItem(395, "Accept");
		AddMenuItem(378, "Quit");
	} ]

	Accept[ (s)
	{
		GetPlayer().SetQuestAssigned(6);
		Quit();
	} ]

	Dragon1[ (s)
	{
		ClearMenu();
		AddStaticItem(396);
		AddStaticItem(179, false);
		AddMenuItem(182, "Dragon2");
	} ]

	Dragon2[ (s)
	{
		ClearMenu();
		AddStaticItem(397);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(6);
		Tanyin = Level.GetEntity("tanyin");
		Tanyin.DestroyObjectMirror(Tanyin);
		GetPlayer().StatModGold(375);
		GetPlayer().AddExperience(600);
		Map = GetPlayer().FindInventory("skmap");
		Map.DestroyObject(Map);
	} ]
}