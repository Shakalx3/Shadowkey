{
	Init[ (s)
	{
		AddStaticItem(3609);
		AddStaticItem(179, false);
		AddMenuItem(3306, "Use_CellKey");
		AddMenuItem(3307, "MenuQuit");
	}]

	Use_CellKey[ (s)
	{
		GetOpener().OpenDoor(" ");
		GetOpener().SetUsable(false);
		key = GetPlayer().FindInventory("cellkey");
		Quit();
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}