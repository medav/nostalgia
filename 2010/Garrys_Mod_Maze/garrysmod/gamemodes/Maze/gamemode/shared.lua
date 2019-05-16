GM.Name 	= "Maze" --Set the gamemode name
GM.Author 	= "Thor" --Set the author name
	
team.SetUp(1, "Lab Rats", Color (64, 64, 200, 255))

gmm_perks={}

gmm_perks["compass"]={
	storename="Compass",
	cost=5000,
	desc="A compass to keep you on the right track."
}
gmm_perks["pdistance"]={
	storename="Distance Indicator",
	cost=1000,
	desc="A distance indicator for your HUD."
}
gmm_perks["super-speed"]={
	storename="Super Speed",
	cost=2000,
	desc="RUN RUN AS FAST AS YOU CAN!!1"
}
gmm_perks["prediction"]={
	storename="Maze Prediction",
	cost=2000,
	desc="Lets you see whats comming, ahead of time."
}
gmm_perks["map"]={
	storename="Maze Map",
	cost=10000,
	desc="The ultimate perk. Requires the compass to work."
}

gmm_protection={}

gmm_protection["gs_pusher"]={
	storename="Pushing protection",
	desc="Protects you from those nasty melons that push you around.",
	cost=2000
}

gmm_protection["gs_teleport"]={
	storename="Teleport protection.",
	desc="Keeps you from teleporting.",
	cost=1000
}

gmm_protection["gs_bomb"]={
	storename="Explosion protection.",
	desc="Keeps you from being killed by bombs.",
	cost=3000
}

gmm_protection["gs_reorient"]={
	storename="Reorientation.",
	desc="Gets your compass back on track, once touched by a melon.",
	cost=3000
}

