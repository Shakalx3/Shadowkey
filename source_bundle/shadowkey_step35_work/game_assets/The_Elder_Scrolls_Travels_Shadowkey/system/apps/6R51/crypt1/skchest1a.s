{
	saved_SkChest1[0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( saved_SkChest1 = 0)
		{
		OpenMenu("crypt1\\\\skchest1");
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