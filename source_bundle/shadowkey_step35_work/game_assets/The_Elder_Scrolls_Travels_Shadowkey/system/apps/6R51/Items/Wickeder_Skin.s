{
	Init[ (s)
	{
		SetName(3945);
		SetShortName(3946);
		SetUsable( true );
		SetUseText(3945);
		SetCost( 560 );
		SetMarketValue( 196 );
		SetItemDescription(3948);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 2, 120);
		GetOwner().AddEffect(Timed, Defense, Increment, 2, 120);
		DestroyObject(self);
	} ]
}