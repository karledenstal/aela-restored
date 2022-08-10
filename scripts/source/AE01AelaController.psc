Scriptname AE01AelaController extends Quest

Actor Property PlayerRef auto

Faction Property WerewolfFaction auto
Spell Property WerewolfChangeSpell auto
Idle Property WerewolfTransformBack auto

bool WerewolfFormAvailable = true
bool IsInWereForm = false
bool IsShiftingBack = false

Function AwakenBeast(ObjectReference FollowerRef)
    Actor FollowerActor = FollowerRef as Actor
    
    if (WerewolfFormAvailable && !isInWereForm)
        FollowerActor.StopCombat()
        FollowerActor.GetActorBase().SetInvulnerable(true)

        WerewolfChangeSpell.Cast(FollowerRef, none)

        FollowerActor.GetActorBase().SetInvulnerable(false)

        IsInWereForm = true
        WerewolfFormAvailable = false
    endif
EndFunction

Function SleepLittleBeast(ObjectReference FollowerRef)
    Actor FollowerActor = FollowerRef as Actor

    if (isInWereForm)
        FollowerActor.GetActorBase().SetInvulnerable(true)

        IsShiftingBack = false
        ; Use revert form here
        RegisterForAnimationEvent(FollowerRef, "TransformToHuman")
        FollowerActor.PlayIdle(WerewolfTransformBack)

        Utility.Wait(10)
        ActuallyShiftBack(FollowerActor)

        IsInWereForm = false
    endif
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    if (asEventName == "TransformToHuman")
        ActuallyShiftBack(akSource as Actor)
    endif
EndEvent

Function ActuallyShiftBack(Actor FollowerActor)
    if IsShiftingBack
        return
    endif

    IsShiftingBack = true

    UnregisterForAnimationEvent(FollowerActor, "TransformToHuman")
    UnregisterForUpdate()

    if (FollowerActor.IsDead())
        return
    endif

    FollowerActor.GetActorBase().SetInvulnerable(false)
EndFunction
