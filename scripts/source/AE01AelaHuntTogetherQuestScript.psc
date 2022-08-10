Scriptname AE01AelaHuntTogetherQuestScript extends Quest 

Quest Property AelaController auto
Quest Property PlayerWerewolfController auto
Actor Property PlayerRef auto
ReferenceAlias Property AelaRef auto

Function StartChain()
    Debug.Notification("Is running hunt together")
    RegisterForSingleUpdateGameTime(1.00000)
EndFunction

Event OnUpdateGameTime()
    (AelaController as AE01AelaController).PlayerShiftedToDefaultForm()
    Stop()
EndEvent
