ScriptName OBodyScript extends Quest

;import outils 

bool Property ORefitEnabled
	bool Function Get()
		Return (Game.GetFormFromFile(0x000802, "OBody.esp") as GlobalVariable).GetValueInt() == 1
	EndFunction
EndProperty

bool Property NippleRandEnabled
	bool Function Get()
		Return (Game.GetFormFromFile(0x000803, "OBody.esp") as GlobalVariable).GetValueInt() == 1
	EndFunction
EndProperty

bool Property GenitalRandEnabled
	bool Function Get()
		Return (Game.GetFormFromFile(0x000804, "OBody.esp") as GlobalVariable).GetValueInt() == 1
	EndFunction
EndProperty

int Property PresetKey
	int Function Get()
		Return (Game.GetFormFromFile(0x000805, "OBody.esp") as GlobalVariable).GetValueInt()
	EndFunction
EndProperty

int Property PresetKeyPrevious
	int Function Get()
		Return (Game.GetFormFromFile(0x000807, "OBody.esp") as GlobalVariable).GetValueInt()
	EndFunction
EndProperty

;obodyscript Function Get() Global
;	return (Game.GetFormFromFile(0x000805, "OBody.esp")) as OBodyScript
;EndFunction

Actor PlayerRef

Actor Property TargetOrPlayer
	Actor Function Get()
		Actor ret = Game.GetCurrentCrosshairRef() as Actor

		If !ret
			ret = PlayerRef
		EndIf

		Return ret
	EndFunction
EndProperty

Event OnInit()
	PlayerRef = Game.GetPlayer()
	Int femaleSize = OBodyNative.GetFemaleDatabaseSize()
	Int maleSize = OBodyNative.GetMaleDatabaseSize()
	Debug.Notification("OBody Standalone Installed: [F: " + femaleSize + "] [M: " + maleSize + "]")

	;OUtils.getOStim().RegisterForGameLoadEvent(self)
	;RegisterForOUpdate(self)

	OnLoad()
EndEvent

Function OnLoad()
	; Key unbind
	UnregisterForKey(PresetKeyPrevious)
	
	; Slip if null binding
	If PresetKey > 0 || PresetKey < 282
		; Register New Key
		RegisterForKey(PresetKey)
		
		; Update PresetKeyPrevious
		(Game.GetFormFromFile(0x000807, "OBody.esp") as GlobalVariable).SetValueInt(PresetKey)
	EndIf
	
	; Other Setup
	OBodyNative.SetORefit(ORefitEnabled)
	OBodyNative.SetNippleRand(NippleRandEnabled)
	OBodyNative.SetGenitalRand(GenitalRandEnabled)
	
EndFunction

int Function GetAPIVersion()
	return 2
endfunction 

Event OnGameLoad()
	OnLoad()
EndEvent

bool Function ObodyMenuOpen()
	return (Utility.IsInMenuMode() || UI.IsMenuOpen("console")) || UI.IsMenuOpen("Crafting Menu") || UI.IsMenuOpen("Dialogue Menu")
EndFunction

Event OnKeyDown(int KeyPress)
	If ObodyMenuOpen()
		Return
	EndIf

	if KeyPress == PresetKey
		ShowPresetMenu(TargetOrPlayer)
	endif
EndEvent

Function ObodyConsole(String In)
	MiscUtil.PrintConsole("Obody Standalone: " + In)
EndFunction

Function ShowPresetMenu(Actor act)
	Debug.Notification("Editing " + act.GetDisplayName())
	UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	listMenu.ResetMenu()

	string[] title = new String[1]
	title[0] = "-   OBody    -"

	string[] presets = OBodyNative.GetAllPossiblePresets(act)
	int l = presets.Length
	ObodyConsole((l) + " presets found")

	int pagesNeeded
	If l > 125
		pagesNeeded = (l / 125) + 1
		;ObodyConsole("Pages needed: " + pagesNeeded)

		int i = 0
		While i < pagesNeeded
			listMenu.AddEntryItem("OBody set " + (i + 1))
			i += 1
		EndWhile

		listMenu.OpenMenu(act)
		int num = listMenu.GetResultInt()
		If num < 0
			Return
		EndIf

		int startingPoint = num * 125
		int endPoint
		If num == (pagesNeeded - 1) ; last set
			endPoint = presets.Length - 1
		Else
			endPoint = startingPoint + 124
		EndIf

		listMenu.ResetMenu()
		presets = PapyrusUtil.SliceStringArray(presets, startingPoint, endPoint)
	EndIf

	presets = PapyrusUtil.MergeStringArray(title, presets)

	int i = 0
	int max = presets.length
	While (i < max)
		listMenu.AddEntryItem(presets[i])
		i += 1
	EndWhile

	listMenu.OpenMenu(act)
	string result = listMenu.GetResultString()

	int num = listMenu.GetResultInt()
	If !(num < 1)
		OBodyNative.ApplyPresetByName(act, result)
		ObodyConsole("Applying: " + result)

		int me = ModEvent.Create("obody_manualchange")
		ModEvent.PushForm(me, act)
		ModEvent.Send(me)
	EndIf
EndFunction
