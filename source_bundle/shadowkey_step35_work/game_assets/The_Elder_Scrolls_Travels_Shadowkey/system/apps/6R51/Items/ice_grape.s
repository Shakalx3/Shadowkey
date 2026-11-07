{
	Init[ (s)
	{
		SetName(1653);
		SetShortName(1654);
		SetUsable( true );
		SetUseText(1655);
		SetCost( 535 );
		SetMarketValue( 187 );
		SetItemDescription(1656);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, MagicResistance, Increment, 10, 30);
		DestroyObject(self);
	} ]
}