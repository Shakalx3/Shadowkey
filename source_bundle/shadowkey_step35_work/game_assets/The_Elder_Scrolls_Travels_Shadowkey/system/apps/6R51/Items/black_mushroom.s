{
	Init[ (s)
	{
		SetName(1601);
		SetShortName(1602);
		SetUsable( true );
		SetUseText(1603);
		SetCost( 550 );
		SetMarketValue( 193 );
		SetItemDescription(1604);
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 3, 300);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}