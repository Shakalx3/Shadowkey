{
	Init[ (s)
	{
		UpdateMenu();
	} ]

	LootExit[ (s)
	{
		if( (GetOpener().GetFirst() = null) and (GetOpener().GetDestroy()) )
		{
			QuitAndDestroyOpener();
			//Quit();
		}
		else
		{
			Quit();
		}
	} ]

	SelectItem[ (s)
	{
		MenuItem = GetSelectedItem();
		Object = MenuItem.GetAssociatedObject();

		GetPlayer().PickupItem( Object );
		GetOpener().RemoveObject( Object );

		UpdateMenu();
		return;
	} ]

	UpdateMenu[ (s)
	{
		ClearMenu();

		Opener = GetOpener();

		if(Opener.GetFirst() = null)
		{
			Opener.SetUsable(false);
			LootExit();
			return;
		}
		else
		{
			AddStaticItem( Opener.GetName()#" "#"Select Item to pick up", false);
			AddStaticItem( 714 );
		}

		Item = Opener.GetFirst();
		while( Item != null )
		{
			//if( Item.GetQuantity() != 1 )
			//{
			//	AddMenuItem( Item.GetQuantity() # " " # Item.GetName(),"SelectItem",Item);
			//}
			//else
			//{
				AddMenuItem(Item.GetName(),"SelectItem",Item);
			//}
			Item = Opener.GetNext();
		}

		AddMenuItem(528,"LootExit");
	} ]
}