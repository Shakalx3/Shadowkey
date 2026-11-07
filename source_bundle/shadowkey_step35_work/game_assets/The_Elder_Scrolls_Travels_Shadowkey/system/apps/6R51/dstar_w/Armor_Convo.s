{

	Init[ (s)
	{
		AddStaticItem(1125);
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
	
	armor_convoBack[ ()
	{
		Quit();
	}]
}