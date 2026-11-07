{
	Init[ (s)
	{
		SetName(1628);
		SetShortName(1629);
		SetUsable( true );
		SetUseText(1630);
		SetCost( 900 );
		SetMarketValue( 315 );
		SetItemDescription(1631);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		GetOwner().SetSpellEffect(2, 1200); //PreciseMagic
		DestroyObject(self);
	} ]
}