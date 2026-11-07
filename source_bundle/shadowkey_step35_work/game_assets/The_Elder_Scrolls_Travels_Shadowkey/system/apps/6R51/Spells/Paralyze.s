{
	Init[ (s)
	{
		SetUseText(2469);
		SetName(2469);
		SetRating(20);
		SetItemDescription(2470);
		RestrictUse(2, 4);
		SetIcon( 209 );
		SetCost(2300);
		SetMarketValue(805);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2471);
		}
		else
		{
			SetUseText(2472);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 9);
	} ]
}