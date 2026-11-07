{
	Init[()
	{
		MenuBackground(69);
		Retry();
	}]

	Retry[()
	{
		ClearMenu();
		AddStaticItem(3959);
		AddMenuItem(3960, "Try");
		AddMenuItem(517, "LocalQuitGame");
	}]

	Try[()
	{
		if(SaveConfig() = false)
		{
			Retry();
		}
		else
		{
			LocalQuitGame();
		}
	}]

	LocalQuitGame[()
	{
		QuitGame(false);
	}]
}
