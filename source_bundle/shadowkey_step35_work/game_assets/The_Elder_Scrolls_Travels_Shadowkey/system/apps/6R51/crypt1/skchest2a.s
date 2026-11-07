{
	saved_SkChest2[0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( saved_SkChest2 = 0)
		{
		OpenMenu("crypt1\\\\skchest2");
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