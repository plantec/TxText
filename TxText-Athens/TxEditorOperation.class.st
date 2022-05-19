"
my subclasses representing a concrete operation which modifies target text which is being edited,
including changing the text or changing selection.

i am kind of command, to support undo/redo operations.
"
Class {
	#name : #TxEditorOperation,
	#superclass : #Object,
	#instVars : [
		'editor'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #'instance creation' }
TxEditorOperation class >> editor: anEditor [
	^ self new editor: anEditor
]

{ #category : #'recording the changes' }
TxEditorOperation >> captureDuring: aBlock [
	self subclassResponsibility
]

{ #category : #initialization }
TxEditorOperation >> editor: anEditor [
	editor := anEditor
]

{ #category : #'do/undo' }
TxEditorOperation >> redo [
	"perform an operation"
]

{ #category : #'do/undo' }
TxEditorOperation >> undo [
	"perform a reverse operation"
]
