{
	Init[()
	{
		if (GetPlayer().QuestAssigned(11) = false)
		{
			ClearMenu();
			AddStaticItem(461);
			AddStaticItem(179, false);
			AddMenuItem(386,"MenuQuit");
			Level.GetEntity("makor").SetAggressive(true);
			Level.GetEntity("makor").SetInvulnerable(false);
			Level.GetEntity("makor").SetUsable(false);
		}
		else
		{
			if (GetPlayer().QuestAssigned(48) = false)
			{
				if (Level.Makor = 0)
				{
					ClearMenu();
					AddStaticItem(462);
					AddStaticItem(179, false);
					AddMenuItem(463,"More10");
				}
				else
				{
					More21();
				}
			}
			else
			{
				if (GetPlayer().QuestSolved(48) = false)
				{
					ClearMenu();
					AddStaticItem(464);
					AddStaticItem(179, false);
					AddMenuItem(465,"MenuQuit");
				}
				else
				{
					if (GetPlayer().QuestCompleted(48) = false)
					{
						ClearMenu();
						AddStaticItem(467);
						AddStaticItem(179, false);
						AddMenuItem(468,"More30");
					}
					else
					{
						ClearMenu();
						AddStaticItem(466);
						AddStaticItem(179, false);
						AddMenuItem(386,"MenuQuit");
					}
				}
			}
		}
	}]

	More10[()
	{
		ClearMenu();
		AddStaticItem(469);
		AddStaticItem(179, false);
		AddMenuItem(182,"MakorQuest");
	}]

	MakorQuest[()
	{
		ClearMenu();
		AddStaticItem(470);
		AddStaticItem(179, false);
		AddMenuItem(471,"More20");
	}]


	More20[()
	{
		ClearMenu();
		AddStaticItem(472);
		AddStaticItem(179, false);
		AddMenuItem(473,"More21");
	}]

	More21[()
	{
		Level.Makor = 1;
		ClearMenu();
		AddStaticItem(474);
		AddStaticItem(475);
		AddStaticItem(179, false);
		AddMenuItem(423,"MenuQuit");
		AddMenuItem(476,"Accept");
	}]

	Accept[()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(48);
		Item = Level.CreateEntity( 4723 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 4723 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(477);
		AddStaticItem(179, false);
		AddMenuItem(386,"MenuQuit");
	}]


	More30[()
	{
		ClearMenu();
		AddStaticItem(478);
		AddStaticItem(179, false);
		AddMenuItem(182,"More31");
	}]

	More31[()
	{
		ClearMenu();
		AddStaticItem(479);
		AddStaticItem(179, false);
		AddMenuItem(182,"More32");
	}]

	More32[()
	{
		ClearMenu();
		AddStaticItem(480);
		AddStaticItem(179, false);
		AddMenuItem(182,"More33");
	}]

	More33[()
	{
		ClearMenu();
		AddStaticItem(481);
		AddStaticItem(179, false);
		AddMenuItem(386,"MenuQuit");
		GetPlayer().AddExperience(2400);
		GetPlayer().SetQuestCompleted(48);
		Item = Level.CreateEntity( 4743 );
		GetPlayer().PickupItem( Item );
	}]

	MenuQuit[()
	{
		Quit();
	}]

}