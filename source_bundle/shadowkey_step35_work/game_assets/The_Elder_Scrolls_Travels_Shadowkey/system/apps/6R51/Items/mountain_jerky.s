{
	Init[ (s)
	{
		SetName(1672);
		SetShortName(1673);
		SetUsable( true );
		SetUseText(1674);
		SetCost( 220 );
		SetMarketValue( 77 );
		SetItemDescription(1675);
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		GetOwner().PlaySound(87);
		curHealth = GetOwner().GetHealth();
		GetOwner().SetHealth( curHealth + 20 );
		curMagicka = GetOwner().GetMagicka();
		GetOwner().SetMagicka( curMagicka + 20 );
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue + 100 );
		DestroyObject(self);
	} ]
}