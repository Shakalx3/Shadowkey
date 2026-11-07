{
	Init[ (s)
	{		
		ClearMenu();
		MenuBackground(20);	

		AddStaticItem(3500);
		AddStaticItem(714);
		if( IsPurchased( 0 ) )
		{
			AddStaticItem(3501,0);
		}
		else
		{
			AddMenuItem(3502, "Item0");
		}

		if( IsPurchased( 1 ) )
		{
			AddStaticItem(3503,0);
		}
		else
		{
			AddMenuItem(3504, "Item1");
		}

		if( IsPurchased( 2 ) )
		{
			AddStaticItem(3505,0);
		}
		else
		{
			AddMenuItem(3506, "Item2");
		}

		if( IsPurchased( 3 ) )
		{
			AddStaticItem(3507,0);
		}
		else
		{
			AddMenuItem(3508, "Item3");
		}

		if( IsPurchased( 4 ) )
		{
			AddStaticItem(3509,0);
		}
		else
		{
			AddMenuItem(3510, "Item4");
		}

		if( IsPurchased( 5 ) )
		{
			AddStaticItem(3511,0);
		}
		else
		{
			AddMenuItem(3512, "Item5");
		}

		if( IsPurchased( 6 ) )
		{
			AddStaticItem(3513,0);
		}
		else
		{
			AddMenuItem(3514, "Item6");
		}

		if( IsPurchased( 7 ) )
		{
			AddStaticItem(3515,0);
		}
		else
		{
			AddMenuItem(3516, "Item7");
		}

		if( IsPurchased( 8 ) )
		{
			AddStaticItem(3517,0);
		}	
		else
		{
			AddMenuItem(3518, "Item8");
		}

		AddQuitButton("Back","MenuBack");
	} ]

	Item0[ (s)
	{
		PurchaseItem(0);
		StartDownload();
	} ]

	Item1[ (s)
	{
		PurchaseItem(1);
		StartDownload();
	} ]

	Item2[ (s)
	{
		PurchaseItem(2);
		StartDownload();
	} ]

	Item3[ (s)
	{
		PurchaseItem(3);
		StartDownload();
	} ]

	Item4[ (s)
	{
		PurchaseItem(4);
		StartDownload();
	} ]

	Item5[ (s)
	{
		PurchaseItem(5);
		StartDownload();
	} ]

	Item6[ (s)
	{
		PurchaseItem(6);
		StartDownload();
	} ]

	Item7[ (s)
	{
		PurchaseItem(7);
		StartDownload();
	} ]

	Item8[ (s)
	{
		PurchaseItem(8);
		StartDownload();
	} ]
	
	MenuBack[ (s)
	{
		OpenMenu("Menus\\\\MultiPlayerMenu");
	} ]

}