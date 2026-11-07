{
	Doses [8]

	Init[ (s)
	{
		SetName(909);
		SetUseText(910);
		SetCost( 25 );
		SetMarketValue( 7 );
		SetItemDescription( 1678 );
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		if( Doses > 0 )
		{
			GetOwner().PlaySound(87);
			curFatigue = GetPlayer().GetFatigue();
			GetPlayer().SetFatigue( curFatigue + 30 );
		}
	} ]
}