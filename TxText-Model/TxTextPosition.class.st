"
I represent a position inside a text. I am immutable.
I'm characterized by a span and position inside span.

Usually, one does not specify an absolute position in text (using textIndex accessors),
but instead a relative position, by starting from some known point (like an already known position, or text start/end),
and navigating to the desired position using the navigation protocol (moveLeft/moveRight, etc).
 
I provide operations to:
	- query the position in a text (isAtEnd, isAtStart, isValid)
	- compute a new position relative to the existing one (moveToLeft: 3, moveToUp)
	- insert new text (#insert: ) or embedded object (#insertObject:).
	
I can also give access to an absolute position in text using #asTextIndex accessors, but they are much slower/ineffective compared to relative positioning, and should not be used unless necessary.

"
Class {
	#name : #TxTextPosition,
	#superclass : #TxBasicTextPosition,
	#instVars : [
		'span',
		'spanPosition'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxTextPosition class >> on: aText [
	^ self span: aText startSpan spanPosition: 0
]

{ #category : #'instance creation' }
TxTextPosition class >> span: span spanPosition: spanPosition [

	^ self basicNew
			span: span spanPosition: spanPosition

]

{ #category : #converting }
TxTextPosition >> asCursor [
	^ TxTextCursor new position: self
]

{ #category : #converting }
TxTextPosition >> asPosition [
	^ self
]

{ #category : #operations }
TxTextPosition >> deleteUpTo: aTxPosition [
	^ span deleteUpTo: aTxPosition startingAt: self
]

{ #category : #comparing }
TxTextPosition >> hash [
	^ span hash bitXor: spanPosition hash
]

{ #category : #operations }
TxTextPosition >> insert: aString [
	^ span at: self insert: aString.

]

{ #category : #operations }
TxTextPosition >> insertObject: anObject [ 
	"Answer the position right after the inserted object."
	^ span at: self insertObject: anObject.

]

{ #category : #accessing }
TxTextPosition >> linePosition: pos [
	"Compute new position, located at new position in the same line as receiver.
	If given position larger than line length, answer the position at the end of line.
	The line position is a number of moves right from the beginning of line.
	"

	| sz linespan |
	sz := pos.
	linespan := (span isLineSeparator and: [ spanPosition = 1 ])
		ifTrue: [ span next ]
		ifFalse: [ span lineStartSpan ].
	[ sz > linespan size ]
		whileTrue: [ 
			sz := sz - linespan size.
			linespan := linespan next.
			(linespan isLineSeparator or: [ linespan isAtEnd ])
				ifTrue: [ 
					"reached end of line, set position to last valid position in current line"
					^ TxTextPosition span: linespan prev spanPosition: linespan size ] ].
	^ self class span: linespan spanPosition: sz
]

{ #category : #operations }
TxTextPosition >> mergeUpTo: aTxPosition [
	span deleteUpTo: aTxPosition startingAt: self
]

{ #category : #navigation }
TxTextPosition >> moveDown: number [
	"Answer the new position, *number* of lines below than receiver's line,
	trying to preserve the same line position"

	| linePos newSpan |
	
	(number < 0)
		ifTrue: [ ^ self moveUp: number negated ].
		
	linePos := self linePosition.
	newSpan := span.
	number timesRepeat: [
		newSpan := newSpan nextLineSeparatorIfNone: [ ^ self moveToEnd ].
	].
	
	^ newSpan endPosition linePosition: linePos.
	
]

{ #category : #navigation }
TxTextPosition >> moveLeft: number [
	| newSpan newSpanPos |
	
	(number < 0)
		ifTrue: [ ^ self moveRight: number negated ].
		
	"Decrement spanPosition, if we're going to stay in same span,
	otherwise move prior to last character of previous span"
	newSpan := span.
	newSpanPos := spanPosition.
	
	number timesRepeat: [
		newSpanPos > 0 
			ifTrue: [ newSpanPos := newSpanPos - 1 ]
			ifFalse: [ 
				newSpan := newSpan prevIfNone: [  "can't go further than start " ^ self text startPosition ].
				newSpanPos := newSpan size - 1 max: 0.
			].
	].

	^ self class span: newSpan spanPosition: newSpanPos.
	
]

{ #category : #navigation }
TxTextPosition >> moveRight: number [
	| newSpan newSpanPos |
	(number < 0)
		ifTrue: [ ^ self moveLeft: number negated ].
		
	newSpan := span.
	newSpanPos := spanPosition.
	
	number timesRepeat: [ 
 		newSpanPos < newSpan size 
			ifTrue: [ newSpanPos := newSpanPos  + 1 ]
			ifFalse: [ 
				newSpan := newSpan nextIfNone: [ "reached end" ^ self text endPosition ].
"				self assert: newSpan size > 0."
				newSpanPos := 1 min: newSpan size ]
 	].

	^ self class span: newSpan spanPosition: newSpanPos
	
]

{ #category : #navigation }
TxTextPosition >> moveTo: anotherTextPosition [

	^ anotherTextPosition 
]

{ #category : #navigation }
TxTextPosition >> moveToEnd [
	^ self text endPosition
]

{ #category : #navigation }
TxTextPosition >> moveToLineEnd [

	^ (span nextLineSeparatorIfNone: [ ^ self text endPosition ])
		startPosition
]

{ #category : #navigation }
TxTextPosition >> moveToLineStart [
	| sp |
	self isAtLineStart ifTrue: [  ^ self ].
	sp := span.
	(span isLineSeparator and: [ spanPosition = 0 ]) ifTrue: [ sp := span prev ].
	sp reverseDo: [ :each | each isLineSeparator ifTrue: [ ^ each endPosition ] ].
	^ self text startPosition
]

{ #category : #navigation }
TxTextPosition >> moveToStart [
	^ self text startPosition
]

{ #category : #navigation }
TxTextPosition >> moveUp [
	^ self moveUp: 1
]

{ #category : #navigation }
TxTextPosition >> moveUp: number [
	| oldLinePosition  pos |
	
	(number < 0)
		ifTrue: [ ^ self moveDown: number negated ].
	
	oldLinePosition := self linePosition.
	pos := self.
	
	number timesRepeat: [ 
		pos := pos moveToLineStart moveLeft.
		pos isAtStart ifTrue: [  ^ pos ]
	].

	^ pos linePosition: oldLinePosition.

]

{ #category : #navigation }
TxTextPosition >> nextPosition [
	"answer the position which is right next to the receiver"
	
	^ self isAtSpanEnd 
		ifFalse: [  span positionAt: spanPosition + 1 ]
		ifTrue: [ span next startPosition ]
]

{ #category : #operations }
TxTextPosition >> nextPut: aCharacter [
	self shouldBeImplemented 
]

{ #category : #operations }
TxTextPosition >> nextPutAll: aString [
	^ self text at: self insert: aString

]

{ #category : #printing }
TxTextPosition >> printOn: aStream [

	"super printOn: aStream. "
	self isValid ifFalse: [ aStream nextPutAll: '**invalid position**'. ^ self ].
	aStream 
		nextPutAll: ' line: ';
		print: self lineNumber;
		nextPutAll: ' col: ';
		print: self linePosition 
		
]

{ #category : #operations }
TxTextPosition >> removeNextCharacter [
	| copy |
	copy := self copy.
	copy moveRight.
	^ (self to: copy) cut start
]

{ #category : #operations }
TxTextPosition >> removePreviousCharacter [
	| copy |
	copy := self copy.
	copy moveLeft.
	^ (copy to: self) cut start
]

{ #category : #accessing }
TxTextPosition >> span [
	^ span
]

{ #category : #accessing }
TxTextPosition >> span: aSpan [
	span := aSpan.
]

{ #category : #'initialize-release' }
TxTextPosition >> span: aSpan spanPosition: aSpanPosition [

	span := aSpan.
	spanPosition := aSpanPosition
	
]

{ #category : #accessing }
TxTextPosition >> spanPosition [
	^ spanPosition
]

{ #category : #accessing }
TxTextPosition >> spanPosition: anInteger [
	spanPosition := anInteger
]

{ #category : #accessing }
TxTextPosition >> text [
	^ span text
]
