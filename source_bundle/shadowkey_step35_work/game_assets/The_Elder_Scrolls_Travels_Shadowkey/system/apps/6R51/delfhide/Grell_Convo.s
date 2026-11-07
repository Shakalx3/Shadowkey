{
	Init[ (s)
	{
		if( GetPlayer().QuestAssigned(3) = false )
		{
			AddStaticItem(819);
			AddStaticItem(179, false);
			AddMenuItem(182,"NoQuestMore");
		}
		else
		{
			if( GetPlayer().QuestSolved(3) = false )
			{
				AddStaticItem(820);
				AddStaticItem(179, false);
				AddMenuItem(821, "Quit");
			}
			else
			{
				AddStaticItem(822);
				AddStaticItem(179, false);
				AddMenuItem(182,"QuestDoneMore");
			}
		}
	} ]

	NoQuestMore[ (s)
	{
		ClearMenu();
		AddStaticItem(823);
		AddStaticItem(179, false);

		AddMenuItem(825, "GetChest");
		AddMenuItem(3599, "Quit");
	} ]

	GetChest[ (s)
	{
		ClearMenu();
		AddStaticItem(826);
		AddStaticItem(179, false);
		AddMenuItem(182, "GetChestMore");
	} ]

	GetChestMore[ (s)
	{
		ClearMenu();
		AddStaticItem(827);
		AddStaticItem(179, false);
		AddMenuItem(182, "GetChestMore2");
	} ]

	GetChestMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(828);
		AddStaticItem(179, false);
		AddMenuItem(182, "GetChestMore3");
	} ]

	GetChestMore3[ (s)
	{
		if(GetPlayer().FindInventory( "papers" ) != null)
		{
			ClearMenu();
			AddStaticItem(3598);
			AddStaticItem(179, false);

			AddMenuItem(3600, "QuestDoneMore");
			AddMenuItem(3599, "Quit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(829);
			AddStaticItem(179, false);

			AddMenuItem(831, "GetChestMore4");
			AddMenuItem(830, "Quit");
		}
	}]

	GetChestMore4[ (s)
	{
		GetPlayer().SetQuestAssigned(3);
		Quit();
	} ]

	QuestDoneMore[ (s)
	{
		ClearMenu();
		AddStaticItem(832);
		AddStaticItem(179, false);
		AddMenuItem(182, "QuestDoneMore2");
	} ]

	QuestDoneMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(833);
		AddStaticItem(179, false);
		AddMenuItem(834,"Quit");
		poo = GetPlayer().FindInventory("papers");
		GetPlayer().RemoveItem(poo);
		GetPlayer().AddExperience( 150 );
		GetPlayer().SetQuestCompleted(3,true);
		Item = Level.CreateEntity( 927 );
		GetPlayer().PickupItem( Item );
		Grell = Level.GetEntity("grell");
		Grell.DestroyObjectMirror(Grell);

		// Delete grell and men
	} ]
}