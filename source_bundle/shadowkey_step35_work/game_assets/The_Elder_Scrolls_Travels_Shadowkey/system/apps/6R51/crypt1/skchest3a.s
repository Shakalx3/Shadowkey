{
	saved_SkChest3[0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( saved_SkChest3 = 0)
		{
		OpenMenu("crypt1\\\\skchest3");
		}
		else
		{
		OpenMenu("NoLoot");
		}

	} ]

	MenuQuit[()
	{
		Quit();
	}]
}