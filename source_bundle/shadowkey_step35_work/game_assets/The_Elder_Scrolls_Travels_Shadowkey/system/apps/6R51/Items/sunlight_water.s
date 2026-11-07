{
	Init[ (s)
	{
		SetName(1740);
		SetShortName(1741);
		SetUsable( true );
		SetUseText(1742);
		SetCost( 380 );
		SetMarketValue( 133 );
		SetItemDescription(1743);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 5, 120);
		GetOwner().AddEffect(Timed, MagicResistance, Increment, 5, 120);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}