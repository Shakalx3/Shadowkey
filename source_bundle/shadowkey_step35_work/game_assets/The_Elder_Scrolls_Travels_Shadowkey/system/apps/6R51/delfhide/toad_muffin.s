{
	Doses [8]

	Init[ (s)
	{
		SetName(911);
		SetCost( 20 );
		SetMarketValue( 7 );
		SetIcon(212);
		SetItemDescription(1748);
		SetUseText(912);
		SetUsable(true);
	} ]

	OnUse[ (s)
	{
		if( Doses > 0 )
		{
			GetPlayer().SetFatigue( GetPlayer().GetFatigue() + 20 );
			GetPlayer().SetMagicka( GetPlayer().GetMagicka() + 10 );
		}
		else
		{
			Doses = Doses - 1;
		}
	} ]
}