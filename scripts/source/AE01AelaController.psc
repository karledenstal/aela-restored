Scriptname AE01AelaController extends Quest
{ Script that controls everything that will happen }

Actor Property PlayerRef auto

Race Property WerewolfRace auto

Faction Property WerewolfFaction auto
Spell Property WerewolfChangeSpell auto
Idle Property WerewolfTransformBack auto

ReferenceAlias Property FollowerAlias auto

Race Property AelaRace auto
Quest Property HuntTogether auto

bool WerewolfFormAvailable = true
bool Property ShouldShiftBack = false auto

GlobalVariable Property IsInWereForm auto
GlobalVariable Property SyncTransform auto

Function AwakenBeast(ObjectReference FollowerRef)
    Actor FollowerActor = FollowerRef as Actor
    
    if (WerewolfFormAvailable && IsInWereForm.GetValueInt() == 0)
        FollowerActor.StopCombat()
        FollowerActor.GetActorBase().SetInvulnerable(true)

        WerewolfChangeSpell.Cast(FollowerRef, none)

        FollowerActor.GetActorBase().SetInvulnerable(false)

        IsInWereForm.SetValue(1)
        WerewolfFormAvailable = false
    Else
        Debug.Notification("something is wrong again")
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
        WerewolfFormAvailable = true
    endif
EndFunction

Function StartSyncTransform()
    Debug.Notification("Start sync transform")
    SyncTransform.SetValue(1)
    (HuntTogether as AE01AelaHuntTogetherQuestScript).Start()
EndFunction

Function StopSyncTransform()
    Debug.Notification("Stop sync transform")
    SyncTransform.SetValue(0)
    HuntTogether.Stop()
EndFunction

Function PlayerShiftedToDefaultForm()
    if IsInWereForm.GetValueInt() > 0 && PlayerRef.GetRace() != WerewolfRace
        HuntTogether.Stop()
        Actor FollowerActor = FollowerAlias.GetReference() as Actor
        SleepLittleBeast(FollowerActor)
    endif
EndFunction

Function PlayerShiftedIntoWerewolf()
    if IsInWereForm.GetValueInt() == 0 && PlayerRef.GetRace() == WerewolfRace
        Actor FollowerActor = FollowerAlias.GetReference() as Actor
        AwakenBeast(FollowerActor)
        HuntTogether.Start()
    else
        Debug.Notification("Something not working")
    endif
EndFunction