{
	Init[()
	{
		SetName(3268);
		SetID("skey5");
		SetUsable(true);
		SetUseText(3268);
		SetIcon(218);
		SetItemDescription(3268);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}