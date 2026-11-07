{
	Init[ (s)
	{
		SetName(1714);
		SetShortName(1715);
		SetUsable( true );
		SetUseText(1716);
		SetCost( 8000 );
		SetMarketValue( 2800 );
		SetItemDescription(1623);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Timed, Strength, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Intelligence, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Agility, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Speed, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Perception, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Luck, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Endurance, Increment, 10, 120);
		GetOwner().AddEffect(Timed, Will, Increment, 10, 120);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}