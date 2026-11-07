{
	Init[ (s)
	{
		SetName(1769);
		SetShortName(1770);
		SetUsable( true );
		SetUseText(1630);
		SetCost( 45 );
		SetMarketValue( 16 );
		SetItemDescription(1771);
		SetIcon(211);
	} ]

	OnUse[ (s)
	{
		curHealth = GetOwner().GetHealth();
		GetOwner().SetHealth( curHealth + 15 );
		curMagicka = GetOwner().GetMagicka();
		GetOwner().SetMagicka( curMagicka + 15 );
		GetOwner().PlaySound(87);
		GetPlayer().RemoveEnchantments();
		DestroyObject(self);
	} ]
}