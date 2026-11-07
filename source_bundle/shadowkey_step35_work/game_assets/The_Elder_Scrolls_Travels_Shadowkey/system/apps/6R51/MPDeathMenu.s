{

	Init[ (s)
	{
		MenuBackground(20);

		AddStaticItem(3952);
		AddStaticItem(714);
		AddStaticItem(714);
		//AddMenuItem(517,"MenuQuit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]

	MenuNewGame[ (s)
	{
		// Tell the engine to start a new game
		//NewGame();
		MenuBackground(20);
		OpenMenu("Menus\\\\NewGameMenu");
	} ]

	MenuLoadGame[ (s)
	{
		// Tell the engine to load a new game (probably opens a new menu)
		MenuBackground(20);
		//LoadGame();
		OpenMenu("LoadGameMenu");
		Quit();
	} ]

	MenuSaveGame[ (s)
	{
		// Tell the engine to save a new game (probably opens a new menu)
		//SaveGame();
		MenuBackground(20);
		Quit();
	} ]

	MenuOptions[ (s)
	{
		//Options();
		MenuBackground(20);
		OpenMenu("Options");		
	} ]

	MPDeathMenuBack[ (s)
	{
		MenuBackground(20);
		//QuitGame();
		QuitToMenu();
	} ]

	MenuCheat[ (s)
	{
		MenuBackground(20);
		OpenMenu("CheatMenu");
	} ]

	OnRightSoftkey[ (s)
	{
		MenuBackground(20);
		MenuQuit();
	} ]

}