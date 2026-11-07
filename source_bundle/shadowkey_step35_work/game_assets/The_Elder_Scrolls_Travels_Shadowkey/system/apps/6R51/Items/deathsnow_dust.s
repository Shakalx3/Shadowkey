{
	Init[ (s)
	{
		SetName(1620);
		SetShortName(1621);
		SetUsable( true );
		SetUseText(1622);
		SetCost( 310 );
		SetMarketValue( 109 );
		SetItemDescription(1623);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, Attack, Increment, 10, 30);
		DestroyObject(self);
	} ]
}