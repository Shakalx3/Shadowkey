{
	Init[ (s)
	{
		SetName(3680);
		SetShortName(3681);
		SetUsable( true );
		SetUseText(3682);
		SetCost( 650 );
		SetMarketValue( 228 );
		SetItemDescription(3683);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 2, 120);
		GetOwner().AddEffect(Timed, Defense, Increment, 2, 120);
		GetOwner().AddEffect(Timed, Strength, Increment, 10, 120);
		DestroyObject(self);
	} ]
}