{
	Init[ (s)
	{
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

		return;
	} ]

	ConfigKeys2Back[ (s)
	{
		OpenMenu("ConfigKeys");
	}]

	BackToConfig[ (s)
	{
		OpenMenu("ConfigKeys");
	}]

	ConfigKeys2Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}