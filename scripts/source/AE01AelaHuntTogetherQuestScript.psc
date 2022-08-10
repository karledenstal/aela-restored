Scriptname AE01AelaHuntTogetherQuestScript extends Quest 

Quest Property AelaController auto
Quest Property PlayerWerewolfController auto
Actor Property PlayerRef auto
ReferenceAlias Property AelaRef auto

Function OnUpdateGameTime()
    (AelaController as AE01AelaController).PlayerShiftedToDefaultForm()
    Self.Stop()
EndFunction

Event OnInit()
    if Self.isRunning()
        Self.RegisterForSingleUpdateGameTime(1.00000)
    endif
EndEvent
