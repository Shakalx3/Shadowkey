{

	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
		SetName(611);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		if (GetPlayer().QuestSolved(3) = false)
		{
			if( Random(1,3) = 1 )
			{
				OpenMenu("delfhide\\\\Chest_Grell_Trap");
				SetUsable(false);
			}
			else
			{
				OpenMenu("delfhide\\\\Chest_Grell_NoTrap");
				SetUsable(false);
			}
		}
	} ]
}