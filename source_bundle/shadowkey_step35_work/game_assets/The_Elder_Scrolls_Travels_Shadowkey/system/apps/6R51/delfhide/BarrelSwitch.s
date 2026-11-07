{
	Uses [1]

	Init[ (s)
	{
		SetUseText(3760);
		SetUsable(true);
		SetName(3760);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		if( Uses > 0 )
		{
			GetPlayer().OpenMenu("delfhide\\\\good_drink");
			GetPlayer().SetHealth( GetPlayer().GetHealth() + 5 );
			SetUsable(false);
		}
	} ]
}