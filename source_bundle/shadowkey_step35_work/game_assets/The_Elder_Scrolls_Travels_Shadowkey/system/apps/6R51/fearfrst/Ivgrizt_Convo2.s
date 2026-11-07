{
	Init[()
	{
		if(GetOpener().saved_WeTalked=0)
		{
			AddStaticItem(1343);
			AddStaticItem(179, false);
			AddMenuItem(182, "More1");
		}
		else
		{
			AddStaticItem(1344);
			AddStaticItem(179, false);
			AddMenuItem(1345, "Quit");
		}
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(1346);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(1347);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]
	More3[()
	{
		ClearMenu();
		AddStaticItem(1348);
		AddStaticItem(179, false);
		AddMenuItem(1349, "TakePack");
		AddMenuItem(1350, "Rummage");
	}]
	TakePack[()
	{
		GetPlayer().SetQuestSolved(23);
		Item = Level.CreateEntity( 4005 );
		GetPlayer().PickupItem( Item );
		GetOpener().saved_WeTalked = 1;
		Quit();
	}]
	Rummage[()
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(23);
		Item = Level.CreateEntity( 4005 );
		GetPlayer().PickupItem( Item );
		GetOpener().saved_WeTalked = 1;
		AddStaticItem(1351);
		AddStaticItem(179, false);
		AddMenuItem(1352, "MapInvoice");
		AddMenuItem(1353, "Quit");
	}]
	MapInvoice[()
	{
		ClearMenu();
		AddStaticItem(1354);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]
	More4[()
	{
		ClearMenu();
		AddStaticItem(1355);
		AddStaticItem(179, false);
		AddMenuItem(517, "Quit");
	}]
}