{
	Charges [5]
	Init[ (s)
	{
		SetName(1265);
		SetUseText(1266);
		SetUsable(true);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		if( Charges > 0 )
		{
			GetPlayer().SetHealth( GetPlayer().GetHealth() + 20 );
			Charges = Charges - 1;
		}
	} ]
}