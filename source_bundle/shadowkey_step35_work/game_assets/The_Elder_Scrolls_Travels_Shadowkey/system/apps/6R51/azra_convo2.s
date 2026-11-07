{
	Init[()
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			AddStaticItem(3969);
			AddStaticItem(179);
			AddMenuItem(3970, "End1");
		}
		else
		{
			AddStaticItem(3726);
			AddStaticItem(179, false);
			AddMenuItem(182, "More1");
		}
	}]

	End1[()
	{
		ClearMenu();
		AddStaticItem(3971);
		AddStaticItem(179);
		AddMenuItem(3972, "End2");
	}]

	End2[()
	{
		ClearMenu();
		AddStaticItem(3973);
		AddStaticItem(179);
		AddMenuItem(182, "End3");
	}]

	End3[()
	{
		ClearMenu();
		AddStaticItem(3974);
		AddStaticItem(179);
		AddMenuItem(3975, "Quit");

		Azra2 = Level.GetEntity("azra2");
		Azra2.DestroyObjectMirror(Azra2);
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(3727);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(3728);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]

	More3[()
	{
		ClearMenu();
		AddStaticItem(3729);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]

	More4[()
	{
		ClearMenu();
		AddStaticItem(3730);
		AddStaticItem(179, false);
		AddMenuItem(3731, "More5");
	}]

	More5[()
	{
		ClearMenu();
		AddStaticItem(3732);
		AddStaticItem(179, false);
		AddMenuItem(3733, "Crypt1");
		AddMenuItem(3734, "Reward1");
	}]

	Crypt1[()
	{
		ClearMenu();
		AddStaticItem(3735);
		AddStaticItem(179, false);
		AddMenuItem(182, "Crypt2");
	}]

	Crypt2[()
	{
		ClearMenu();
		AddStaticItem(3736);
		AddStaticItem(179, false);
		AddMenuItem(182, "Crypt3");
	}]

	Crypt3[()
	{
		ClearMenu();
		AddStaticItem(3737);
		AddStaticItem(179, false);
		AddMenuItem(3739, "Stand1");
		AddMenuItem(386, "Reward1");
	}]

	Stand1[()
	{
		ClearMenu();
		AddStaticItem(3738);
		AddStaticItem(179, false);
		AddMenuItem(3740, "Stand2");
	}]

	Stand2[()
	{
		ClearMenu();
		AddStaticItem(3741);
		AddStaticItem(179, false);
		AddMenuItem(182, "Stand3");
	}]

	Stand3[()
	{
		ClearMenu();
		AddStaticItem(3742);
		AddStaticItem(179, false);
		AddMenuItem(3743, "Reward1");
	}]

	Reward1[()
	{
		ClearMenu();
		AddStaticItem(3744);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(24);
		GetPlayer().AddExperience(3400);
		Item = Level.CreateEntity(714);
		GetPlayer().PickupItem( Item );
		Azra = Level.GetEntity("azra");
		Azra.DestroyObjectMirror(Azra);
	}]
}