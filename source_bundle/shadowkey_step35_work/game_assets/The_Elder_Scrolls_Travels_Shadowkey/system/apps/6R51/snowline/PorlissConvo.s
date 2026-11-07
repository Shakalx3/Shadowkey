{
	Init[ (s)
	{
		if(GetPlayer().QuestAssigned(25) = true)
		{
			AddStaticItem(3530);
			AddStaticItem(179, false);
			AddMenuItem(182, "CrossPurposes1");
		}
		else
		{
			if(GetPlayer().QuestAssigned(26) = false)
			{
				AddStaticItem(3531);
				AddStaticItem(179, false);
				AddMenuItem(2312, "UnRed1");
			}
			else
			{
				if(GetPlayer().QuestSolved(26) = false)
				{
					AddStaticItem(3532);
					AddStaticItem(179, false);
					AddMenuItem(3533, "Quit");
				}
				else
				{
					if(GetPlayer().QuestCompleted(26) = false)
					{
						AddStaticItem(3534);
						AddStaticItem(179, false);
						AddMenuItem(182, "RightThing");
					}
					else
					{
						if(GetPlayer().QuestAssigned(29) = false)
						{
							AddStaticItem(3535);
							AddStaticItem(179, false);
							AddMenuItem(182, "Balance1");
						}
						else
						{
							if(GetPlayer().QuestSolved(29) = false)
							{
								AddStaticItem(3536);
								AddStaticItem(179, false);
								AddMenuItem(1066, "Quit");
							}
							else
							{
								if(GetPlayer().QuestCompleted(29) = false)
								{
									AddStaticItem(3537);
									AddStaticItem(179, false);
									AddMenuItem(182, "Empire");
								}
							}
						}
					}
				}
			}
		}
	} ]

	Empire[()
	{
		ClearMenu();
		AddStaticItem(3538);
		AddStaticItem(179, false);
		AddMenuItem(182, "NoMissionForYou");
		GetPlayer().AddExperience(2500);
		GetPlayer().SetQuestCompleted(29);
	}]

	Balance1[()
	{
		ClearMenu();
		AddStaticItem(3539);
		AddStaticItem(179, false);
		AddMenuItem(182, "Balance2");
	}]

	Balance2[()
	{
		ClearMenu();
		AddStaticItem(3540);
		AddStaticItem(179, false);
		AddMenuItem(182, "Balance3");
	}]

	Balance3[()
	{
		ClearMenu();
		AddStaticItem(3541);
		AddStaticItem(179, false);
		AddMenuItem(3542, "BalanceAccept");
		AddMenuItem(3414, "Quit");
	}]

	BalanceAccept[()
	{
		GetPlayer().SetQuestAssigned(29);
		Quit();
	}]

	RightThing[()
	{
		ClearMenu();
		AddStaticItem(3543);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().AddExperience(1000);
		GetPlayer().SetQuestCompleted(26);
	}]

	UnRed1[()
	{
		ClearMenu();
		AddStaticItem(3544);
		AddStaticItem(179, false);
		AddMenuItem(182, "UnRed2");
	}]

	UnRed2[()
	{
		ClearMenu();
		AddStaticItem(3545);
		AddStaticItem(179, false);
		AddMenuItem(182, "UnRed3");
	}]

	UnRed3[()
	{
		ClearMenu();
		AddStaticItem(3546);
		AddStaticItem(179, false);
		AddMenuItem(1005, "UnRedAccept");
		AddMenuItem(3414, "Quit");
	}]

	UnRedAccept[()
	{
		GetPlayer().SetQuestAssigned(26);
		GetPlayer().SetQuestCompleted(6);
		Quit();
	}]

	NoMissionForYou[()
	{
		ClearMenu();
		AddStaticItem(3547);
		AddStaticItem(179, false);
		AddMenuItem(3548, "MenuQuit");
	}]

	CrossPurposes1[()
	{
		ClearMenu();
		AddStaticItem(3549);
		AddStaticItem(179, false);
		AddMenuItem(182, "CrossPurposes2");
	}]

	CrossPurposes2[()
	{
		ClearMenu();
		AddStaticItem(3550);
		AddStaticItem(179, false);
		AddMenuItem(3548, "MenuQuit");
	}]

	MenuQuit[()
	{
		Porliss = Level.GetEntity("porliss");
		Porliss.DestroyObjectMirror(Porliss);
		GetPlayer().SetQuestCompleted(29);
		GetPlayer().SetQuestCompleted(88);
		Quit();
	}]
}