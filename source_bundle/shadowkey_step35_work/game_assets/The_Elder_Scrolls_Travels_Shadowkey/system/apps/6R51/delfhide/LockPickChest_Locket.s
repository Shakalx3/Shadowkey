{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem("You successfully disarm the trap");
		AddStaticItem(179, false);
		AddMenuItem(386, "Locket");
	}]

	Locket[ (s)
	{
		GetOpener().Locket();
		saved_Open = 1;
	}]
}