{
	Init[ (s)
	{
		SetName(2729);
		SetUseText(1696);
		SetUsable(true);
		SetMPUsable(true);
	} ]

	OnUse[ ()
	{

		if(GetPlayer().FindStringEffect(ItemUsed, "crystals") = false)
		{
			GetPlayer().SetHealth(GetPlayer().GetHealth() + 10);
			GetPlayer().AddEffect(Timed, Agility, Increment, 30, 300);
			GetPlayer().AddEffect(Timed, ItemUsed, 0, 0, 60, "crystals");
		}
		else
		{
			OpenMenu("CantUse");
		}

	}]
}