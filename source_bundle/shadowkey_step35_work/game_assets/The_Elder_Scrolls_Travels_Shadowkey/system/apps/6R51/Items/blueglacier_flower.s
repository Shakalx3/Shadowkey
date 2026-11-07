{
	Init[ (s)
	{
		SetName(1605);
		SetShortName(1606);
		SetUsable( true );
		SetUseText(1607);
		SetCost( 830 );
		SetMarketValue( 291 );
		SetItemDescription(1608);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().AddEffect(Timed, Luck, Increment, 40, 30);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue - 20 );
		DestroyObject(self);
	} ]
}