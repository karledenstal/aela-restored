Scriptname AE01HuntTogetherAliasScript extends ReferenceAlias  

Quest property AelaController auto
Quest property HuntTogether auto

Event OnEnterBleedout()
    (AelaController as AE01AelaController).ShouldShiftBack = true
    HuntTogether.Stop()
EndEvent

Event OnDeath(Actor akKiller)
    (AelaController as AE01AelaController).ShouldShiftBack = true
    HuntTogether.Stop()
EndEvent