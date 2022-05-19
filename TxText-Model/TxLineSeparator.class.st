"
I represent a line separator
(NOT a new line in text).

My size is always 1. And my textual representation is always Character cr.

I have only two valid span positions:
 0 - denotes the last valid position of the previous line (line end)
 1 - denotes the first valid position of the next line (line start).

My attributes define the default attributes of the new line, so even if the next span
is a line separator (meaning that the next line is empty), I can provide information about visual properties such as line height etc.

"
Class {
	#name : #TxLineSeparator,
	#superclass : #TxSpanWithStyle,
	#category : #'TxText-Model'
}

{ #category : #visitor }
TxLineSeparator >> accept: anObject [
	"visitor pattern"
	
	^ anObject visitLineSeparator: self
]

{ #category : #attributes }
TxLineSeparator >> applyAttribute: anAttribute from: startPosition to: endPosition [
	"do not apply only if start position is > 1 or end < 1"
	
	(startPosition span == self and: [ startPosition spanPosition > 0 ]) ifTrue: [ ^ self ].
	(endPosition span == self and: [ endPosition spanPosition = 0 ]) ifTrue: [ ^ self ].
	self applyAttribute: anAttribute.

]

{ #category : #printing }
TxLineSeparator >> asStringOn: aStream [
	aStream cr.
]

{ #category : #printing }
TxLineSeparator >> asStringOn: aStream startingAt: index [
	index < 1 ifTrue: [  aStream cr ].
]

{ #category : #printing }
TxLineSeparator >> asStringOn: aStream startingAt: startIndex upTo: endIndex [
	"specialized in subclasses"
	(endIndex - startIndex > 0) ifTrue: [ 
		aStream cr.
		 ]
]

{ #category : #accessing }
TxLineSeparator >> characterBeforePosition: spanPosition ifNone: aBlock [

	"Answer character which is right before the position, located in receiver
	or evaluate a block if there's none"
	
	(spanPosition = 1)
		ifTrue: [ ^ Character cr ].
		
	^ aBlock value
]

{ #category : #operation }
TxLineSeparator >> deleteUpTo: end startingAt: start [
	self assert: start span == self.
	
	end span == self ifTrue: [
		start spanPosition > 0 ifTrue: [ "nothing to delete" ^ end ].
		end spanPosition = 1 ifTrue: [ self delete. ^ next startPosition ].
		^ end
	].
	
	start spanPosition = 0 ifTrue: [
		self delete.
	].
	^ next deleteUpTo: end startingAt: next startPosition.

]

{ #category : #operations }
TxLineSeparator >> doMerge: aCharacterSpan [
	^ false.
]

{ #category : #'accessing-text position' }
TxLineSeparator >> endPosition [
	"answer the text position, pointing to the end of receiver"
	^ self positionAt: 1
]

{ #category : #operation }
TxLineSeparator >> insertCharacters: chars at: position attributes: insertAttributes [
	"Insert a single line character string at the given position,
	answer a new position pointing to the end of inserted string"

	| spanPos newSpan |

	spanPos := position spanPosition.
	spanPos = 0 ifTrue: [ 
		prev isCharacterSpan ifTrue: [ 
			^ prev insertCharacters: chars at: prev endPosition attributes: insertAttributes ].
		newSpan := (text newCharacterSpan: chars) replaceAttributes: insertAttributes.
		self insertPrev: newSpan.
		^ position	
	].
	
	next isCharacterSpan ifTrue: [ 
		^ next insertCharacters: chars at: next startPosition attributes: insertAttributes ].
	newSpan := (text newCharacterSpan: chars) replaceAttributes: insertAttributes.
	self insertNext: newSpan.
	^ next endPosition
]

{ #category : #operation }
TxLineSeparator >> insertLineSeparator: separator at: position [
	
	position spanPosition > 0 ifTrue: [
		self insertNext: separator. 
		^ next endPosition ].
	
	self insertPrev: separator.
	^ self startPosition
]

{ #category : #testing }
TxLineSeparator >> isAtLineStart: spanPosition [
	"position behind #cr , means a line start"
	^ spanPosition > 0
]

{ #category : #testing }
TxLineSeparator >> isLastPosition: aNumber [
	^ aNumber = 1
]

{ #category : #testing }
TxLineSeparator >> isLineSeparator [
	^ true
]

{ #category : #accessing }
TxLineSeparator >> lineNumberAt: textPosition [ 
	"i am not changing the number of lines"
	^ self numberOfLinesBefore + (textPosition spanPosition "0 or 1")
]

{ #category : #operations }
TxLineSeparator >> mergeUpTo: aSpan [
	aSpan = self next ifTrue: [ ^ self next ].
	^ self next mergeUpTo: aSpan.
]

{ #category : #printing }
TxLineSeparator >> printContentsOn: aStream [
	aStream nextPutAll: '#cr'
]

{ #category : #operation }
TxLineSeparator >> removeBefore: anIndex [
	anIndex = 1 ifTrue: [
		"remove ourselves"
		self delete.
		].
	
]

{ #category : #accessing }
TxLineSeparator >> size [
	^ 1
]

{ #category : #'accessing-text position' }
TxLineSeparator >> startPosition [
	"answer the text position, pointing to the start of receiver"
	^ self positionAt: 0
]

{ #category : #operations }
TxLineSeparator >> styleAtPosition: txPosition [ 

	"The receiver's attributes is defined for the next line,
	however a text position pointing to beginning of receiver is formally an insertion point belonging
	to previous line, therefore we must use previous span attributes"
	
	^ txPosition spanPosition = 0
		ifTrue: [ prev style ]
		ifFalse: [ style ]
]
