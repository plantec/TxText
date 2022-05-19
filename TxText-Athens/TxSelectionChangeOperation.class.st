"
a history record containing selection change operation
"
Class {
	#name : #TxSelectionChangeOperation,
	#superclass : #TxEditorOperation,
	#instVars : [
		'startDelta',
		'endDelta'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #'recording the changes' }
TxSelectionChangeOperation >> captureDuring: aBlock [

	| before after |
	before := editor selection copy.
	
	aBlock ensure: [ 
		after := editor selection.	
		startDelta := before start -- after start.
		endDelta := before end -- after end.
	].
]

{ #category : #printing }
TxSelectionChangeOperation >> printOn: aStream [
	super printOn: aStream.
	
	aStream space; 
		print: '['; 
		print: startDelta;
		print: ' , ';
		print: endDelta;
		print: ']'
]

{ #category : #'do/undo' }
TxSelectionChangeOperation >> redo [
	editor selection start moveRight: startDelta.
	editor selection end moveRight: endDelta.
	editor notifySelectionChange: editor selection
	
]

{ #category : #converting }
TxSelectionChangeOperation >> reversed [
	^ self copy
		startOffset: startDelta negated;
		endOffset: endDelta negated;
		yourself
]

{ #category : #'do/undo' }
TxSelectionChangeOperation >> undo [
	editor selection start moveRight: startDelta negated.
	editor selection end moveRight: endDelta negated.
	editor notifySelectionChange: editor selection
]
