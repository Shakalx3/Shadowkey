{
	saved_Agility[0]

	Init[()
	{
		SetUseText(565);
		SetUsable(true);
	}]

	OnUse[(who)
	{
		SetUsable(false);
		GetPlayer().DoDamage(Random(4,9));
		if(saved_Agility = 0)
		{
			OpenMenu("crypt1\\\\agility");
			saved_Agility = 1;
		}
	}]
}