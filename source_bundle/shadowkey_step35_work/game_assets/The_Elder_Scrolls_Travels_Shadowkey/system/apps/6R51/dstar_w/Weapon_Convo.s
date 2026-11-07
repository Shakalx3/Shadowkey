{

	Init[ (s)
	{
		AddStaticItem(1237);
		AddStaticItem(179, false);
		AddMenuItem(1126, "BuyItems");
		AddMenuItem(1127, "SellItems");
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]

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
	
	weapon_convoBack[ ()
	{
		Quit();
	}]
}