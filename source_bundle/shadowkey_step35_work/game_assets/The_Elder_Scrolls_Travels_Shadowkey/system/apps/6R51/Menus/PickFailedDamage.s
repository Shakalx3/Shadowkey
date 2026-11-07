{
	Init[ (s)
	{
		AddStaticItem(3562);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		GetPlayer().PlaySound( 66 );
	} ]
}