{
	saved_Strength[0]

	Init[()
	{
		SetUseText(565);
		SetUsable(true);
	}]

	OnUse[(who)
	{
		SetUsable(false);
		GetPlayer().DoDamage(Random(4,9));
		if(saved_Strength = 0)
		{
			OpenMenu("crypt1\\\\strength");
			saved_Strength = 1;
		}
	}]
}