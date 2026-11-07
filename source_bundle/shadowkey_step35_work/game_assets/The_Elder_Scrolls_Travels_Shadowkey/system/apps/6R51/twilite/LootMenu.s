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
			AddStaticItem(2695);
			AddStaticItem(179, false);
		}
		else
		{
			//AddStaticItem(456);
			AddStaticItem( Opener.GetName() );
			AddStaticItem( 2696 );
			AddStaticItem(179, false);
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