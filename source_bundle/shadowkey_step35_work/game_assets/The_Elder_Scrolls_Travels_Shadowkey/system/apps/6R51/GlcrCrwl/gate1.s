{
	Init[()
	{
		Level.Log("Gate1 init");
		AddStaticItem(3671);
		AddStaticItem(179, false);
		Level.Log("Running Frozen Key check");
		Gate = Level.GetEntity("box1");
		if( Gate.saved_Gate = 0 )
		{
			key = GetPlayer().FindInventory("frozen_key");
			if(key != null)
			{
				Level.Log("Key found in Player's inventory, option to use key given");
				AddMenuItem(3955, "Open1");
			}
		}
		else
		{
			Level.Log("Key is used on control panel, Player has option to remove key");
			AddMenuItem(3956, "Open2");
		}
		Level.Log("Player has option to leave menu");
		AddMenuItem(386, "Quit");
	}]

	Open1[()
	{
		Level.Log("Player has decided to use key, deleting key from inventory");
		Level.GetEntity("box1").OnReallyUsed1();
		Level.GetEntity("box1").MirrorMethod("OnReallyUsed1");
	}]

	Open2[()
	{
		Level.Log("Player has decided to retrieve key, adding key to inventory");
		Level.GetEntity("box1").OnReallyUsed2();
		Level.GetEntity("box1").MirrorMethod("OnReallyUsed2");
	}]
}