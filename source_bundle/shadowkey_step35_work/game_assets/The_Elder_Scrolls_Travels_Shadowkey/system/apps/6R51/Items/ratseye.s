{
        Init[ (s)
        {
                SetUseText(1687);
                SetUsable( true );
                SetName(1688);
                SetShortName(1689);
                SetCost( 15 );
		SetMarketValue( 5 );
		SetItemDescription(1690);
		SetIcon(210);
        } ]

        OnUse[ (s)
        {
		GetOwner().SetSpellEffect(1, 1600); //MysticMight
		GetOwner().PlaySound(87);
		DestroyObject(self);
        }]
}
