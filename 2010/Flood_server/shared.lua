DeriveGamemode("sandbox")

Owner = 0
Gold = 2
Normal = 3
Dead = 11
Vip = 5

LoneWolves =1
Gophers =2
Flounders =3
Pirates =4
SeaTurtles =5
Pelicans =6
Ducks =7
Penguins =8
SeaHorses =9
Otters =10

team.SetUp (LoneWolves, "Lone Wolves", Color(138,43,226,255))
team.SetUp (Gophers, "Gophers", Color(205,127,50,255))
team.SetUp (Flounders, "Flounders", Color(34,139,34,255))
team.SetUp (Pirates, "Pirates", Color(64,64,64,255))
team.SetUp (SeaTurtles, "Sea Sturtles", Color(255,36,0,255))
team.SetUp (Pelicans, "Pelicans", Color(35,107,142,255))
team.SetUp (Ducks, "Ducks", Color(205,155,29,255))
team.SetUp (Penguins, "Penguins", Color(0,0,156,255))
team.SetUp (SeaHorses, "Sea Horses", Color(127,0,255,255))
team.SetUp (Otters, "Otters", Color(107,66,38,255))
team.SetUp (Dead, "Dead", Color(133,99,99,255))
/*---------------------------------------------------------
  Relevant information
---------------------------------------------------------*/

GM.Name 	= "[iG]Flood"
GM.Author 	= "By Squeakers and Thor Specially for Ingenious Gaming"
GM.Email 	= ""
GM.Website 	= ""

fm_weapons={}

fm_weapons["weapon_pistol"]={
	name="Pistol",
	cost=0,
	damage=2,
	tip="Name: Pistol\nCost: $0\nDamage: 2\nAmmo: Infinite\nInfo: It all starts here.",
	mdl="models/weapons/W_pistol.mdl",
	ammo="Pistol",
	amt=9999,
	class="Pistols"
}

fm_weapons["weapon_crossbow"]={
	name="Scoped Crossbow",
	cost=4000,
	damage=10,
	tip="Name: Scoped CrossBow\nCost: $4000\nDamage: 10\nAmmo: Infinite\nInfo: Accurate but slow.",
	mdl="models/weapons/W_crossbow.mdl",
	ammo="XBowBolt",
	amt=9999,
	class="Misc"
}

fm_weapons["weapon_deagle"]={
	name="Desart Eagle",
	cost=1000,
	damage=5,
	tip="Name: Deagle\nCost: $1000\nDamage: 5\nAmmo: Infinite .50 cal\nInfo: Fast, but has a kick.",
	mdl="models/weapons/w_crowbar.mdl",
	ammo="Pistol",
	amt==9999,
	class="Pistols"
}

fm_weapons["weapon_357"]={
	name=".357 Magnum",
	cost=1500,
	damage=7,
	tip="Name: Magnum\nCost: $1500\nDamage: 7\nAmmo: Infinite .357 Mag\nInfo: good accuracy, kinda slow.",
	mdl="models/weapons/W_357.mdl",
	ammo="Pistol",
	amt==9999,
	class="Pistols"
}

fm_weapons["weapon_smg1"]={
	name="MP7",
	cost=10000,
	damage=4,
	tip="Name: MP7\nCost: $10000\nDamage: 4\nAmmo: 350 4.6mm\nInfo: Fast, inaccurate",
	mdl="models/weapons/w_smg1.mdl",
	ammo="weapon_smg1",
	amt==350,
	class="SMG"
}

fm_weapons["weapon_tmp"]={
	name="TMP",
	cost=7500,
	damage=3,
	tip="Name: Tmp\nCost: $7500\nDamage: 3\nAmmo: 180 9x19mm\nInfo: Small fast and hard hitting.",
	mdl="models/weapons/w_smg_tmp.mdl",
	ammo="helicoptergun",
	amt==180,
	class="SMG"
}

fm_weapons["weapon_mp5"]={
	name="HK MP5",
	cost=15000,
	damage=9,
	tip="Name: H&K MP5\nCost: $15000\nDamage: 9\nAmmo: 500 9x19mm\nInfo: low accuracy medium speed",
	mdl="models/weapons/w_smg_tmp.mdl",
	ammo="helicoptergun",
	amt==500,
	class="SMG"
}

fm_weapons["weapon_shotgun"]={
	name="Spas 12",
	cost=14000,
	damage=20,
	tip="Name: SPAS 12\nCost: $14000\nDamage: 20 single 40 double\nAmmo: 50 12-Gauge\nInfo: Deadly Close inaccurate far",
	mdl="models/weapons/w_shotgun.mdl",
	ammo="Buckshot",
	amt==50,
	class="Shotguns"
}

fm_weapons["weapon_ak47"]={
	name="Klashnikov AK-47",
	cost=10000,
	damage=9,
	tip="Name: AK-47\nCost: $11000\nDamage: 9\nAmmo: 200 7.62mm\nInfo: high speed, semi accurate",
	mdl="models/weapons/w_rif_ak47.mdl",
	ammo="striderminigun",
	amt==200,
	class="Assault Rifles"
}

fm_weapons["weapon_m4"]={
	name="Maverick M4",
	cost=11000,
	damage=8,
	tip="Name: M4A1 Assault Rifle\nCost: $11000\nDamage: 8\nAmmo: 400 5.56mm\nInfo: SemiAccurate medium speed",
	mdl="models/weapons/w_rif_m4a1.mdl",
	ammo="airboatgun",
	amt==400,
	class="Assault Rifles"
}

fm_weapons["weapon_para"]={
	name="M249 Saw",
	cost=25000,
	damage=11,
	tip="Name: M249\nCost: $25000\nDamage: 11\nAmmo: 200 5.56mm\nInfo: Rip them to shreds Rambo syle!",
	mdl="models/weapons/w_mach_m249para.mdl",
	ammo="airboatgun",
	amt==200,
	class="Assault Rifles"
}

fm_weapons["weapon_frag"]={
	name="Grenade",
	cost=5000,
	damage=120,
	tip="Name: High Explosive Grenade\nCost: $5000\nDamage: 120 + .5/sec fire\nAmmo: 2 Grenades\nInfo: hard to land on boat, does splash damage lights on fire",
	mdl="models/weapons/w_grenade.mdl",
	ammo="grenade",
	amt==2,
	class="Explosive"
}

fm_weapons["weapon_rpg"]={
	name="Raaaocket laaauuuunnchhhaaaa!",
	cost=7500,
	damage=100,
	tip="Name: Rocket Launcher\nCost: $7500\nDamage: 0-100 + .5/sec fire, multiple props\nAmmo: 3 Rockets\nInfo: Splash damage and lights on fire.",
	mdl="models/w_rpg.mdl",
	ammo="weapon_rpg",
	amt==3,
	class="Explosive"
}

fm_weapons["weapon_glock"]={
	name="Glock",
	cost=2000,
	damage=5,
	tip="Name: Glock 18 \nCost: $2000\nDamage: 5\nAmmo: Infinite\nInfo: Good Starter Pistol, fair rate of fire.",
	mdl="models/weapons/w_pist_glock18.mdl",
	ammo="Pistole",
	amt==9999,
	class="Pistols"
}

fm_weapons["weapon_mac10"]={
	name="MAC 10",
	cost=8000,
	damage=6,
	tip="Name: MAC 10 \nCost: $8000\nDamage: 6\nAmmo: 250 9x19mm\nInfo: High power, medium fire rate.",
	mdl="models/weapons/w_smg_mac10.mdl",
	ammo="airboatgun",
	amt==250,
	class="SMG"
}

fm_weapons["weapon_stunstick"]={
	name="Prop Healer",
	cost=10000,
	damage=-1,
	tip="Name: Prop Healer \nCost: $10000\nDamage: -1\nAmmo: Much as you can swing it\nInfo: Heal those props maggot!",
	mdl="models/weapons/w_stunbaton.mdl",
	ammo="",
	amt==9999,
	class="Misc"
}

fm_weapons["lee_cs_pumpshotgun"]={
	name="M3 Shotgun",
	cost=6000,
	damage=12,
	tip="Name: M3 Shotgun \nCost: $6000\nDamage: 12\nAmmo: 50 12-Gauge\nInfo: Single Shot Pump, Slow firing",
	mdl="models/weapons/w_shot_m3super90.mdl",
	ammo="buckshot",
	amt==50,
	class="Shotguns"
}

fm_weapons["lee_cs_awp"]={
	name="L96 AWP Sniper Rifle",
	cost=35000,
	damage=40,
	tip="Name: L96 AWP Sniper Rifle \nCost: $35000\nDamage: 40\nAmmo: 40 Magnum\nInfo: Pick off small targets with this beast!",
	mdl="models/weapons/w_snip_awp.mdl",
	ammo="combinecannon",
	amt==40,
	class="Rifles"
}

fm_weapons["lee_cs_p90"]={
	name="P90 SMG",
	cost=15000,
	damage=8,
	tip="Name: P90 SMG \nCost: $15000\nDamage: 8\nAmmo: 500 4.6mm\nInfo: High ammo, fast fire rate, low accuracy",
	mdl="models/weapons/w_smg_p90.mdl",
	ammo="smg1",
	amt==500,
	class="SMG"
}

fm_weapons["lee_cs_galil"]={
	name="Galil",
	cost=12000,
	damage=10,
	tip="Name: Galil \nCost: $12000\nDamage: 10\nAmmo: 300 7.62mm\nInfo: High ammo, fast fire rate, low accuracy",
	mdl="models/weapons/w_rif_galil.mdl",
	ammo="striderminigun",
	amt==300,
	class="Assults Rifles"
}

fm_weapons["lee_cs_autoshotgun"]={
	name="Autoshotgun",
	cost=10000,
	damage=18,
	tip="Name: Autoshotgun \nCost: $10000\nDamage: 18\nAmmo: 100 12-Gauge\nInfo: Semi auto, good fire rate",
	mdl="models/weapons/w_shot_xm1014.mdl",
	ammo="buckshot",
	amt==100,
	class="Shotguns"
}

fm_weapons["lee_cs_g3sg1"]={
	name="G3 SG1",
	cost=22000,
	damage=18,
	tip="Name: G3 SG1 \nCost: $22000\nDamage: 18\nAmmo: 100 .308\nInfo: Auto sniper, high damage",
	mdl="models/weapons/w_snip_g3sg1.mdl",
	ammo="sniperround",
	amt==100,
	class="Rifles"
}

fm_weapons["lee_cs_scout"]={
	name="Scout",
	cost=5000,
	damage=8,
	tip="Name: Scout \nCost: $5000\nDamage: 8\nAmmo: 400 .223\nInfo: Good Starter rifle, medium damage Bolt",
	mdl="models/weapons/w_snip_scout.mdl",
	ammo="alyxgun",
	amt==400,
	class="Rifles"
}
fm_weapons["lee_cs_aug"]={
	name="Aug",
	cost=7000,
	damage=5,
	tip="Name: Steyr AUG \nCost: $7000\nDamage: 5\nAmmo: 200 5.56mm\nInfo: Good Starter Assault rifle, Automatic, zoom",
	mdl="models/weapons/w_rif_aug.mdl",
	ammo="airboatgun",
	amt==200,
	class="Assault Rifles"
}
fm_weapons["weapon_physcannon"]={
	name="Gravity Gun",
	cost=5000,
	damage=5,
	tip="Name: Gravity Gun \nCost: $5000\nDamage: 0-moves ones props\nAmmo: Unlimited energy!\nInfo: Think of it as a high-power crowbar",
	mdl="models/weapons/w_physics.mdl",
	ammo="",
	amt==9999,
	class="Misc"
}