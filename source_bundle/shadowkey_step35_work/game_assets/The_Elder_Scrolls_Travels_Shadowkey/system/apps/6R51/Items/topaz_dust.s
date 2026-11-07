{
	Init[ (s)
	{
		SetName(1749);
		SetShortName(1750);
		SetUsable( true );
		SetUseText(1630);
		SetCost( 3200 );
		SetMarketValue( 1120 );
		SetItemDescription(1751);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().AddEffect(Permanent, Personality, Increment, 5);
		GetOwner().AddEffect(Permanent, Agility, Increment, -2);
		GetOwner().AddEffect(Permanent, Luck, Increment, -1);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}