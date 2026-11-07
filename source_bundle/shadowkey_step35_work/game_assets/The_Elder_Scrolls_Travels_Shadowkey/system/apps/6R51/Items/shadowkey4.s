{
	Init[()
	{
		SetName(3267);
		SetID("skey4");
		SetUsable(true);
		SetUseText(3267);
		SetIcon(218);
		SetItemDescription(3267);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}