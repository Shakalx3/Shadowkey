{
	Init[ (s)
	{
		SetName(4060);
		SetUsable( true );
		SetUseText(4060);
		SetCost( 3400 );
		SetMarketValue( 1190 );
		SetItemDescription(4061);
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, MagicResistance, Increment, 15, 300);
		DestroyObject(self);
	} ]
}