{
	saved_Looted[0]
	Init[()
	{
		SetUseText(2670);
		SetUsable(true);

	}]
	OnUse[()
	{
		if(saved_Looted = 0)
		{
			OpenMenu("fearfrst\\\\loot7_menu");
		}
		else
		{
			OpenMenu("NoLoot");
		}
	}]
}