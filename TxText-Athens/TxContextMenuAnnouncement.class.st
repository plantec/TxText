Class {
	#name : #TxContextMenuAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'event',
		'editorMorph',
		'textPosition',
		'menu'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #accessing }
TxContextMenuAnnouncement >> editorMorph [
	^ editorMorph
]

{ #category : #accessing }
TxContextMenuAnnouncement >> editorMorph: anObject [
	editorMorph := anObject
]

{ #category : #accessing }
TxContextMenuAnnouncement >> event [
	^ event
]

{ #category : #accessing }
TxContextMenuAnnouncement >> event: anObject [
	event := anObject
]

{ #category : #accessing }
TxContextMenuAnnouncement >> textPosition [
	^ textPosition
]

{ #category : #accessing }
TxContextMenuAnnouncement >> textPosition: anObject [
	textPosition := anObject
]
