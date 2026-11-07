{
	Init[ (s)
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			Speak = Random(1,4);
			switch(Speak)
			{
				case 1
				{
					AddStaticItem(3962);
					AddStaticItem(179, false);
					AddMenuItem(3963, "Quit");
					return;
				}
				case 2
				{

					AddStaticItem(3964);
					AddStaticItem(179, false);
					AddMenuItem(3965, "Quit");
					return;
				}
				case 3
				{

					AddStaticItem(3966);
					AddStaticItem(179, false);
					AddMenuItem(3967, "Quit");
					return;
				}
				case 4
				{

					AddStaticItem(3968);
					AddStaticItem(179, false);
					AddMenuItem(3963, "Quit");
					return;
				}
			}
		}
		else
		{
			if( GetPlayer().QuestCompleted(4) )
			{
				ClearMenu();
				AddStaticItem(836);
				AddStaticItem(179, false);
				AddMenuItem(837, "Quit");
			}
			else
			{
				if( GetPlayer().QuestAssigned(4) )
				{
					if( GetPlayer().HasItem("locket") )
					{
						ClearMenu();
						AddStaticItem(838);
						AddStaticItem(179, false);
						AddMenuItem(182, "CompletedMore");
						GetPlayer().SetQuestSolved(4);
					}
					else
					{
						ClearMenu();
						AddStaticItem(839);
						AddStaticItem(179, false);
						AddMenuItem(840, "Quit");
						AddMenuItem(841, "Quit");
					}
				}
			}
		}
	} ]

	CompletedMore[ (s)
	{
		ClearMenu();
		AddStaticItem(3102);
		AddStaticItem(179, false);
		AddMenuItem(182, "CompletedMore2");
	} ]

	CompletedMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(3103);
		AddStaticItem(179, false);
		AddMenuItem(182, "CompletedMore3");
	} ]

	CompletedMore3[ (s)
	{
		ClearMenu();
		AddStaticItem(845);
		AddStaticItem(179, false);
		AddMenuItem(591, "Quit");

		Locket = GetPlayer().FindInventory("locket");
		GetPlayer().RemoveItem(Locket);

		GetPlayer().SetQuestCompleted(4);
		GetPlayer().AddExperience(125);
	} ]
}
