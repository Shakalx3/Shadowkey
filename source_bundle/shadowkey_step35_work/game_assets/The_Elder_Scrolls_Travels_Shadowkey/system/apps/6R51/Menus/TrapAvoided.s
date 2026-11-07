{
	Init[ (s)
	{
		ClearMenu();

		AddStaticItem(2024);
		AddStaticItem(179, false);
		AddMenuItem(386,"Quit");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);

	} ]

	TrapAvoidedBack[ ()
	{
		Quit();
		opener=GetOpener();
		if (opener != null)
		{
			opener.OnUse();
		}
	}]
}