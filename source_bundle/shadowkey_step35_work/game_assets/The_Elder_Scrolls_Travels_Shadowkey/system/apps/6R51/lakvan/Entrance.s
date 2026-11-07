{
	Init[()
	{
		if (GetPlayer().QuestAssigned(24)=false)
		{
			ClearMenu();
			AddStaticItem(1813);
			AddStaticItem(179, false);
			AddMenuItem(182, "NotAssigned");
		}
		else
		{
			if(GetPlayer().QuestAssigned(9) = false)
			{
				ClearMenu();
				AddStaticItem(1813);
				AddStaticItem(179, false);
				AddMenuItem(182, "Assigned");
			}
			else
			{
				ClearMenu();
				AddStaticItem(1813);
				AddStaticItem(179, false);
				AddMenuItem(182, "NotAssigned");
			}
		}
	}]

	NotAssigned[()
	{
		ClearMenu();
		AddStaticItem(1814);
		AddStaticItem(179, false);
		AddMenuItem(1815, "MenuQuit");
		Level.saved_Entrance = 1;
	}]

	Assigned[()
	{
		ClearMenu();
		AddStaticItem(1816);
		AddStaticItem(1817);
		AddStaticItem(179, false);
		AddMenuItem(877, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(1818);
		AddStaticItem(179, false);
		AddMenuItem(1820, "MenuQuit");
		Level.saved_Entrance = 1;
	}]

	MenuQuit[()
	{
		Quit();
	}]
}