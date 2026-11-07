{
	Init[ (s)
	{
		SetUseText(2452);
		SetName(2452);
		SetRating(15);
		SetItemDescription(2453);
		RestrictUse(2, 4, 7, 6);
		SetIcon( 209 );
		SetCost(1890);
		SetMarketValue(662);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2454);
		}
		else
		{
			SetUseText(2455);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 13);
		//target.AddEffect(Timed, Attack, Increment, -10, seconds);
	} ]
}