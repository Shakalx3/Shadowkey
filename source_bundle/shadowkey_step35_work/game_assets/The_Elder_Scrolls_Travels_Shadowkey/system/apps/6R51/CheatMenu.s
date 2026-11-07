{
	ghostItem

	Init[ (s)
	{
		MenuBackground(20);
		SetPrevMenu("MainMenu");
	} ]

	OnDisplay[ (s)
	{
		MenuBackground(20);
		ClearMenu();
		text2="Give 5000 Gold";
		AddStaticItem(518, false);
		AddMenuItem(text2, "Give5000Gold");
		AddMenuItem(520, "Give1KExp");
		AddMenuItem(3082, "VisitMerchant");
		AddMenuItem(524, "GoAzra");
		AddMenuItem(525, "GoDelf");
		AddMenuItem(526, "GoEarth");
		AddMenuItem(527, "GoGhast");
		AddMenuItem(182, "More");
		AddMenuItem(528,"Quit");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddMenuItem(529, "GoTwilite");
		AddMenuItem(530, "GoSnowline");
		AddMenuItem(540, "GoFear");
		AddMenuItem(3084, "FFArena");
		AddMenuItem(531, "GoDrgn");
		AddMenuItem(535, "GoRaiders");
		AddMenuItem(537, "GoWest");
		AddMenuItem(538, "GoEast");
		AddMenuItem(534, "GoLothna");
		AddMenuItem(532, "GoLakvan");
		AddMenuItem(182, "More2");
		AddMenuItem(528, "Quit");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddMenuItem(541, "GoBroken1");
		AddMenuItem(542, "GoBroken2");
		AddMenuItem(536, "GoStout");
		AddMenuItem(533, "GoGlacier");
		AddMenuItem(539, "GoCrypt1");
		AddMenuItem(544, "GoCrypt2");
		AddMenuItem(545, "GoCrypt3");
		AddMenuItem(3586, "GetStarTooth");
		AddMenuItem(547, "GetShadowKeys");
		AddMenuItem(182, "More3");
		AddMenuItem(528, "Quit");
	} ]

	More3[ (s)
	{
		ClearMenu();
		text="Teleport";
		bGhost = GetPlayer().IsGhost();
		if (bGhost = false)
		{
			ghostItem=AddMenuItem(2962, "MakeGhost");
		}
		else
		{
			ghostItem=AddMenuItem(2961, "MakeGhost");
		}
		if(GetPlayer().GetInvulnerable() = true)
		{
			AddMenuItem(3086, "InvulOff");
		}
		else
		{
			AddMenuItem(3085, "InvulOn");
		}
		AddMenuItem(3842, "LevelMe");
		AddMenuItem(3083, "ViewCoords");
		//AddMenuItem(text, "Teleport");
		AddMenuItem(528, "Quit");
	} ]

	LevelMe[ (s)
	{
		GetPlayer().LevelUp();
	} ]

	Teleport[ ()
	{
		ClearMenu();
		text="Locked - Delfran's";
		text2="Porliss -Snowline";
		text3="Umbra - Crypt 3";
		text4="Crypt 1 Doors";
		text5="Dstar_W Blk Mrkt";
		text6="Dstar_E Eranthos";
		text7="Assign Quests";
		text8="Fight Trainer";
		text9="Fort Crystal";
		text10="Dstar_W Mrkt";
		text11="More";
		AddMenuItem(3587, "GoTrothgar");
		AddMenuItem(text, "GoLockedDoor");
		AddMenuItem(text2, "GoPorliss");
		AddMenuItem(text3, "GoUmbra");
		AddMenuItem(text4, "GoCrypt1Doors");
		AddMenuItem(text5, "TeleDWest");
		AddMenuItem(text6, "TeleEast");
		AddMenuItem(text7, "AssignQuests");
		AddMenuItem(text8, "teleTrainer");
		AddMenuItem(text9, "teleCrystal");
		AddMenuItem(text10, "teleMarket");
		AddMenuItem(text11, "TeleportMo");
		AddMenuItem(528, "Quit");
	}]

	TeleportMo[ ()
	{
		ClearMenu();
		text1="Star Tooth";
		text2="Rogurin's Letter";
		text3="BW1 - Loot Skeleton";
		text4="Graves - drgnfld";
		AddMenuItem(text1, "teleStarTooth");
		AddMenuItem(text2, "teleRogLetter");
		AddMenuItem(text3, "teleBWSkel");
		AddMenuItem(text4, "teleGraves");
		AddMenuItem(528, "Quit");
	}]

	teleGraves[()
	{
		Quit();
		GetPlayer().SetPosition(7300,28761,-2317);
	}]

	teleBWSkel[()
	{
		Quit();
		GetPlayer().SetPosition(1920,12928,-2880);
	}]

	teleRogLetter[()
	{
		Quit();
		GetPlayer().SetPosition(9491,17526,0);
	}]

	teleStarTooth[ ()
	{
		Quit();
		GetPlayer().SetPosition(2944,17024,0);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
	}]

	teleMarket[ ()
	{
		Quit();
		GetPlayer().SetPosition(11392,10112,-2048);
	}]

	teleCrystal[ ()
	{
		Quit();
		GetPlayer().SetPosition(31872,30080,0);
	}]

	teleTrainer[ ()
	{
		Quit();
		GetPlayer().SetPosition(1697,1267,-2048);
	}]

	AssignQuests[ ()
	{
		Quit();
		GetPlayer().SetQuestAssigned(0);
		GetPlayer().SetQuestAssigned(1);
		GetPlayer().SetQuestAssigned(2);
		GetPlayer().SetQuestAssigned(3);
		GetPlayer().SetQuestAssigned(4);
	}]

	TeleDWest[ ()
	{
		Quit();
		GetPlayer().SetPosition(9088,31360,-2560);
	}]

	TeleEast[ ()
	{
		Quit();
		GetPlayer().SetPosition(21632,26240,-2048);
	}]

	GoCrypt1Doors[ ()
	{
		Quit();
		GetPlayer().SetPosition(5760,26240,0);
	}]

	GoUmbra[ ()
	{
		Quit();
		GetPlayer().SetPosition(29056,17792,1024);
	}]

	GoTrothgar[ ()
	{
		AzraDone();
		GetPlayer().SetPosition(28790,6528,-2816);
	}]

	GoLockedDoor[ ()
	{
		GetPlayer().SetPosition(14720,9088,384);
	}]

	GoPorliss[ ()
	{
		Quit();
		GetPlayer().SetPosition(13696,23680,-2944);
	}]

	ViewCoords[ ()
	{
		Quit();
		GetPlayer().EnableCoords();
	}]

	VisitMerchant[ ()
	{
		ClearMenu();
		AddMenuItem(1128, "ArmorStore");
		AddMenuItem(3087, "ShieldsStore");
		AddMenuItem(3088, "ItemsStore");
		AddMenuItem(1236, "WeaponsStore");
		AddMenuItem(3089, "SpellsStore");
		AddMenuItem(528, "Quit");
	}]

	ArmorStore[ ()
	{
		GetPlayer().VisitStore(6); //ENTITY_CLASS_ARMOR
	}]

	ShieldsStore[ ()
	{
		GetPlayer().VisitStore(15); //ENTITY_CLASS_SHIELDS
	}]

	ItemsStore[ ()
	{
		GetPlayer().VisitStore(9); //ENTITY_CLASS_CONSUMABLE
	}]

	WeaponsStore[ ()
	{
		GetPlayer().VisitStore(4); //ENTITY_CLASS_WEAPON
	}]

	SpellsStore[ ()
	{
		GetPlayer().VisitStore(5); //ENTITY_CLASS_SPELL
	}]

	MakeGhost[ ()
	{
		specter = GetPlayer().IsGhost();
		if (specter = false)
		{
			GetPlayer().SetGhost(true);
			ghostItem.SetLocalizedText(2961);
		}
		else
		{
			GetPlayer().SetGhost(false);
			ghostItem.SetLocalizedText(2962);
		}
	}]

	FFArena[ (s)
	{
		Quit();
		Level.LoadLevel("ffarena");
	} ]

	GoBroken1[ (s)
	{
		Quit();
		Level.LoadLevel("broken1");

	} ]

	GoBroken2[ (s)
	{
		Quit();
		Level.LoadLevel("broken2");
	} ]

	GoRdNest[ (s)
	{
		Quit();
		Level.LoadLevel("raidnest");
	} ]

	GetShadowKeys[ (s)
	{
		Quit();
		GetPlayer().GiveItem(908);
		GetPlayer().GiveItem(909);
		GetPlayer().GiveItem(910);
		GetPlayer().GiveItem(911);
		GetPlayer().GiveItem(912);
		GetPlayer().GiveItem(913);
		GetPlayer().GiveItem(914);
		GetPlayer().GiveItem(915);
		GetPlayer().GiveItem(916);
		GetPlayer().GiveItem(917);
		GetPlayer().GiveItem(918);
	} ]

	GetShadowKey2[ (s)
	{
		Quit();
		GetPlayer().GiveItem(909);
	} ]

	GetStarTooth[ (s)
	{
		Quit();
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
		GetPlayer().GiveItem(714);
	} ]

	InvulOn[()
	{
		GetPlayer().SetInvulnerable(true);
		Quit();
	}]

	InvulOff[()
	{
		GetPlayer().SetInvulnerable(false);
		Quit();
	}]

	AzraDone[ (s)
	{
		Quit();
		GetPlayer().StatModGold(45000);
		GetPlayer().SetQuestCompleted(0);
		GetPlayer().GiveItem(4024); //ignite foe spell
		GetPlayer().GiveItem(4006); //super blaze spell
	} ]

	GoFear[ (s)
	{
		Quit();
		Level.LoadLevel("fearfrst");
	} ]

	GoCrypt1[ (s)
	{
		Quit();
		Level.LoadLevel("crypt1");
	} ]

	GoCrypt2[ (s)
	{
		Quit();
		Level.LoadLevel("crypt2");
	} ]

	GoCrypt3[ (s)
	{
		Quit();
		Level.LoadLevel("crypt3");
	} ]

	GoStout[ (s)
	{
		Quit();
		Level.LoadLevel("stouttp");
	} ]

	GoWest[ (s)
	{
		Quit();
		Level.LoadLevel("dstar_w");
	} ]

	GoEast[ (s)
	{
		Quit();
		Level.LoadLevel("dstar_e");
	} ]

	GoRaiders[ (s)
	{
		Quit();
		Level.LoadLevel("raiders");
	} ]

	GoLothna[ (s)
	{
		Quit();
		Level.LoadLevel("LothCav");
	} ]

	GoGlacier[ (s)
	{
		Quit();
		Level.LoadLevel("GlacierCrawl");
	} ]

	GoSnowline[ (s)
	{
		Quit();
		Level.LoadLevel("snowline");
	} ]

	GoDrgn[ (s)
	{
		Quit();
		Level.LoadLevel("drgnfld");
	} ]

	GoLakvan[ (s)
	{
		Quit();
		Level.LoadLevel("lakvan");
	} ]

	Give5000Gold[ (s)
	{
		GetPlayer().SetGold( GetPlayer().GetGold() + 5000 );
	} ]

	Give1KExp[ (s)
	{
		GetPlayer().AddExperience( 1000 );
	} ]

	GiveSword[ (s)
	{
		Item = Level.CreateEntity( 505 );
		GetPlayer().EquipItem( 0, Item );
		Quit();
	} ]

	GoAzra[ (s)
	{
		Quit();
		Level.LoadLevel("azra");
	} ]

	GoDelf[ (s)
	{
		Quit();
		Level.LoadLevel("delfhide");

	} ]

	GoEarth[ (s)
	{
		Quit();
		Level.LoadLevel("erthcave");
	} ]

	GoGhast[ (s)
	{
		Quit();
		Level.LoadLevel("GhstPass");
	} ]

	GoTwilite[ (s)
	{
		Quit();
		Level.LoadLevel("twilite");
	} ]


	GiveBlaze[ (s)
	{
		GetPlayer().SetLevel( 50 );
		GetPlayer().SetMaxMagicka( 5000 );
		GetPlayer().SetMagicka( 5000 );
		Item = Level.CreateEntity( 4006 );
		GetPlayer().EquipItem( 0, Item );
		Quit();
	} ]

	GiveHealWound[ (s)
	{
		Item = Level.CreateEntity( 4031 );
		GetPlayer().EquipItem( 0, Item );
		Quit();
	} ]

	CheatMenuBack[ ()
	{
		OpenMenu("MainMenu");
	}]
}
