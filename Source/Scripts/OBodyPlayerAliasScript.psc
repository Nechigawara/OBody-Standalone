ScriptName OBodyPlayerAliasScript Extends ReferenceAlias

Event OnPlayerLoadGame()
	(GetOwningQuest() as OBodyScript).OnGameLoad()
EndEvent
