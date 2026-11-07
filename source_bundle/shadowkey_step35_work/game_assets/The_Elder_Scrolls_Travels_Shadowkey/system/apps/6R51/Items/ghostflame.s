{
	Init[ (s)
	{
		SetName(1634);
		SetShortName(1635);
		SetUsable( true );
		SetUseText(1636);
		SetCost( 85 );
		SetMarketValue( 30 );
		SetItemDescription(1637);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue - 30 );
		DestroyObject(self);
	} ]
}