{
	Init[()
	{
		AddStaticItem(3672);
		AddStaticItem(179, false);
		if(Level.GetEntity("box2").saved_Gate = 0)
		{
			key = GetPlayer().FindInventory("frozen_key");
			if(key != null)
			{
				AddMenuItem(3955, "Open1");
			}
		}
		else
		{
			AddMenuItem(3956, "Open2");
		}
		AddMenuItem(386, "Quit");
	}]

	Open1[()
	{
		Level.GetEntity("box2").OnReallyUsed1();
		Level.GetEntity("box2").MirrorMethod("OnReallyUsed1");
	}]

	Open2[()
	{
		Level.GetEntity("box2").OnReallyUsed2();
		Level.GetEntity("box2").MirrorMethod("OnReallyUsed2");
	}]
}