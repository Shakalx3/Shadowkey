{
	Init[ ()
	{
		SetUseText(1903);
		SetName(1903);
		SetMagicResistance(0);
        	SetDeathAnimation(0);
        	SetDefense(0);
		SetArmorValue(0);
        	SetPassable(false);
        	SetImmobile(true);
        	SetWalkAnimation(0);
        	SetSwingAnimation(0);
        	StopAnimating(true);
                SetIdleAnimation(0);
		SetIsHitNoise(75);
		//PlayAnimationOffset(0);
		SetIsHitNoise(11);
		SetDeathNoise(75);
	}]

	OnDecay[ ()
	{
		Cr1 = Level.GetEntity("cr1");
		Cr2 = Level.GetEntity("cr2");
		Cr3 = Level.GetEntity("cr3");
		Cr4 = Level.GetEntity("cr4");
		Cr5 = Level.GetEntity("cr5");
		Cr6 = Level.GetEntity("cr6");
		Cr7 = Level.GetEntity("cr7");
		Cr8 = Level.GetEntity("cr8");
		Cr9 = Level.GetEntity("cr9");
		Cr10 = Level.GetEntity("cr10");
		Cr11 = Level.GetEntity("cr11");
		Cr12 = Level.GetEntity("cr12");
		Cr13 = Level.GetEntity("cr13");
		Cr14 = Level.GetEntity("cr14");
		Cr15 = Level.GetEntity("cr15");
		Cr16 = Level.GetEntity("cr16");
		Cr17 = Level.GetEntity("cr17");
		Cr18 = Level.GetEntity("cr18");
		Cr19 = Level.GetEntity("cr19");
		Cr20 = Level.GetEntity("cr20");
		Cr21 = Level.GetEntity("cr21");

		Ar1 = Level.GetEntity("ar1");
		Ar2 = Level.GetEntity("ar2");
		Ar3 = Level.GetEntity("ar3");
		Ar4 = Level.GetEntity("ar4");
		Ar5 = Level.GetEntity("ar5");
		Ar6 = Level.GetEntity("ar6");
		Ar7 = Level.GetEntity("ar7");
		Ar8 = Level.GetEntity("ar8");
		Ar9 = Level.GetEntity("ar9");
		Ar10 = Level.GetEntity("ar10");
		Ar11 = Level.GetEntity("ar11");
		Ar12 = Level.GetEntity("ar12");
		Ar13 = Level.GetEntity("ar13");
		Ar14 = Level.GetEntity("ar14");
		Ar15 = Level.GetEntity("ar15");
		Ar16 = Level.GetEntity("ar16");
		Ar17 = Level.GetEntity("ar17");
		Ar18 = Level.GetEntity("ar18");
		Ar19 = Level.GetEntity("ar19");

		if( Cr1 != null){Cr1.SetMob(1,-2);}
		if( Cr2 != null){Cr2.SetMob(1,-2);}
		if( Cr3 != null){Cr3.SetMob(1,-2);}
		if( Cr4 != null){Cr4.SetMob(1,-2);}
		if( Cr5 != null){Cr5.SetMob(1,-2);}
		if( Cr6 != null){Cr6.SetMob(1,-2);}
		if( Cr7 != null){Cr7.SetMob(1,-2);}
		if( Cr8 != null){Cr8.SetMob(1,-2);}
		if( Cr9 != null){Cr9.SetMob(1,-2);}
		if( Cr10 != null){Cr10.SetMob(1,-2);}
		if( Cr11 != null){Cr11.SetMob(1,-2);}
		if( Cr12 != null){Cr12.SetMob(1,-2);}
		if( Cr13 != null){Cr13.SetMob(1,-2);}
		if( Cr14 != null){Cr14.SetMob(1,-2);}
		if( Cr15 != null){Cr15.SetMob(1,-2);}
		if( Cr16 != null){Cr16.SetMob(1,-2);}
		if( Cr17 != null){Cr17.SetMob(1,-2);}
		if( Cr18 != null){Cr18.SetMob(1,-2);}
		if( Cr19 != null){Cr19.SetMob(1,-2);}
		if( Cr20 != null){Cr20.SetMob(1,-2);}
		if( Cr21 != null){Cr21.SetMob(1,-2);}

		if( Ar1 != null){Ar1.SetMob(4,-2);}
		if( Ar2 != null){Ar2.SetMob(4,-2);}
		if( Ar3 != null){Ar3.SetMob(4,-2);}
		if( Ar4 != null){Ar4.SetMob(4,-2);}
		if( Ar5 != null){Ar5.SetMob(4,-2);}
		if( Ar6 != null){Ar6.SetMob(4,-2);}
		if( Ar7 != null){Ar7.SetMob(4,-2);}
		if( Ar8 != null){Ar8.SetMob(4,-2);}
		if( Ar9 != null){Ar9.SetMob(4,-2);}
		if( Ar10 != null){Ar10.SetMob(4,-2);}
		if( Ar11 != null){Ar11.SetMob(4,-2);}
		if( Ar12 != null){Ar12.SetMob(4,-2);}
		if( Ar13 != null){Ar13.SetMob(4,-2);}
		if( Ar14 != null){Ar14.SetMob(4,-2);}
		if( Ar15 != null){Ar15.SetMob(4,-2);}
		if( Ar16 != null){Ar16.SetMob(4,-2);}
		if( Ar17 != null){Ar17.SetMob(4,-2);}
		if( Ar18 != null){Ar18.SetMob(4,-2);}
		if( Ar19 != null){Ar19.SetMob(4,-2);}

	}]
}