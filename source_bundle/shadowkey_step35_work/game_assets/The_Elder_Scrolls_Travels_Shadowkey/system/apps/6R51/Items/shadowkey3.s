{
	Init[()
	{
		SetName(3266);
		SetID("skey3");
		SetUsable(true);
		SetUseText(3266);
		SetIcon(218);
		SetItemDescription(3266);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}