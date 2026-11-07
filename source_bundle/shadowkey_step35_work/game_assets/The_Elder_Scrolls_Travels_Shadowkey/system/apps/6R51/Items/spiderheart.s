{
        Init[ (s)
        {
                SetUseText(1734);
                SetUsable( true );
                SetName(1735);
                SetShortName(1736);
                SetID("spdhart");
                SetCost( 40 );
		SetMarketValue( 14 );
		SetItemDescription(1737);
		SetIcon(210);
        } ]

        OnUse[ (s)
        {
        	GetOwner().SetSpellEffect(5, 1600); //lethal strike
        	GetOwner().PlaySound(87);
        	DestroyObject(self);
        }]
}
