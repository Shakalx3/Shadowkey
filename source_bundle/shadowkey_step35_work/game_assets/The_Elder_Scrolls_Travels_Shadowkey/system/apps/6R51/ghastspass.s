{
	Init[ (s)
	{	
		ClearMenu();
		AddStaticItem(1428);
		AddStaticItem(1429);
		AddStaticItem(1430);
		AddStaticItem(1431);
		AddStaticItem(179, false);
		AddMenuItem(1432, "MenuQuit");
	}]
	
	OnUse[ (s)
	{
		Level.LoadLevel("GhstPass");
	} ]	

	MenuQuit[ (s)
	{
		Quit();
	}]
}