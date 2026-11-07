{
	Init[()
	{
		//if((GetPlayer().QuestAssigned(9) = true) and (GetPlayer().QuestCompleted(9) = false) and (GetPlayer().QuestAssigned(24) = false))
		//{
		//	AddStaticItem(1399);
		//	AddStaticItem(179, false);
		//	AddMenuItem(182, "More1");
		//}
		//else
		//{
			if(Level.saved_Talked = 0)
			{
				AddStaticItem(1399);
				AddStaticItem(179, false);
				AddMenuItem(182, "More1");
			}
			else
			{
				if(Level.saved_TalkedAgain = 1)
				{
					AddStaticItem(1401);
					AddStaticItem(179, false);
					AddMenuItem(182, "More3");
				}
				else
				{
					AddStaticItem(1398);
					AddStaticItem(179, false);
					AddMenuItem(386, "Quit");
				}
			}
		//}
	}]

	FailSafe0[()
	{
		ClearMenu();
		AddStaticItem(3767);
		AddStaticItem(179, false);
		AddMenuItem(182, "FailSafe1");
		Azra = Level.GetEntity("azra");
		Azra.SetUseText(552);
		GetPlayer().SetQuestCompleted(9);
		GetPlayer().SetQuestSolved(24);
		GetPlayer().SetQuestCompleted(24);
		Level.saved_Failsafe = 1;
		Level.saved_Talked = 1;
		Level.saved_TalkedAgain = 0;
	}]

	FailSafe1[()
	{
		ClearMenu();
		AddStaticItem(3768);
		AddStaticItem(179, false);
		AddMenuItem(182, "FailSafe2");
	}]

	FailSafe2[()
	{
		ClearMenu();
		AddStaticItem(3769);
		AddStaticItem(179, false);
		AddMenuItem(182, "FailSafe3");
	}]

	FailSafe3[()
	{
		ClearMenu();
		AddStaticItem(3770);
		AddStaticItem(179, false);
		AddMenuItem(182, "FailSafe4");
	}]

	FailSafe4[()
	{
		ClearMenu();
		AddStaticItem(3771);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		Azra = Level.GetEntity("azra");
		if(Azra != null)
		{
			Azra.DestroyObjectMirror(Azra);
		}
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(1400);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");

		Ice = Level.GetEntity("ice");
		if(Ice != null)
		{
			Ice.DestroyObjectMirror(Ice);
			Ice.SetPassable(true);
		}

		Azra = Level.GetEntity("azra");
		if(Azra != null)
		{
			Azra.SummonMe();
		}
		Level.saved_Talked = 1;
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(1401);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]
	More3[()
	{
		ClearMenu();
		AddStaticItem(1402);
		AddStaticItem(179, false);
		AddMenuItem(1403, "Memory");
		AddMenuItem(1404, "Adventurer");
	}]
	Memory[()
	{
		ClearMenu();
		AddStaticItem(1405);
		AddStaticItem(179, false);
		AddMenuItem(1407, "Shadowmage");
	}]
	Shadowmage[()
	{
		ClearMenu();
		AddStaticItem(1409);
		AddStaticItem(179, false);
		AddMenuItem(1410, "More4");
	}]
	More4[()
	{
		ClearMenu();
		AddStaticItem(1411);
		AddStaticItem(179, false);
		if(GetPlayer().QuestAssigned(9) = true)
		{
			AddMenuItem(3891, "FailSafe0");
		}
		else
		{
			AddMenuItem(758, "AzraQuest");
		}
		AddMenuItem(1412, "MenuQuit");
	}]
	Adventurer[()
	{
		ClearMenu();
		AddStaticItem(1413);
		AddStaticItem(179, false);
		AddMenuItem(1082, "More5");
	}]
	More5[()
	{
		ClearMenu();
		AddStaticItem(1414);
		AddStaticItem(179, false);
		AddMenuItem(1415, "More6");
	}]
	More6[()
	{
		ClearMenu();
		AddStaticItem(1416);
		AddStaticItem(179, false);
		if(GetPlayer().QuestAssigned(9) = true)
		{
			AddMenuItem(3891, "FailSafe0");
		}
		else
		{
			AddMenuItem(758, "AzraQuest");
		}
		AddMenuItem(1417, "MenuQuit");
	}]
	AzraQuest[()
	{
		ClearMenu();
		AddStaticItem(1418);
		AddStaticItem(179, false);
		AddMenuItem(182, "More7");
	}]
	More7[()
	{
		ClearMenu();
		AddStaticItem(1419);
		AddStaticItem(179, false);
		AddMenuItem(182, "More8");
	}]
	More8[()
	{
		ClearMenu();
		AddStaticItem(1420);
		AddStaticItem(179, false);
		AddMenuItem(182, "More9");
	}]
	More9[()
	{
		ClearMenu();
		AddStaticItem(1421);
		AddStaticItem(179, false);
		AddMenuItem(1423, "Accepted");
	}]
	Accepted[()
	{
		Level.saved_TalkedAgain = 0;
		GetPlayer().SetQuestAssigned(24);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
		Level.saved_TalkedAgain = 1;
	}]
}