{
	Init[ (s)
	{
		SetName(3684);
		SetShortName(3685);
		SetUsable( true );
		SetUseText(3686);
		SetCost( 915 );
		SetMarketValue( 320 );
		SetItemDescription(3687);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, ArmorValue, Increment, 2, 300);
		GetOwner().AddEffect(Timed, Defense, Increment, 2, 300);
		GetOwner().AddEffect(Timed, Strength, Increment, 10, 300);
		DestroyObject(self);
	} ]
}