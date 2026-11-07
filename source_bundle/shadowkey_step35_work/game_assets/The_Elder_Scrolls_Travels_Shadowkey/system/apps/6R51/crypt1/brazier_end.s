{
	saved_Endurance[0]

	Init[()
	{
		SetUseText(565);
		SetUsable(true);
	}]

	OnUse[(who)
	{
		SetUsable(false);
		GetPlayer().DoDamage(Random(4,9));
		if(saved_Endurance = 0)
		{
			OpenMenu("crypt1\\\\endurance");
			saved_Endurance = 1;
		}
	}]
}