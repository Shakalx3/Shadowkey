{
	Init[ (s)
	{
		ClearMenu();

		ring = Level.GetPlayer().FindInventory("ghring");
		if (ring != null)
		{
			AddStaticItem( 1932);
			AddStaticItem(179, false);
			AddMenuItem( 182, "Mo43" );
		}
		else
		{
			AddStaticItem( 1931 );
			AddStaticItem(179, false);
			AddMenuItem( 1066, "MenuQuit" );
		}

	} ]

	Mo43[ ()
	{
		ClearMenu();
		GetPlayer().SetQuestCompleted(43);
		GetPlayer().StatModXP(2250);
		Level.saved_TookQuest43 = 9;
		ring = Level.GetEntity("ghring");
		if (ring!=null)
		{
			Level.saved_DeadGone = 1;
			Level.saved_TookQuest43 = 9;
			GetPlayer().RemoveItem(ring);
		}

		AddStaticItem( 1933);
		AddStaticItem(179, false);

		if (Level.saved_RitualCount = 0)
		{
			AddMenuItem( 386, "SecondMission" );
		}
		else
		{
			AddMenuItem( 386, "HidePilgrim" );
		}
	}]

	SecondMission[ ()
	{
		ClearMenu();
		AddStaticItem( 1934);
		AddStaticItem(179, false);
		AddMenuItem( 1936, "Quest44" );
		AddMenuItem( 1935, "MenuQuit" );
	}]

	HidePilgrim[ ()
	{
		ghost = GetEntity("pilgrm");
		ghost.DestroyObjectMirror(ghost);
		Quit();
	}]

	Quest44[ ()
	{
		Level.saved_Quest43Done = 9;
		Level.saved_TookQuest43 = 9;
		Level.saved_DeadGone = 9;

		OpenMenu("lothna\\\\get_quest44_convo");
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}