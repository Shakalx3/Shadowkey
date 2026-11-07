{
	Init[ (s)
	{
		SetName(3563);
		SetUsable( true );
		SetUseText(3563);
		SetCost( 466 );
		SetMarketValue( 163 );
		SetItemDescription(3564);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{

		curMagicka = GetOwner().GetMagicka();
		if (curMagicka > 9)
		{
			curMagicka = GetOwner().GetMagicka();
			GetOwner().SetMagicka( curMagicka - 10 );
			curHealth = GetOwner().GetHealth();
			GetOwner().SetHealth( curHealth + 30 );
			GetOwner().PlaySound(87);
			DestroyObject(self);
		}
		else
		{
			GetOwner().PlaySound(58);
		}
	} ]
}