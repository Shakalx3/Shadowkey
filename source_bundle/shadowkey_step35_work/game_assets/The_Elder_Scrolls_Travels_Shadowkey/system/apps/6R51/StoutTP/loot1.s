{
	saved_Opened[0]
	Init[()
	{
		SetUseText(610);
		SetUsable(true);
	}]

	OnUse[ (s)
	{

		if( saved_Opened = 0)
		{
			OpenMenu("StoutTP\\\\loot1_menu");
		}
		else
		{
			OpenMenu("NoLoot");
		}

	} ]
}