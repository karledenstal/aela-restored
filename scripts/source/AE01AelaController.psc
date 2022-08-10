Scriptname AE01AelaController extends Quest
{ Script that controls everything that will happen }

; Functionality
; Turn Aela to werewolf on command
; - Make her leave combat
; - Set her to invulnerable during transform
; - Cast Beast form spell on Aela
; - Set IsInWereForm global variable to 1
; Turn Aela back to human on command
; - Set her as invulnerable
; - Set her race to original race
; - Evaluate package
; - Set IsInWereForm global variable to 0
; Turn Aela to werewolf when player is werewolf
; - Trigger AwakenBeast function when player transforms
; Turn Aela back to human when player turns back to human
; - Trigger SleepLittleBeast when player transform to human

Actor Property PlayerRef auto

Faction Property WerewolfFaction auto
Spell Property WerewolfChangeSpell auto
Idle Property WerewolfTransformBack auto
Race Property WerewolfRace auto

ReferenceAlias Property FollowerAlias auto

Race Property AelaRace auto

bool WerewolfFormAvailable = true
bool property ShouldShiftBack = false auto

GlobalVariable Property IsInWereForm auto

Function AwakenBeast(ObjectReference FollowerRef)
    Actor FollowerActor = FollowerRef as Actor
    
    if (WerewolfFormAvailable && IsInWereForm.GetValueInt() < 1)
        FollowerActor.StopCombat()
        FollowerActor.GetActorBase().SetInvulnerable(true)

        WerewolfChangeSpell.Cast(FollowerRef, none)

        FollowerActor.GetActorBase().SetInvulnerable(false)

        IsInWereForm.SetValue(1)
        WerewolfFormAvailable = false
    endif
EndFunction

Function SleepLittleBeast(ObjectReference FollowerRef)
    Actor FollowerActor = FollowerRef as Actor

    if (isInWereForm)
        FollowerActor.GetActorBase().SetInvulnerable(true)

        ; Revert form
        ; Really ugly, but works
        FollowerActor.SetRace(AelaRace)
        FollowerActor.GetActorBase().SetInvulnerable(false)

        IsInWereForm.SetValue(0)
        FollowerActor.EvaluatePackage()
    endif
EndFunction

Function PlayerShiftedToDefaultForm()
    if IsInWereForm.GetValueInt() < 1 && PlayerRef.GetRace() != WerewolfRace
        Actor FollowerActor = FollowerAlias.GetActorRef()
        SleepLittleBeast(FollowerActor)
    endif
EndFunction