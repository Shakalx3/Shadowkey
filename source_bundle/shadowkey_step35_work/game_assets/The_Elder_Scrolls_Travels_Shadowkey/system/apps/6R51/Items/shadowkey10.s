{
	Init[()
	{
		SetName(3263);
		SetID("skey10");
		SetUsable(true);
		SetUseText(3263);
		SetIcon(218);
		SetItemDescription(3263);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}