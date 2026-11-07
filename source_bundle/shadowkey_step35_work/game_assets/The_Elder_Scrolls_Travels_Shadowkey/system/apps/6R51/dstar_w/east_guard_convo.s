{
	Init[()
	{
		if(GetPlayer().QuestAssigned(37)=false)
		{
			ClearMenu();
			AddStaticItem(1147);
			AddStaticItem(179, false);
			AddMenuItem(1148, "More1");
		}
		else
		{
			if(GetPlayer().QuestSolved(37)=false)
			{
				ClearMenu();
				AddStaticItem(1149);
				AddStaticItem(179, false);
				AddMenuItem(3657, "MenuQuit");
			}
			else
			{
				if(GetPlayer().QuestCompleted(37)=true)
				{
					ClearMenu();
					AddStaticItem(3658);
					AddStaticItem(179, false);
					AddMenuItem(3590, "MenuQuit");
				}
				else
				{

					ClearMenu();
					AddStaticItem(1151);
					AddStaticItem(1152);
					AddStaticItem(179, false);
					AddMenuItem(182, "Done");
				}

			}
		}
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(1154);
		AddStaticItem(179, false);
		AddMenuItem(1046, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(1155);
		AddStaticItem(1156);
		AddStaticItem(179, false);
		AddMenuItem(3644, "Accept");
		AddMenuItem(3643, "MenuQuit");
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(3659);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
		GetPlayer().SetQuestCompleted(37);
		GetPlayer().AddExperience(1750);
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(37);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
