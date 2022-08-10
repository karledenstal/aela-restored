Scriptname AE01HuntTogetherPlayerScript extends ReferenceAlias

Quest Property AelaController auto

Event OnLycanthropyStateChanged(bool abIsWerewolf)
    if (abIsWerewolf)
        (AelaController as AE01AelaController).PlayerShiftedIntoWerewolf()
    endif
EndEvent