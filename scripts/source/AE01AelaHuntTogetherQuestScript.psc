Scriptname AE01AelaHuntTogetherQuestScript extends Quest 

Quest Property AelaController auto
Quest Property PlayerWerewolfController auto
Actor Property PlayerRef auto
ReferenceAlias Property AelaRef auto

Event OnInit()
    Debug.Notification("Is running hunt together")
EndEvent
