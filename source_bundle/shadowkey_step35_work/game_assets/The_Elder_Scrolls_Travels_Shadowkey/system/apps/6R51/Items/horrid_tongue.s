{
	Init[ (s)
	{
		SetName(1649);
		SetShortName(1650);
		SetUsable( true );
		SetUseText(1651);
		SetID("hortong");
		SetCost( 890 );
		SetMarketValue( 312 );
		SetItemDescription(1652);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, MagicResistance, Increment, 5, 180);
		DestroyObject(self);
	} ]
}
