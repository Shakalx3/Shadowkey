{
	Init[ (s)
	{
		SetName(1756);
		SetShortName(1757);
		SetUsable( true );
		SetUseText(1729);
		SetCost( 18 );
		SetMarketValue( 6 );
		SetItemDescription(1758);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue - 50 );
		curHealth = GetOwner().GetHealth();
		GetOwner().SetHealth( curHealth + 25 );
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}