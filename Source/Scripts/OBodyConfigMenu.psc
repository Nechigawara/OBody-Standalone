Scriptname OBodyConfigMenu extends MCM_ConfigBase  

OBodyScript property OBodyQuest auto

Event OnConfigInit()
	(Game.GetFormFromFile(0x000802, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt("bORefitEnable:OBodyStandalone"))
	(Game.GetFormFromFile(0x000803, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt("bNippleEnable:OBodyStandalone"))
	(Game.GetFormFromFile(0x000804, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt("bGenitalEnable:OBodyStandalone"))
	(Game.GetFormFromFile(0x000805, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt("iPresetKey:OBodyStandalone"))
	OBodyQuest.OnLoad()
EndEvent

Event OnSettingChange(string a_ID)
	if a_ID == "bORefitEnable:OBodyStandalone"
		(Game.GetFormFromFile(0x000802, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt(a_ID))
		OBodyQuest.OnLoad()
    elseif a_ID == "bNippleEnable:OBodyStandalone"
		(Game.GetFormFromFile(0x000803, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt(a_ID))
		OBodyQuest.OnLoad()
	elseif a_ID == "bGenitalEnable:OBodyStandalone"
		(Game.GetFormFromFile(0x000804, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt(a_ID))
		OBodyQuest.OnLoad()
	elseif a_ID == "iPresetKey:OBodyStandalone"
        (Game.GetFormFromFile(0x000805, "OBody.esp") as GlobalVariable).SetValueInt(GetModSettingInt(a_ID))
		OBodyQuest.OnLoad()
    endif
EndEvent