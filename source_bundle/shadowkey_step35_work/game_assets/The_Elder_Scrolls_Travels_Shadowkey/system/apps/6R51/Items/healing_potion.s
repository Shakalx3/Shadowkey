{
	Init[ (s)
	{
		SetName(1645);
		SetShortName(1646);
		SetUsable(true);
		SetUseText(1647);
		SetCost( 65 );
		SetMarketValue( 23 );
		SetItemDescription(1648);
		SetIcon(210);
	} ]

	OnUse[ (s)
	{
		curHealth = GetOwner().GetHealth() + 30;
		GetOwner().SetHealth( curHealth);
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}