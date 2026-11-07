{
	Init[ (s)
	{
		SetName(1657);
		SetShortName(1658);
		SetUsable( true );
		SetUseText(1622);
		SetCost( 620 );
		SetMarketValue( 217 );
		SetItemDescription(1659);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, Defense, Increment, 10, 30);
		DestroyObject(self);
	} ]
}