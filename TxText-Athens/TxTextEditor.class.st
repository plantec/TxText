"
I control text edit operations by using selection and can support undo operations.
"
Class {
	#name : #TxTextEditor,
	#superclass : #Object,
	#instVars : [
		'text',
		'selection',
		'undoBuffer',
		'announcer'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #'instance creation' }
TxTextEditor class >> text: aTxModel [
	^ self new text: aTxModel
]

{ #category : #'undo/redo' }
TxTextEditor >> addUndo: operation [
	undoBuffer addLast: operation 

]

{ #category : #private }
TxTextEditor >> announce: something [
	announcer announce: something
]

{ #category : #accessing }
TxTextEditor >> announcer [
	^ announcer weak
]

{ #category : #editing }
TxTextEditor >> backspace [
	selection isEmpty ifTrue: [ 
		selection end moveLeft.
	 ].

	selection isEmpty ifFalse: [ 
		selection cut.
		self notifyDeleted ].
]

{ #category : #selection }
TxTextEditor >> collapseSelection [
	"collapse the selection, moving selection start to selection end"
	self recordSelectionChange: [ 
		selection collapse.
	].

]

{ #category : #accessing }
TxTextEditor >> contents: anObject [

	"Unconditionally reset the contents, including selection and undo/redo buffers"
	
	self text: anObject asTxModel.

]

{ #category : #accessing }
TxTextEditor >> cursorPosition [
	^ selection end
]

{ #category : #editing }
TxTextEditor >> delete [
	selection isEmpty ifTrue: [ 
		selection end moveRight.
	 ].

	selection isEmpty ifFalse: [ 
		selection cut.
		self notifyDeleted ].

	
]

{ #category : #selection }
TxTextEditor >> extendSelectionDown [
	self recordSelectionChange: [ selection end moveDown ].

]

{ #category : #selection }
TxTextEditor >> extendSelectionLeft [
	self recordSelectionChange: [ selection end moveLeft ].
	
]

{ #category : #selection }
TxTextEditor >> extendSelectionRight [
	self recordSelectionChange: [ selection end moveRight ]
	
]

{ #category : #selection }
TxTextEditor >> extendSelectionToLineEnd [
	self recordSelectionChange: [ selection end moveToLineEnd ].

]

{ #category : #selection }
TxTextEditor >> extendSelectionToLineStart [
	self recordSelectionChange: [ selection end moveToLineStart ].

]

{ #category : #selection }
TxTextEditor >> extendSelectionUp [
	self recordSelectionChange: [ selection end moveUp ].
	
]

{ #category : #initialization }
TxTextEditor >> initialize [
	self resetUndoBuffer.
	announcer := Announcer new.
]

{ #category : #editing }
TxTextEditor >> insert: aString [
	| operation |
	
	selection isEmpty ifFalse: [ 
		self delete.
		 ].
	
	operation := TxInsertOperation editor: self.
	operation text: aString.
	self addUndo: operation.
	
	selection replaceWith: aString.
	
	self notifyInserted: aString.
	
	"selection collapse."
]

{ #category : #navigation }
TxTextEditor >> moveCursorTo: aTextPosition [
	self recordSelectionChange: [ 
		selection end: aTextPosition.
		selection collapse.
	].
	
]

{ #category : #navigation }
TxTextEditor >> moveDown [
	self recordSelectionChange: [ 
		selection end moveDown.
		selection collapse.
	].

]

{ #category : #navigation }
TxTextEditor >> moveLeft [
	(selection end isAtStart and: [ selection end span prev isAtStart ])
		ifTrue: [ ^ self ].
	self recordSelectionChange: [ 
		selection end moveLeft.
		selection collapse
	].
]

{ #category : #navigation }
TxTextEditor >> moveRight [
	self recordSelectionChange: [ 
		selection end moveRight.
		selection collapse.
	].

]

{ #category : #navigation }
TxTextEditor >> moveSelectionEndTo: aTextPosition [
	(aTextPosition hasSamePositionAs: selection end)
		ifFalse: [ self recordSelectionChange: [ selection end: aTextPosition ] ].

]

{ #category : #navigation }
TxTextEditor >> moveToLineEnd [
	self recordSelectionChange: [ 
		selection end moveToLineEnd.
		selection collapse
	].

]

{ #category : #navigation }
TxTextEditor >> moveToLineStart [
	self recordSelectionChange: [ 
		selection end moveToLineStart.
		selection collapse
	].

]

{ #category : #navigation }
TxTextEditor >> moveUp [
	self recordSelectionChange: [ 
		selection end moveUp.
		selection collapse.
	].

]

{ #category : #'private notifying' }
TxTextEditor >> notifyDeleted [
	self announce: (TxDeletedTextAnnouncement new
		editor: self;
		yourself)
]

{ #category : #'private notifying' }
TxTextEditor >> notifyInserted: aString [
	self announce: (TxInsertedTextAnnouncement new
		insertedText: aString;
		editor: self;
		yourself)
]

{ #category : #'private notifying' }
TxTextEditor >> notifyNewText [
	self announce: (TxNewTextAnnouncement new
		editor: self;
		yourself)
]

{ #category : #'private notifying' }
TxTextEditor >> notifySelectionChange: aSelection [
	self announce: (TxSelectionChangedAnnouncement new
		editor: self;
		newSelection: aSelection;
		yourself)
]

{ #category : #private }
TxTextEditor >> recordSelectionChange: aBlock [

	| operation |
	operation := (TxSelectionChangeOperation editor: self).
	operation captureDuring: aBlock.
	self addUndo: operation. 
	
	self notifySelectionChange: selection
]

{ #category : #initialization }
TxTextEditor >> resetUndoBuffer [
	undoBuffer := OrderedCollection new.
]

{ #category : #selection }
TxTextEditor >> selectAll [
	self recordSelectionChange: [ selection start moveToStart. selection end moveToEnd ].

]

{ #category : #accessing }
TxTextEditor >> selection [
	^ selection
]

{ #category : #selection }
TxTextEditor >> shiftSelectionTo: aPosition [
	"extends selection such that
		if aPosition is less than start, start moves to aPosition,
		if aPosition is greater than end, end moves to aPosition,
		if aPosition is inside current selection, start moves to aPosition"
	self recordSelectionChange: [ |start end|
		start := selection start min: selection end.
		end := selection start max: selection end.
		aPosition < end
			ifTrue: [ start := aPosition ]
			ifFalse: [ end := aPosition ].
		selection start: start.
		selection end: end ]
]

{ #category : #accessing }
TxTextEditor >> text [
	^ text
]

{ #category : #initialization }
TxTextEditor >> text: aText [

	text := aText.
	selection := text endPosition asSelection.
	self
		resetUndoBuffer;
		notifyNewText;
		notifySelectionChange: selection
]

{ #category : #'undo/redo' }
TxTextEditor >> undo [
	undoBuffer isEmpty ifTrue: [ ^ self ].
	undoBuffer removeLast undo.
]
