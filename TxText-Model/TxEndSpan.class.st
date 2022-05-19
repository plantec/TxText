"
End span is span which _always_ last span of text and only one. 
So this span used to denote end of text.
"
Class {
	#name : #TxEndSpan,
	#superclass : #TxTerminalSpan,
	#category : #'TxText-Model'
}

{ #category : #visitor }
TxEndSpan >> accept: anObject [
	"visitor pattern"
	
	^ anObject visitEndSpan: self
]

{ #category : #copying }
TxEndSpan >> appendCopyTo: anotherText [
	"Create a copy of receiver and append it to the another text (at the end of it).
	Answer the copy"

	"End span cannot be copied, instead we just answer the existing end span of another text"
	^ anotherText endSpan
]

{ #category : #operation }
TxEndSpan >> at: aTxTextPosition insertSingleLine: aString [ 

	prev isCharacterSpan ifFalse: [
		self insertPrev: text newCharacterSpan 
		].
	
	^ prev at: prev endPosition insertSingleLine: aString 
]

{ #category : #operation }
TxEndSpan >> insertCharacters: chars at: position attributes: insertAttributes [
	
	"Insert characters (no line separators allowed!!!), with given attributes at given position in receiver.
	Answer the end position of inserted characters"
	
	"Since we cannot insert anything into end span, and its only valid position is zero,
	we either delegate to the previous character span, or create a new one, if none"
	
	| span |
	prev isCharacterSpan ifTrue: [
		^ prev insertCharacters: chars at: prev endPosition attributes: insertAttributes 
	].

	span := (text newCharacterSpan: chars) replaceAttributes: insertAttributes.
	self insertPrev: span.
	^ position
	
]

{ #category : #operation }
TxEndSpan >> insertLineSeparator: separator at: position [

	self insertPrev: separator.
	^ position
]

{ #category : #testing }
TxEndSpan >> isAtEnd [
	^ true
]

{ #category : #accessing }
TxEndSpan >> lineNumberAt: aTxTextPosition [
	"same as my previous span"
	^ prev lineNumberAt: prev endPosition
]

{ #category : #accessing }
TxEndSpan >> next: anObject [
	self error: 'End span cannot have next span!'
]

{ #category : #printing }
TxEndSpan >> printOn: aStream [
	 aStream nextPutAll: ' >>' 
]

{ #category : #operation }
TxEndSpan >> removeBefore: anIndex [

	self assert: anIndex = 0.
	^ self
]

{ #category : #'accessing-text position' }
TxEndSpan >> replaceAttributes: newAttributes [
	"replace receiver's attributes by copying from given one"
	^ self
]

{ #category : #accessing }
TxEndSpan >> style [
	"My attributes are always same as my previous span,
	unless text is empty, then it is default text attributes"
	
	^ text isEmpty
		ifTrue: [ text defaultStyle ]
		ifFalse: [ prev style ]
]
