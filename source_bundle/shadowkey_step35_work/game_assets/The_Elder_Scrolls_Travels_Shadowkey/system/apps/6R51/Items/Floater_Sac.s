{
	Init[ (s)
	{
		SetName(3941);
		SetShortName(3942);
		SetUsable( true );
		SetUseText(3943);
		SetID("ftersac");
		SetCost( 400 );
		SetMarketValue( 140 );
		SetItemDescription(3944);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, MagicResistance, Increment, 5, 120);
		DestroyObject(self);
	} ]
}