{
	Init[()
	{
		if(Level.GetEntity("nym").saved_Talked = 0)
		{
			AddStaticItem(1561);
			AddStaticItem(179, false);
			AddMenuItem(1562, "Waiting");
			AddMenuItem(1563, "Doubt");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3259);
			AddStaticItem(179, false);
			AddMenuItem(1579, "Quit");
		}
	}]

	Waiting[()
	{
		ClearMenu();
		AddStaticItem(1564);
		AddStaticItem(179, false);
		AddMenuItem(1565, "ShadowkeyCheck");
		AddMenuItem(1566, "ShadowkeyCheck");
	}]
	Doubt[()
	{
		ClearMenu();
		AddStaticItem(1567);
		AddStaticItem(179, false);
		AddMenuItem(1565, "ShadowkeyCheck");
		AddMenuItem(1568, "ShadowkeyCheck");
	}]
	ShadowkeyCheck[()
	{
		ClearMenu();
        	if(GetPlayer().HasItem("skey1") = true and
            	GetPlayer().HasItem("skey2") = true and
            	GetPlayer().HasItem("skey3") = true and
            	GetPlayer().HasItem("skey4") = true and
            	GetPlayer().HasItem("skey5") = true and
            	GetPlayer().HasItem("skey6") = true and
            	GetPlayer().HasItem("skey7") = true and
            	GetPlayer().HasItem("skey8") = true and
            	GetPlayer().HasItem("skey9") = true and
        	GetPlayer().HasItem("skey10") = true and
        	GetPlayer().HasItem("skey11") = true)
        	{
        		AddStaticItem(1569);
        		AddStaticItem(179, false);
        		AddMenuItem(182, "More1");
		}
        	else
		{
                	AddStaticItem(1570);
                	AddStaticItem(179, false);
                	AddMenuItem(386, "StarTooth");
        	}
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(1571);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(1572);
		AddStaticItem(179, false);
		AddMenuItem(386, "StarTooth");
		Item = Level.CreateEntity( 672 );
		GetPlayer().PickupItem(Item);
	}]
	StarTooth[()
	{
		ClearMenu();
		AddStaticItem(1573);
		AddStaticItem(179, false);
		if(GetPlayer().CountInventory("stooth") = 7)
		{
			AddMenuItem(1574, "More3");
		}
		else
		{
			AddMenuItem(1575, "More3");
		}
	}]
	More3[()
	{
		ClearMenu();
		AddStaticItem(1576);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]
	More4[()
	{
		ClearMenu();
		AddStaticItem(1577);
		AddStaticItem(179, false);
		AddMenuItem(182, "More5");
	}]
	More5[()
	{
		ClearMenu();
		AddStaticItem(1578);
		AddStaticItem(179, false);
		AddMenuItem(1579, "Quit");
		Level.GetEntity("nym").saved_Talked = 1;
	}]
}