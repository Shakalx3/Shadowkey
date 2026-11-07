{
	Init[()
	{
		if(Level.saved_EgrienTalked = 0)
		{
			if(GetPlayer().QuestCompleted(17) = true)
			{
				AddStaticItem(2506);
				AddStaticItem(179, false);
				AddMenuItem(182, "More1");
				Level.saved_EgrienTalked = 1;
			}
			else
			{
				AddStaticItem(2507);
				AddStaticItem(179, false);
				AddMenuItem(1126, "BuyItems");
				AddMenuItem(1127, "SellItems");
				AddMenuItem(445, "Quit");
			}
		}
		else
		{
			AddStaticItem(2507);
			AddStaticItem(179, false);
			AddMenuItem(1126, "BuyItems");
			AddMenuItem(1127, "SellItems");
			AddMenuItem(445, "Quit");
		}
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(2508);
		AddStaticItem(179, false);
		AddMenuItem(2509, "More2");
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(2510);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]
	More3[()
	{
		ClearMenu();
		AddStaticItem(2511);
		AddStaticItem(179, false);
		AddMenuItem(1126, "BuyItems");
		AddMenuItem(1127, "SellItems");
		AddMenuItem(445, "Quit");
	}]
	BuyItems[()
	{
		Quit();
		GetPlayer().BuyFromMerchant();
	}]
	SellItems[()
	{
		Quit();
		GetPlayer().SellToMerchant();
	}]
	MenuQuit[()
	{
		Level.Log("Need someway to set the mercantile settings");
		Quit();
	}]
	
	EgrienStoutConvo[ ()
	{
		Quit();
	}]

	EgrienStoutConvoBack[ (s)
	{
		Quit();
	}]
}