Scriptname CR03QuestScript extends CompanionsRadiantQuest conditional

ReferenceAlias Property SamplePelt auto
ReferenceAlias Property SamplePeltSpawnPoint auto

int Property UpdateInterval auto

int Property MinSkins auto
int Property MaxSkins auto

MiscObject Property BearCave auto
MiscObject Property Bear auto
MiscObject Property BearSnow auto
MiscObject Property SabreCat auto
MiscObject Property SabreCatSnow auto
MiscObject Property WolfIce auto
MiscObject Property Wolf auto

FormList Property BearFormList auto
FormList Property SabreCatFormList auto
FormList Property WolfFormList auto

int targetNumberOfSkins = -1
int currentNumberOfSkins = -1
GlobalVariable Property TotalNeeded auto
GlobalVariable Property PeltsGotten auto
MiscObject TargetSkins = None
FormList TargetSkinsList
int Property TargetSkinsIndex auto conditional

Function Setup()
	targetNumberOfSkins = Utility.RandomInt(MinSkins, MaxSkins)
	TotalNeeded.value = targetNumberOfSkins
	currentNumberOfSkins = 0
	PeltsGotten.value = currentNumberOfSkins
	UpdateCurrentInstanceGlobal(TotalNeeded)
	UpdateCurrentInstanceGlobal(PeltsGotten)
		
	TargetSkinsIndex = Utility.RandomInt(1, 7)
	if     (TargetSkinsIndex == 1)
		TargetSkins = Bear ;BearCave
		TargetSkinsList = BearFormList
	elseif (TargetSkinsIndex == 2)
		TargetSkins = Bear
		TargetSkinsList = BearFormList
	elseif (TargetSkinsIndex == 3)
		TargetSkins = Bear ;BearSnow
		TargetSkinsList = BearFormList
	elseif (TargetSkinsIndex == 4)
		TargetSkins = SabreCat
		TargetSkinsList = SabreCatFormList
	elseif (TargetSkinsIndex == 5)
		TargetSkins = SabreCat ;SabreCatSnow
		TargetSkinsList = SabreCatFormList
	elseif (TargetSkinsIndex == 6)
		TargetSkins = Wolf ; WolfIce
		TargetSkinsList = WolfFormList
	elseif (TargetSkinsIndex == 7)
		TargetSkins = Wolf
		TargetSkinsList = WolfFormList
	else
		TargetSkinsIndex = 1
		TargetSkins = Bear ;BearCave
		TargetSkinsList = BearFormList
	endif
	
	if (TargetNumberOfSkins <= 0)
		TargetNumberOfSkins = 7
	endif
	
	ObjectReference pelt = SamplePeltSpawnPoint.GetReference().PlaceAtMe(TargetSkins)
	SamplePelt.ForceRefTo(pelt)
	
	parent.Setup()
EndFunction

Function Accepted()
	RegisterForSingleUpdate(0.5)
	
	parent.Accepted()
EndFunction

Function Finished(bool _succeeded = true, bool _finished = true)	
	parent.Finished(_succeeded, _finished)
EndFunction

Function Cleanup()
	;Game.GetPlayer().RemoveItem(TargetSkinsList, TargetNumberOfSkins)
	RemovePelts()
	
	ObjectReference pelt = SamplePelt.GetReference()
	SamplePelt.Clear()
	pelt.Disable()
	pelt.Delete()
	
	parent.Cleanup()
EndFunction

Event OnUpdate()
	int currentSkins = Game.GetPlayer().GetItemCount(TargetSkinsList)
	;Debug.Notification("currentSkins=" + currentSkins)
	;Debug.Notification("TargetSkinsList=" + TargetSkinsList.GetSize())
	;Debug.Notification("TargetIndex=" + TargetSkinsIndex)

	if (currentSkins == currentNumberOfSkins)
		RegisterForSingleUpdate(0.5)
		return
	else
 		; Debug.Trace("CRQ CR03: currentSkins=" + currentSkins + "; currentNumberOfSkins=" + currentNumberOfSkins)
	endif
	
	PeltsGotten.value = currentSkins
	UpdateCurrentInstanceGlobal(PeltsGotten)
	
	if (currentSkins >= TargetNumberOfSkins)
		SetStage(20)
		SetObjectiveCompleted(10, 1)
		Finished(true, true)
	elseif (GetStageDone(20))
		; at one point we had enough, but lost some
		SetObjectiveCompleted(10, 0)
		SetObjectiveDisplayed(10, 1, True)
		Finished(false, false)
		RegisterForSingleUpdate(0.5)
	else
		; still not enough... the hippos will always be hungry
		SetObjectiveDisplayed(10, 1, True)
		Finished(false, false)
		RegisterForSingleUpdate(0.5)
	endif
	
	currentNumberOfSkins = currentSkins
EndEvent

Function RemovePelts()
	int removeTotal = TargetNumberOfSkins
	int iIndex = TargetSkinsList.GetSize()
	while iIndex
		iIndex -= 1

		if (removeTotal == 0)
			return
		else
			MiscObject peltToRemove = TargetSkinsList.GetAt(iIndex) as MiscObject
			int PlayerHasInInventory = Game.GetPlayer().GetItemCount(peltToRemove)
	
			if (PlayerHasInInventory <= removeTotal && PlayerHasInInventory != 0)
				Game.GetPlayer().RemoveItem(peltToRemove, PlayerHasInInventory)
				removeTotal -= PlayerHasInInventory
			elseif (PlayerHasInInventory >= removeTotal)
				Game.GetPlayer().RemoveItem(peltToRemove, removeTotal)
				removeTotal = 0
			endif
		endif
	endwhile
EndFunction