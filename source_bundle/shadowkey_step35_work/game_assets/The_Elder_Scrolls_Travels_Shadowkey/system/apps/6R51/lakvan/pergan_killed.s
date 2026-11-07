{
	Init[()
	{
		AddStaticItem(1858);
		AddStaticItem(1859);
		AddStaticItem(179, false);
		AddMenuItem(182, "Split");
	}]

	Split[()
	{
		if (GetPlayer().QuestAssigned(24)=false)
		{
			ClearMenu();
			AddStaticItem(1860);
			AddStaticItem(3888);
			AddStaticItem(179, false);
			AddMenuItem(3889, "Loot3");
			GetPlayer().SetQuestAssigned(9);
			GetPlayer().SetQuestSolved(9);
		}
		else
		{
			ClearMenu();
			AddStaticItem(1862);
			AddStaticItem(179, false);
			AddMenuItem(182, "Azra");
			GetPlayer().SetQuestSolved(24);
			GetPlayer().SetQuestCompleted(24);
		}
	}]

	Azra[()
	{
		ClearMenu();
		AddStaticItem(1863);
		AddStaticItem(1864);
		AddStaticItem(179, false);
		AddMenuItem(1865, "AzraCrossing");
	}]

	AzraCrossing[()
	{
		ClearMenu();
		AddStaticItem(1866);
		AddStaticItem(1867);
		AddStaticItem(179, false);
		AddMenuItem(182, "StarTooth");
	}]

	StarTooth[()
	{
		ClearMenu();
		AddStaticItem(1868);
		AddStaticItem(1869);
		AddStaticItem(179, false);
		AddMenuItem(1870, "Loot3");
	}]

	Loot3[()
	{
		ClearMenu();
		GetPlayer().OpenMenu("lakvan\\\\loot3");
	}]
}