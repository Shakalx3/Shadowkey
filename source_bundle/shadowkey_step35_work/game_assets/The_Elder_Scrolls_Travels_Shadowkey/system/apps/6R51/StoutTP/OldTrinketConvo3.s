{
	Init[()
	{
		if(GetOpener().saved_Talked = 0)
		{
			AddStaticItem(2514);
			AddStaticItem(179, false);
			AddMenuItem(2515, "Crypt");
			AddMenuItem(2516, "Quit");
		}
		else
		{
			if(GetOpener().saved_Talked = 1)
			{
				AddStaticItem(2517);
				AddStaticItem(179, false);
				AddMenuItem(2518, "Quit");
				AddMenuItem(2519, "RoundTwo");
			}
			else
			{
				AddStaticItem(2520);
				AddStaticItem(179, false);
				AddMenuItem(2521, "Quit");
			}
		}
	}]
	Crypt[()
	{
		ClearMenu();
		AddStaticItem(2522);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(2523);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(2524);
		AddStaticItem(179, false);
		AddMenuItem(758, "Training");
		AddMenuItem(2516, "Quit");
	}]
	Training[()
	{
		ClearMenu();
		AddStaticItem(2525);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]
	More3[()
	{
		ClearMenu();
		AddStaticItem(2526);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]
	More4[()
	{
		ClearMenu();
		AddStaticItem(2527);
		AddStaticItem(179, false);
		AddMenuItem(182, "More5");
	}]
	More5[()
	{
		ClearMenu();
		AddStaticItem(2528);
		AddStaticItem(179, false);
		AddMenuItem(182, "More6");
	}]
	More6[()
	{
		ClearMenu();
		AddStaticItem(2529);
		AddStaticItem(179, false);
		AddMenuItem(2530, "Quit");
		AddMenuItem(2531, "RoundTwo");
		GetOpener().saved_Talked = 1;
		GetPlayer().AddEffect(Permanent, Defense, Increment, 1);
	}]
	RoundTwo[()
	{
		ClearMenu();
		AddStaticItem(2532);
		AddStaticItem(179, false);
		AddMenuItem(182, "More7");
	}]
	More7[()
	{
		ClearMenu();
		AddStaticItem(2533);
		AddStaticItem(179, false);
		AddMenuItem(182, "More8");
	}]
	More8[()
	{
		ClearMenu();
		AddStaticItem(2534);
		AddStaticItem(179, false);
		AddMenuItem(182, "More9");
	}]
	More9[()
	{
		ClearMenu();
		AddStaticItem(2535);
		AddStaticItem(179, false);
		AddMenuItem(2536, "Quit");
		GetOpener().saved_Talked = 2;
		GetPlayer().AddEffect(Permanent, Defense, Increment, 1);
	}]
}