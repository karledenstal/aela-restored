Scriptname AE01PlayerAliasScript extends ReferenceAlias 

Race Property WerewolfRace auto
Quest Property AelaController auto
Actor Property PlayerRef auto

Event OnInit()
    Debug.Notification("Can something happen pls?")
    RegisterForSingleUpdate(5 as float)
EndEvent

Event OnUpdate()
    Debug.Notification("On Update, checks if player is werewolf")
    if PlayerRef.GetRace() != WerewolfRace
        Debug.Notification("Player not in werewolf form")
        (AelaController as AE01AelaController).PlayerShiftedToDefaultForm()
        RegisterForAnimationEvent(PlayerRef as objectreference, "SetRace")
    else
        RegisterForSingleUpdate(5 as float)
    endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    Debug.Notification("Animation event " + asEventName)
    if (akSource == PlayerRef as objectreference && asEventName == "SetRace")
        Utility.Wait(5 as float)

        if (PlayerRef.GetRace() == WerewolfRace)
            Debug.Notification("Player in werewolf form")
            (AelaController as AE01AelaController).PlayerShiftedIntoWerewolf()
            RegisterForSingleUpdate(5 as float)
        endif
    endif
EndEvent