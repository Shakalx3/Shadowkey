{
	Init[ (s)
	{
		SetUseText(2448);
		SetName(2449);
		SetRating(14);
		SetItemDescription(2450);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1600);
		SetMarketValue(560);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2448);
		}
		else
		{
			SetUseText(2451);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		//TODO.. need to make this effect timed
		GetOwner().PlaySound(83);
		DoAttackRoll(target, 10);
	} ]
}