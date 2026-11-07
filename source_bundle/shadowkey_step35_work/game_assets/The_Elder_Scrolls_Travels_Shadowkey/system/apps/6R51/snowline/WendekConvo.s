{
	Init[ (s)
	{
		if( Level.saved_Already = 0 )
		{
			ClearMenu();
			AddStaticItem(2391);
			AddStaticItem(179, false);
			if(Level.saved_WendekTalked = 0)
			{
				if(GetPlayer().QuestCompleted(17) = true)
				{
					AddMenuItem(182, "Expected");
					Level.saved_WendekTalked = 1;
				}
				else
				{
					AddMenuItem(182, "More");
				}
			}
			else
			{
				AddMenuItem(182, "More");
			}
			Level.saved_Already = 1;
		}
		else
		{
			if((GetPlayer().QuestCompleted(17) = true) and (Level.saved_WendekTalked = 0))
			{
				AddStaticItem(3772);
				AddStaticItem(179, false);
				AddMenuItem(755, "More");
				Level.saved_WendekTalked = 1;
			}
			else
			{
				ClearMenu();
				AddStaticItem(2393);
				AddStaticItem(179, false);
				AddMenuItem(1126, "BuyItems");
				AddMenuItem(1127, "SellItems");
				AddMenuItem(445, "Quit");
			}
		}
	} ]

	Expected[()
	{
		ClearMenu();
		AddStaticItem(3772);
		AddStaticItem(179, false);
		AddMenuItem(755, "More");
	}]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(2394);
		AddStaticItem(179, false);
		AddMenuItem(1126, "BuyItems");
		AddMenuItem(1127, "SellItems");
		AddMenuItem(445, "Quit");
	} ]

	BuyItems[ ()
	{
		Quit();
		GetPlayer().BuyFromMerchant();
	}]

	SellItems[ ()
	{
		Quit();
		GetPlayer().SellToMerchant();
	}]

	wendekconvoBack[ ()
	{
		Quit();
	}]
}