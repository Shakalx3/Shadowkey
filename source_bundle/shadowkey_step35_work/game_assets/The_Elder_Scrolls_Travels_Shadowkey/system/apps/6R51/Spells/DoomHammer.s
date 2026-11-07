{
	Init[ (s)
	{
		SetUseText(2436);
		SetName(2436);
		SetRating(11);
		SetItemDescription(2437);
		RestrictUse(2, 4, 7, 6);
		SetIcon( 209 );
		SetCost(5200);
		SetMarketValue(1820);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2438);
		}
		else
		{
			SetUseText(2439);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 2);
	} ]

}