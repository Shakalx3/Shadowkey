{
	Init[ (s)
	{
		UpdateMenu();
	}]

	LootExit[ (s)
	{
		if( (GetOpener().GetFirst() = null) and (GetOpener().GetDestroy()) )
		{
			QuitAndDestroyOpener();
		}
		else
		{
			Quit();
		}
	}]

	SelectItem[ (s)
	{
		MenuItem = GetSelectedItem();
		Object = MenuItem.GetAssociatedObject();
		GetPlayer().PickupItem( Object );
		GetOpener().RemoveObject( Object );
		UpdateMenu();
		Level.saved_TheifTrap = 1;
		return;
	}]

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

			AddMenuItem(Item.GetName(),"SelectItem",Item);
			Item = Opener.GetNext();
		}

		AddMenuItem(528,"LootExit");
	}]
}