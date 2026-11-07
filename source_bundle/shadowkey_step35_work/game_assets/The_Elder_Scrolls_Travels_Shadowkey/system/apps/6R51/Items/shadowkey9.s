{
	Init[()
	{
		SetName(3273);
		SetID("skey9");
		SetUsable(true);
		SetUseText(3273);
		SetIcon(218);
		SetItemDescription(3273);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}