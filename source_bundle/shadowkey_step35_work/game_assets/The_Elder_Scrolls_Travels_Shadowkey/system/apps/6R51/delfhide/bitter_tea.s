{
	Init[ (s)
	{
		SetName(727);
		SetUseText(728);
		SetUsable(true);
		SetCost( 12 );
		SetMarketValue( 4 );
		SetItemDescription(1600);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Permanent, Endurance, Increment, 5);
		GetOwner().AddEffect(Permanent, Agility, Increment, -2);
		GetOwner().AddEffect(Permanent, Intelligence, Increment, -1);
	} ]
}