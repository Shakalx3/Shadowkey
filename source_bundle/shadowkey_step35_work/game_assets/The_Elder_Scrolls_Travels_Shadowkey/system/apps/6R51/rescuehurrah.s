{
	Init[ (s)
	{
		
		ClearMenu();
		AddStaticItem("You have freed the");
		AddStaticItem("captured villagers!");
		AddStaticItem("Return to Almathea");
		AddStaticItem("in Azra for reward.");
		AddStaticItem("-----");
		AddMenuItem("Exit", "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}