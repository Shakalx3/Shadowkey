{
	Init[ (s)
	{
		if (Level.saved_Loopie = 0)
		{
			ClearMenu();
			AddStaticItem(2291);
			AddStaticItem(179, false);
			AddMenuItem(182, "More1");
		}
		else
		{
			More2();
		}
	}]

	More1[ (s)
	{
		ClearMenu();
		AddStaticItem(2292);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
		Level.saved_Loopie = 1;
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(2293);
		AddStaticItem(179, false);
		AddMenuItem(2294, "Herbs");
		AddMenuItem(2295, "Cold");
		AddMenuItem(2296, "Trade");
		AddMenuItem(2297, "Return");
		AddMenuItem(1509, "Quit");
	} ]

	Herbs[ (s)
	{
		ClearMenu();
		AddStaticItem(2298);
		AddStaticItem(179, false);
		AddMenuItem(2299, "More2");
		AddMenuItem(1082, "Quit");
	} ]

	Cold[ (s)
	{
		ClearMenu();
		AddStaticItem(2300);
		AddStaticItem(179, false);
		AddMenuItem(2299, "More2");
		AddMenuItem(386, "Quit");
	} ]

	Trade[ (s)
	{
		ClearMenu();
		AddStaticItem(2301);
		AddStaticItem(179, false);
		AddMenuItem(1126, "BuyItems");
		AddMenuItem(1127, "SellItems");
		AddMenuItem(2299, "More2");
	} ]

	Return[ (s)
	{
		ClearMenu();
		AddStaticItem(2302);
		AddStaticItem(179, false);
		AddMenuItem(2303, "More2");
		AddMenuItem(783, "Teleport");
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

	Teleport[ (s)
	{
		Quit();
		GetPlayer().SetPositionMirror( 18688, 21408, -2944 );
	} ]

	LlewydrConvoBack[ ()
	{
		Quit();
	}]
}