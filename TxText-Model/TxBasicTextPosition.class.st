"
I am an abstract class, defining the protocol for a text position.
"
Class {
	#name : #TxBasicTextPosition,
	#superclass : #Magnitude,
	#category : #'TxText-Model'
}

{ #category : #accessing }
TxBasicTextPosition >> + anInteger [
	"Answer the position moved anInteger times right (positive) or left (negative) relative to receiver"
	
	^ self moveRight: anInteger
]

{ #category : #accessing }
TxBasicTextPosition >> -- aPosition [
	"Answer the distance between receiver and position, in terms of number of moving receiver right (positive)
	or left (negative) until it meets a given position. Answer zero if two positions coincide"
	
	(self hasSamePositionAs: aPosition) ifTrue: [  ^ 0 ].
	
	^ self < aPosition 
		ifTrue: [ self timesToMoveRightTo: aPosition ]
		ifFalse: [ (aPosition timesToMoveRightTo: self) negated ]
]

{ #category : #comparing }
TxBasicTextPosition >> < aPosition [
	"Answer true if receiver is closer to start of the text than argument, false otherwise.
	Note, both positions should belong to same text"
		
	aPosition text == self text ifFalse: [ self error: 'Cannot compare positions belonging to different text' ].

	"local case first"
	self span == aPosition span ifTrue: [ 
		^ self spanPosition < aPosition spanPosition
	].
	
	^ self span < aPosition span
]

{ #category : #comparing }
TxBasicTextPosition >> = anObject [
	^ (anObject isKindOf: TxBasicTextPosition) and: [
		anObject text = self text and: [ anObject span = self span and: [ anObject spanPosition = self spanPosition ]]]
]

{ #category : #converting }
TxBasicTextPosition >> asCursor [
	^ self subclassResponsibility 
]

{ #category : #converting }
TxBasicTextPosition >> asPosition [
	^ self subclassResponsibility 
]

{ #category : #converting }
TxBasicTextPosition >> asSelection [
	^ TxSelection from: self to: self
]

{ #category : #converting }
TxBasicTextPosition >> asTextIndex [
	"Answer the absolute index which corresponds to receiver's location inside text.
	The resulting number is equivalent to the number of times of moving text starting position
	right, to reach same position as the receiver.

	Please note that converting text index<->position does not takes constant time, 
	because it requires linear scan from the beginning of text.

	Also note that answered number does not corresponds to some the character index in text, 
	but to index of unique insertion point in text, with the exception that endpoints of adjacent spans
	considered as same insertion point, not two separate ones.
	
	This method is symmetrical to TxModel>>#positionAtTextIndex:. 
	"
	
	^ self text startPosition timesToMoveRightTo: self
]

{ #category : #accessing }
TxBasicTextPosition >> characterStream [
	"answer the character stream, starting at receiver's position"
	
	^ TxCharacterStream onPosition: self
]

{ #category : #accessing }
TxBasicTextPosition >> getCharacter [
	"Answer the character, right before the receiver,
	answer nil, if there's no character at given position"
	
	^ self span characterBeforePosition: self spanPosition ifNone: nil
]

{ #category : #comparing }
TxBasicTextPosition >> hasSamePositionAs: position [
	"Answer true if receiver having same position (in terms of text index) as another position.
	See #textIndex for explanation of text index"
	
	self span == position span ifTrue: [	^ self spanPosition = position spanPosition ].
		
	(self isAtSpanStart and: [ position isAtSpanEnd and: [ self span prev = position span]])
			ifTrue: [ ^ true ].

	(self isAtSpanEnd and: [ position isAtSpanStart and: [ self span next = position span]])
		ifTrue: [ ^ true ].
	
	^ false
]

{ #category : #comparing }
TxBasicTextPosition >> hash [
	^ self span hash bitXor: self spanPosition hash
]

{ #category : #operations }
TxBasicTextPosition >> insert: aString [ 
	"
	Insert a possibly multi-line string at given position of receiver.
	Answer the position right after the last character of inserted string.
	The inserted portion of will inherit same attributes as current position attributes.
	"
	self subclassResponsibility 
]

{ #category : #operations }
TxBasicTextPosition >> insertObject: anObject [ 
	"
	Insert an embedded object at receiver.
	Answer the position right after the inserted object.
	"
	self subclassResponsibility 
]

{ #category : #'error handling' }
TxBasicTextPosition >> invalidPosition [
	"The receiver is no longer a valid text position for TxModel"

	Error signal: 'Invalid text position'
]

{ #category : #testing }
TxBasicTextPosition >> isAtEnd [
	"Answer true if receiver points to the end of text"
	^ self span next isAtEnd and: [ self spanPosition = self span size ]
]

{ #category : #testing }
TxBasicTextPosition >> isAtLineEnd [
	^ (self spanPosition = 0 and: [ self span isLineSeparator ])
		or: [  (self isAtSpanEnd and: [self span next isLineSeparator ])]
]

{ #category : #testing }
TxBasicTextPosition >> isAtLineStart [
	^ self isAtStart or: [ self span isLineSeparator and: [ self isAtSpanEnd ] ]
]

{ #category : #testing }
TxBasicTextPosition >> isAtSpanEnd [
	^ self span isLastPosition: self spanPosition
]

{ #category : #testing }
TxBasicTextPosition >> isAtSpanStart [
	^ self spanPosition = 0
]

{ #category : #testing }
TxBasicTextPosition >> isAtStart [
	"Answer true if receiver points to the start of text"

	^ self span prev isAtStart and: [ self spanPosition = 0 ]
]

{ #category : #testing }
TxBasicTextPosition >> isValid [
	^ (self text includesSpan: self span) and: [ self spanPosition between: 0 and: self span size ]
]

{ #category : #accessing }
TxBasicTextPosition >> lineNumber [
	"Answer the 1-based line number, where receiver is currently in. "
	^ self span lineNumberAt: self 
]

{ #category : #accessing }
TxBasicTextPosition >> linePosition [
	"Answer the position of receiver, relative to line start. "

	(self span isLineSeparator and: [self spanPosition =1 ]) ifTrue: [ ^ 0 ].
	
	self span lineStartSpan spanAndPositionDo: [ :newSpan :spanStartPosition |
		newSpan = self span 
			ifTrue: [ ^ spanStartPosition + self spanPosition ]].
		
	^ self invalidPosition 

]

{ #category : #accessing }
TxBasicTextPosition >> linePosition: offset [ 
	"Answer the position, in same line as receiver, relative to line start.
	If offset bigger than line size, answer position for the end of line. "
	self subclassResponsibility
]

{ #category : #navigation }
TxBasicTextPosition >> moveDown [
	^ self moveDown: 1
]

{ #category : #navigation }
TxBasicTextPosition >> moveDown: number [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveLeft [
	
	^ self moveLeft: 1
]

{ #category : #navigation }
TxBasicTextPosition >> moveLeft: number [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveRight [

	^ self moveRight: 1


]

{ #category : #navigation }
TxBasicTextPosition >> moveRight: number [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveTo: anotherTextPosition [

	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveToEnd [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveToLineEnd [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveToLineStart [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveToStart [
	self subclassResponsibility 
]

{ #category : #navigation }
TxBasicTextPosition >> moveUp [
	^ self moveUp: 1
]

{ #category : #navigation }
TxBasicTextPosition >> moveUp: number [
	self subclassResponsibility 
]

{ #category : #accessing }
TxBasicTextPosition >> nextPosition [
	"answer the position in text, which follows the receiver"
	self subclassResponsibility 
]

{ #category : #printing }
TxBasicTextPosition >> printTextOn: aStream upTo: endPosition [ 

	self span == endPosition span ifTrue: [ 
		^self span asStringOn: aStream startingAt: self spanPosition upTo: endPosition spanPosition].

	self span asStringOn: aStream startingAt: self spanPosition.
	self span next printTextOn: aStream upTo: endPosition span.
	endPosition span asStringOn: aStream upTo: endPosition spanPosition.

	
]

{ #category : #converting }
TxBasicTextPosition >> selectTo: aPosition [
	^ self text newSelection start: self; end: aPosition; yourself 

]

{ #category : #accessing }
TxBasicTextPosition >> span [
	"Answer the span, where receiver is currently in. "
	self subclassResponsibility
]

{ #category : #accessing }
TxBasicTextPosition >> spanPosition [
	"Answer the span position, where receiver is currently in. "
	self subclassResponsibility
]

{ #category : #accessing }
TxBasicTextPosition >> text [
	"Answer the TxModel instance where receiver is pointing in. "
	self subclassResponsibility
]

{ #category : #private }
TxBasicTextPosition >> timesToMoveRightTo: aPosition [
	"Private.
	Assuming that receiver <= aPosition, answer the number of times
	to move receiver right to reach the given position.
	"

	| result mySpan targetSpan |
	mySpan := self span.
	targetSpan := aPosition span.
	result := 0.
	mySpan == targetSpan
		ifTrue: [ ^ aPosition spanPosition - self spanPosition ].
	mySpan
		do: [ :each | 
			each == targetSpan
				ifTrue: [ ^ result + aPosition spanPosition ]
				ifFalse: [ 
					result := each == mySpan
						ifTrue: [ mySpan size - self spanPosition ]
						ifFalse: [ result + each size ] ] ].
	self invalidPosition
]

{ #category : #converting }
TxBasicTextPosition >> to: aPosition [
	^ TxInterval from: self to: aPosition
]
