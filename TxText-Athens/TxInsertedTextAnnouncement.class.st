"
I am announced right after some text are inserted into text.
"
Class {
	#name : #TxInsertedTextAnnouncement,
	#superclass : #TxTextEditorAnnouncement,
	#instVars : [
		'insertedText'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #accessing }
TxInsertedTextAnnouncement >> insertedText [
	^ insertedText
]

{ #category : #accessing }
TxInsertedTextAnnouncement >> insertedText: anObject [
	insertedText := anObject
]
