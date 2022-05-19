"
a history record containing delete operation
"
Class {
	#name : #TxDeleteOperation,
	#superclass : #TxEditorOperation,
	#instVars : [
		'selection',
		'deletedPortion'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #'undo-undo' }
TxDeleteOperation >> do [
	selection cut
]
