Class {
	#name : #TxSliderAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'source'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #'as yet unclassified' }
TxSliderAnnouncement class >> source: aSlider [

	^ self new source: aSlider 
]

{ #category : #accessing }
TxSliderAnnouncement >> source [
	
	^ source
]

{ #category : #accessing }
TxSliderAnnouncement >> source: anObject [
	
	source := anObject
]
