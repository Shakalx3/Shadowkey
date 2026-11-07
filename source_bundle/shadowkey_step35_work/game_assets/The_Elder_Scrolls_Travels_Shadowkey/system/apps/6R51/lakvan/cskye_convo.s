{
	Init[()
	{
		Tongue = GetPlayer().FindInventory("hortong");
		Heart = GetPlayer().FindInventory("spdhart");
		if(( Tongue != null) and (Heart != null ) and (GetPlayer().QuestAssigned(30)=true))
		{
			GetPlayer().SetQuestSolved(30);
		}
		ClearMenu();
		if(GetPlayer().QuestSolved(155)=false)
		{
			AddStaticItem(1783);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}
		else
		{
			if(GetPlayer().QuestAssigned(30)=false)
			{
				AddStaticItem(1784);
				AddStaticItem(1785);
				AddStaticItem(179, false);
				AddMenuItem(182, "MoreAccept1");
			}
			else
			{
				if(GetPlayer().QuestSolved(30)=false)
				{
					AddStaticItem(1786);
					AddStaticItem(1787);
					AddStaticItem(179, false);
					AddMenuItem(1788, "MenuQuit");
					AddMenuItem(1789, "MenuQuit");
				}
				else
				{
					if(GetPlayer().QuestCompleted(30)=false)
					{
						AddStaticItem(1790);
						AddStaticItem(1791);
						AddStaticItem(179, false);
						AddMenuItem(1375, "MoreSolved1");
					}
					else
					{
						AddStaticItem(1792);
						AddStaticItem(179, false);
						AddMenuItem(1509, "MenuQuit");
					}
				}
			}
		}
	}]

	MoreSolved1[()
	{
		Tongue = GetPlayer().FindInventory("hortong");
		Heart = GetPlayer().FindInventory("spdhart");
		if(( Tongue != null) and (Heart != null ))
		{
			ClearMenu();
			AddStaticItem(1795);
			AddStaticItem(1796);
			AddStaticItem(1797);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreSolved2");
			GetPlayer().RemoveItem(Tongue);
			GetPlayer().RemoveItem(Heart);
		}
		else
		{
			AddStaticItem(1793);
			AddStaticItem(1794);
			AddStaticItem(179, false);
			AddMenuItem(182, "MenuQuit");
		}
	}]

	MoreSolved2[()
	{
		ClearMenu();
		AddStaticItem(1798);
		AddStaticItem(179, false);
		AddMenuItem(1799, "ImperialScroll");
		GetPlayer().AddExperience(2500);
		GetPlayer().SetQuestCompleted(30);
	}]

	ImperialScroll[()
	{
		ClearMenu();
		OpenMenu("lakvan\\\\Imperial_Scroll");
	}]

	MoreNotSolved[()
	{
		ClearMenu();
		AddStaticItem(1800);
		AddStaticItem(179, false);
		AddMenuItem(1801, "MenuQuit");
	}]

	MoreAccept1[()
	{
		ClearMenu();
		AddStaticItem(1802);
		AddStaticItem(1803);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreAccept2");
	}]

	MoreAccept2[()
	{
		ClearMenu();
		AddStaticItem(1804);
		AddStaticItem(1805);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreAccept3");
	}]

	MoreAccept3[()
	{
		ClearMenu();
		AddStaticItem(1806);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreAccept4");
	}]

	MoreAccept4[()
	{
		ClearMenu();
		AddStaticItem(1807);
		AddStaticItem(1808);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreAccept5");
	}]

	MoreAccept5[()
	{
		ClearMenu();
		AddStaticItem(1809);
		AddStaticItem(1810);
		AddStaticItem(179, false);
		AddMenuItem(1811, "Accepted");
		AddMenuItem(1004, "MenuQuit");
	}]

	Accepted[()
	{
		GetPlayer().SetQuestAssigned(30);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}