"
I am just like a normal text position, but mutable.
"
Class {
	#name : #TxTextCursor,
	#superclass : #TxBasicTextPosition,
	#instVars : [
		'position'
	],
	#category : #'TxText-Model'
}

{ #category : #converting }
TxTextCursor >> asCursor [
	^ self
]

{ #category : #converting }
TxTextCursor >> asPosition [
	^ position
]

{ #category : #operations }
TxTextCursor >> deleteUpTo: aTxPosition [
	^ position deleteUpTo: aTxPosition 
]

{ #category : #operations }
TxTextCursor >> insert: aString [ 
	"
	Insert a possibly multi-line string at given position of receiver.
	Move position right after the last character of inserted string.
	The inserted portion of will inherit same attributes as current position attributes.
	"
	position := self span at: position insert: aString.

]

{ #category : #navigation }
TxTextCursor >> linePosition: offset [
	position := position linePosition: offset
]

{ #category : #navigation }
TxTextCursor >> moveDown: number [
	position := position moveDown: number
]

{ #category : #navigation }
TxTextCursor >> moveLeft: number [
	position := position moveLeft: number
]

{ #category : #navigation }
TxTextCursor >> moveRight: number [
	position := position moveRight: number
]

{ #category : #navigation }
TxTextCursor >> moveTo: anotherTextPosition [
	position := anotherTextPosition asPosition 
]

{ #category : #navigation }
TxTextCursor >> moveToEnd [
	position := self text endPosition
]

{ #category : #navigation }
TxTextCursor >> moveToLineEnd [
	position := position moveToLineEnd
]

{ #category : #navigation }
TxTextCursor >> moveToLineStart [
	position := position moveToLineStart
]

{ #category : #navigation }
TxTextCursor >> moveToStart [
	position := self text startPosition
]

{ #category : #navigation }
TxTextCursor >> moveUp: number [
	position := position moveUp: number
]

{ #category : #accessing }
TxTextCursor >> nextPosition [
	"answer the position in text, which follows the receiver"
	^ position nextPosition
]

{ #category : #accessing }
TxTextCursor >> position [
	^ position
]

{ #category : #accessing }
TxTextCursor >> position: aTextPosition [
	position := aTextPosition
]

{ #category : #printing }
TxTextCursor >> printOn: aStream [

	"super printOn: aStream. "
	self isValid ifFalse: [ aStream nextPutAll: '**invalid cursor position**'. ^ self ].
	aStream 
		nextPutAll: 'cursor line: ';
		print: self lineNumber;
		nextPutAll: ' col: ';
		print: self linePosition 
		
]

{ #category : #accessing }
TxTextCursor >> span [
	^ position span
]

{ #category : #accessing }
TxTextCursor >> spanPosition [
	^ position spanPosition
]

{ #category : #accessing }
TxTextCursor >> text [
	^ position text
]
