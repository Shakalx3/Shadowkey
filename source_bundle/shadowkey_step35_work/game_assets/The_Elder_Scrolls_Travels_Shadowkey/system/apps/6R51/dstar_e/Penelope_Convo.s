{
	Init[()
	{
		if(GetPlayer().QuestAssigned(41)=false)
		{
			ClearMenu();
			AddStaticItem(3408);
			AddStaticItem(990);
			AddStaticItem(179, false);
			AddMenuItem(3636, "MenuQuit");
		}
		else
		{
			if(GetPlayer().QuestSolved(41)=false)
			{
				ClearMenu();
				AddStaticItem(991);
				AddStaticItem(179, false);
				AddMenuItem(3637, "MenuQuit");
				AddMenuItem(3638, "Buy");
			}
			else
			{
				if(GetPlayer().QuestAssigned(42)=false)
				{
					ClearMenu();
					AddStaticItem(994);
					AddStaticItem(995);
					AddStaticItem(179, false);
					AddMenuItem(3639, "Rilora");
				}
				else
				{
					if(GetPlayer().QuestSolved(42)=false)
					{
						ClearMenu();
						AddStaticItem(3409);
						AddStaticItem(3410);
						AddStaticItem(179, false);
						AddMenuItem(3590, "MenuQuit");
					}
					else
					{
						if(GetPlayer().QuestCompleted(42)=false)
						{
							ClearMenu();
							AddStaticItem(3411);
							AddStaticItem(3640);
							AddStaticItem(179, false);
							AddMenuItem(182, "DoneRilora");
						}
						else
						{
							ClearMenu();
							AddStaticItem(3641);
							AddStaticItem(1001);
							AddStaticItem(179, false);
							AddMenuItem(3590, "MenuQuit");
						}
					}
				}
			}
		}
	}]

	DoneRilora[()
	{
		ClearMenu();
		AddStaticItem(3642);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
		GetPlayer().SetQuestCompleted(42);
		GetPlayer().AddExperience(1250);
	}]

	Rilora[()
	{
		ClearMenu();
		AddStaticItem(3413);
		AddStaticItem(179, false);
		AddMenuItem(3643, "MenuQuit");
		AddMenuItem(3644, "Accept");
	}]

	Buy[()
	{
		ClearMenu();
		AddStaticItem(1006);
		AddStaticItem(179, false);
		AddMenuItem(3645, "Herbs2");
		AddMenuItem(3646, "Herbs5");
		AddMenuItem(3647, "Herbs10");
		AddMenuItem(3637, "MenuQuit");
	}]

	Herbs2[()
	{
		Gold90 = GetPlayer().GetGold();
		if (Gold90 < 90)
		{
			ClearMenu();
			AddStaticItem(3415);
			AddStaticItem(179, false);
			AddMenuItem(3648, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3416);
			AddStaticItem(179, false);
			AddMenuItem(3649, "Done");
			Gold90 = Gold90 - 90;
			GetPlayer().SetGold(Gold90);
			Item = Level.CreateEntity( 722 );
			GetPlayer().PickupItem( Item );
		}
	}]

	Herbs5[()
	{
		Gold225 = GetPlayer().GetGold();
		if (Gold225 < 225)
		{
			ClearMenu();
			AddStaticItem(3415);
			AddStaticItem(179, false);
			AddMenuItem(3648, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3417);
			AddStaticItem(179, false);
			AddMenuItem(3650, "Done");
			Gold225 = Gold225 - 225;
			GetPlayer().SetGold(Gold225);
			Item = Level.CreateEntity( 723 );
			GetPlayer().PickupItem( Item );
		}
	}]

	Herbs10[()
	{
		ClearMenu();
		AddStaticItem(1015);
		AddStaticItem(179, false);
		AddMenuItem(3651, "Sure");
		AddMenuItem(1017, "Buy");
	}]

	Sure[()
	{
		Gold450 = GetPlayer().GetGold();
		if (Gold450 < 450)
		{
			ClearMenu();
			AddStaticItem(3415);
			AddStaticItem(179, false);
			AddMenuItem(3648, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3420);
			AddStaticItem(179, false);
			AddMenuItem(3649, "Done");
			Gold450 = Gold450 - 450;
			GetPlayer().SetGold(Gold450);
			Item = Level.CreateEntity( 724 );
			GetPlayer().PickupItem( Item );
		}
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(3421);
		AddStaticItem(1020);
		AddStaticItem(179, false);
		AddMenuItem(3590, "DoneHerbs");
	}]

	DoneHerbs[()
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(41);
		Quit();
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(42);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
