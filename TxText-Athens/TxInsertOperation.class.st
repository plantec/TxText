"
a history record containing insert operation
"
Class {
	#name : #TxInsertOperation,
	#superclass : #TxEditorOperation,
	#instVars : [
		'text'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #accessing }
TxInsertOperation >> text: aString [
	text := aString
]

{ #category : #'do/undo' }
TxInsertOperation >> undo [
	
	editor selection end moveLeft: text size.
	editor selection cut.
	editor notifyDeleted
]
