{
	Init[ (s)
	{
		SetName(1720);
		SetShortName(1721);
		SetUsable( true );
		SetUseText(1722);
		SetCost( 400 );
		SetMarketValue( 140 );
		SetItemDescription(1723);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		curFatigue = GetOwner().GetMaxFatigue();
		curHealth = GetOwner().GetMaxHealth();
		curMagicka = GetOwner().GetMaxMagicka();
		GetOwner().SetFatigue(curFatigue);
		GetOwner().SetHealth(curHealth);
		GetOwner().SetMagicka(curMagicka);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}