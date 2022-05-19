"
Start span is span which _always_ first span of text and only one of his kind per text model. 
So this span used to denote start of text.
"
Class {
	#name : #TxStartSpan,
	#superclass : #TxTerminalSpan,
	#category : #'TxText-Model'
}

{ #category : #visitor }
TxStartSpan >> accept: anObject [
	"visitor pattern"
	
	^ anObject visitStartSpan: self
]

{ #category : #copying }
TxStartSpan >> appendCopyTo: anotherText [
	"Create a copy of receiver and append it to the another text (at the end of it).
	Answer the copy"

	"Start span cannot be copied, instead we just answer the existing start span of another text"
	^ anotherText startSpan
]

{ #category : #operation }
TxStartSpan >> deleteUpTo: end startingAt: start [
	
	end span == self ifTrue: [ "nothing to remove"  ^ end ].
	
	self next: end span.
	end span removeBefore: end spanPosition.
	
	^ self tryMergeAndUpdatePosition: start 
]

{ #category : #operation }
TxStartSpan >> insertCharacters: chars at: position attributes: insertAttributes [
	
	"Insert characters (no line separators allowed!!!), with given attributes at given position in receiver.
	Answer the end position of inserted characters"
	
	"Since we cannot insert anything into start span, and our only valid position is zero,
	we either delegate to next character span, or create a new one, if none"
	
	| span |
	next isCharacterSpan ifTrue: [
		^ next insertCharacters: chars at: next startPosition attributes: insertAttributes 
	].

	span := (text newCharacterSpan: chars) replaceAttributes: insertAttributes.
	self insertNext: span.
	^ next endPosition
	
]

{ #category : #operation }
TxStartSpan >> insertLineSeparator: separator at: position [
	| pos |
	pos := next startPosition.
	self insertNext: separator.
	^ pos

]

{ #category : #testing }
TxStartSpan >> isAtLineStart: spanPosition [
	"start of text always starts a new line "
	^ true
]

{ #category : #testing }
TxStartSpan >> isAtStart [
	^ true
]

{ #category : #accessing }
TxStartSpan >> lineNumberAt: aTxTextPosition [
	"i am always at 1st line"
	^ 1
]

{ #category : #accessing }
TxStartSpan >> prev: anObject [
	self error: 'Start span cannot have previous span!'
]

{ #category : #printing }
TxStartSpan >> printOn: aStream [
	 aStream nextPutAll: '<< ' 
]

{ #category : #accessing }
TxStartSpan >> style [	
	^ text isEmpty
		ifTrue: [ text defaultStyle ]
		ifFalse: [ next style ]
]
