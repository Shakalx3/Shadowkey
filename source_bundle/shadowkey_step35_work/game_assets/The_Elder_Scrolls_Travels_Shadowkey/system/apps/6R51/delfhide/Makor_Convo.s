{
	FailCount[0]

	Init[ (s)
	{
		if( GetPlayer().QuestAssigned(11) )
		{
			if( GetPlayer().QuestCompleted(11) )
			{
				AddStaticItem(869);
				AddStaticItem(179, false);
				AddMenuItem(870, "Quit");
			}
			else
			{
				AddStaticItem(871);

				AddStaticItem(179, false);
				AddMenuItem(873, "FreeMakor");
				AddMenuItem(872, "Quit");
			}
		}
		else
		{
			AddStaticItem(874);

			AddStaticItem(179, false);
			AddMenuItem(182,"More");
		}
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(875);

		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(876);

		AddStaticItem(179, false);
		AddMenuItem(877, "WhoAreYou");
		AddMenuItem(878, "CanITrustYou");
	} ]

	WhoAreYou[ (s)
	{
		ClearMenu();
		AddStaticItem(879);

		AddStaticItem(179, false);
		AddMenuItem(881, "FreeMakor");
		AddMenuItem(878, "CanITrustYou");
		AddMenuItem(880, "Quit");
	} ]

	CanITrustYou[ (s)
	{
		ClearMenu();
		AddStaticItem(882);

		AddStaticItem(179, false);
		AddMenuItem(182, "TrustMore");
	} ]

	TrustMore[ (s)
	{
		ClearMenu();
		AddStaticItem(883);

		AddStaticItem(179, false);
		AddMenuItem(877, "WhoAreYou");
		AddMenuItem(885, "FreeMakor");
		AddMenuItem(884, "NotFree");
	} ]

	FreeMakor[ (s)
	{
		GetPlayer().SetQuestAssigned(11);

		// This is supposed to roll an attack against a defense of 3.
		if( Random(1,3) = 1 )
		{
			Level.Log(" Free Makor Random succedd");
			Succeed();
			Level.saved_prison = 1;
		}
		else
		{
			Fail();
		}
	} ]

	Fail[ (s)
	{
		FailCount = FailCount + 1;

		ClearMenu();
		if( FailCount = 1 )
		{
			AddStaticItem(886);

			AddStaticItem(179, false);
			AddMenuItem(887, "FreeMakor");
		}
		if( FailCount = 2 )
		{
			AddStaticItem(888);

			AddStaticItem(179, false);
			AddMenuItem(889, "FreeMakor");
			FailCount = 0;
		}
		if( FailCount = 3 )
		{
			AddStaticItem(890);

			AddStaticItem(179, false);
			AddMenuItem(891, "Quit");
	}
	} ]

	Succeed[ (s)
	{
		ClearMenu();
		AddStaticItem(892);

		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
		Level.Log("succedd");
		GetPlayer().SetQuestSolved(11);
		GetPlayer().SetQuestCompleted(11);
		GetPlayer().SetQuestCompleted(233);
		Level.saved_prison = 1;
		Level.saved_Makor =1;
		Level.saved_DoneRoom15 = 1;
		GetOpener().DestroyObjectMirror( GetOpener() );
	} ]

	NotFree[ (s)
	{
		Quit();
		GetPlayer().SetQuestSolved(233);
	}]
}