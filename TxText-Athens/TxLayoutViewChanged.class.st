Class {
	#name : #TxLayoutViewChanged,
	#superclass : #Announcement,
	#instVars : [
		'view'
	],
	#category : #'TxText-Athens'
}

{ #category : #accessing }
TxLayoutViewChanged >> view [
	
	^ view
]

{ #category : #accessing }
TxLayoutViewChanged >> view: anObject [
	
	view := anObject
]
