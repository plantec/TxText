"
I am an abstract class, representing a portion of text (span).
I form a double-linked list with my neighbour spans and our full list forms the contents of text.

Spans have a size and can have attributes. Size represents the number of positions within a span, which always =  size + 1.
For instance a character span with 2 characters 'AB' , can have 3 different positions:
 |AB
 A|B
 AB|
where '|' shows the position in the span and ranges from 0 to 2.
In this way TxTextPosition can navigate a span (using moveLeft/moveRight commands),
without actually needing to deal with strings, characters or anything else.
"
Class {
	#name : #TxBasicSpan,
	#superclass : #Object,
	#instVars : [
		'next',
		'prev',
		'text'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxBasicSpan class >> text: aTxModel [
	^ self new
		initWithText: aTxModel;
		yourself
]

{ #category : #testing }
TxBasicSpan >> < aSpan [
	"Answer whether the receiver is closer to the start of the text than than argument.
	NB: both spans must belong to the same text"
	
	| forward backward |
	
	text == aSpan text ifFalse: [ self error: 'Cannot compare positions belonging to different text' ].

	"equivalent case first"
	self == aSpan ifTrue: [  ^ false ].
	
	"go both ways: forward and backward.. and see where aSpan is relative to receiver"
	forward := backward := self.
	 [
		forward := forward next.
		backward := backward prev.
	
		forward == aSpan ifTrue: [ ^ true ].
		backward == aSpan ifTrue: [ ^ false ].
		
		"reached start"
		backward isAtStart ifTrue: [ ^ true ]. 
		"reached end"
		forward isAtEnd ifTrue: [ ^ false ].
		
	] repeat.
	
]

{ #category : #visitor }
TxBasicSpan >> accept: anObject [
	"visitor pattern"
	
	self subclassResponsibility 
]

{ #category : #copying }
TxBasicSpan >> appendCopyTo: anotherText [
	"Answer anotherText, with a copy of myself appended to it"
	
	self subclassResponsibility 
]

{ #category : #attributes }
TxBasicSpan >> applyAttribute: anAttribute [

	self subclassResponsibility 
]

{ #category : #attributes }
TxBasicSpan >> applyAttribute: anAttribute from: startPosition to: endPosition [
	
	"
	If startPosition does not point to the receiver, it means the start of the span covered by the attribute,
	if endPosition does not point to the receiver, it means the end of span covered by attribute.
	
	Else, they define a split point.
	
	4 cases: 
		- span already has given attribute (so do nothing )
		- start/end covers entire span (just add attribute)
		- split on 2 spans if start or end is at end of span 
		- split on 3 spans both start and end in the middle or span
	"

	
	self subclassResponsibility 
]

{ #category : #printing }
TxBasicSpan >> asStringOn: aStream [
	"specialize in subclasses	"
]

{ #category : #printing }
TxBasicSpan >> asStringOn: aStream startingAt: startIndex upTo: endIndex [
	"specialized in subclasses"
]

{ #category : #printing }
TxBasicSpan >> asStringOn: aStream upTo: index [
	self asStringOn: aStream startingAt: 0 upTo: index.
]

{ #category : #operation }
TxBasicSpan >> at: txPosition insert: aString [
	"
	Insert a possibly multi-line string at given position of receiver.
	Answer the position past the last character of inserted string.
	The inserted portion of text must have same attributes as insertion point.
	"

	| position first insertAttributes |
	position := txPosition.
	first := true.
	insertAttributes := self styleAtPosition: txPosition.

	self string: aString linesDo: [:chars |
		
		first 
			ifTrue: [ first := false. ]
			ifFalse: [ 
				| separator |
				separator := text newLineSeparator replaceAttributes: insertAttributes.
				position := position span insertLineSeparator: separator at: position ].

		chars ifNotEmpty: [
			position := position span insertCharacters: chars at: position attributes: insertAttributes
			]  
	].
	^ position
]

{ #category : #operation }
TxBasicSpan >> at: txPosition insertObject: anObject [

	| newSpan |
	
	newSpan := TxEmbeddedObjectSpan text: self text.
	newSpan object: anObject.
	
	txPosition isAtSpanStart 
		ifTrue: [ 
			self insertPrev: newSpan.
			^ txPosition ].
	txPosition isAtSpanEnd 
		ifTrue: [ 
			self insertNext: newSpan.
			^ self next endPosition ].
	
	"split & insert"
	self splitAt: txPosition spanPosition.
	self insertNext: newSpan.
	^ self next endPosition 	


]

{ #category : #accessing }
TxBasicSpan >> attributeAt: anAttributeClass [
	^ self style get: anAttributeClass
]

{ #category : #private }
TxBasicSpan >> basicNext: anObject [
	
	next := anObject
]

{ #category : #private }
TxBasicSpan >> basicPrev: anObject [
	
	prev := anObject
]

{ #category : #accessing }
TxBasicSpan >> characterBeforePosition: spanPosition ifNone: aBlock [

	"Answer character which is right before the position, located in receiver
	or evaluate a block if there's none"
	^ aBlock value
]

{ #category : #operation }
TxBasicSpan >> delete [
	"remove myself from the span list".
	prev next: next.
]

{ #category : #operation }
TxBasicSpan >> deleteUpTo: end startingAt: start [
	"start and end pointing to receiver, nothing to remove"
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

{ #category : #enumerating }
TxBasicSpan >> do: aBlock [
	| span |
	span := self.
	[ aBlock value: span. span := span nextIfNone: [ ^ self ] ] repeat.
]

{ #category : #'accessing-text position' }
TxBasicSpan >> endPosition [
	"answer the text position, pointing to the end of receiver"
	self subclassResponsibility
]

{ #category : #enumerating }
TxBasicSpan >> first [
	| span |
	span := self.
	[ span isAtStart ] whileFalse: [ span := span prev ].
	^ span
]

{ #category : #attributes }
TxBasicSpan >> getAttribute: anAttributeClass [

	^self style get: anAttributeClass ifAbsent: [ text defaultStyle get: anAttributeClass ] 
]

{ #category : #'initialize-release' }
TxBasicSpan >> initWithText: anObject [
	
	text := anObject
]

{ #category : #'initialize-release' }
TxBasicSpan >> initialize [
	next := prev := self
]

{ #category : #operation }
TxBasicSpan >> insertCharacters: chars at: position attributes: insertAttributes [

	"Insert characters (no line separators allowed!!!), with given attributes at given position into receiver.
	Answer the end position of inserted characters"

	
	self subclassResponsibility 
]

{ #category : #operation }
TxBasicSpan >> insertNewLine: aString [ 
	"Insert a newline then the String"
	| newline chars |
	newline := text newLineSeparator.
	aString isEmpty ifTrue: [ self insertNext: newline. ^ newline ].
	chars := text newCharacterSpan: aString.
	newline next: chars.
	self insertNext: newline.
	^ chars
]

{ #category : #accessing }
TxBasicSpan >> insertNext: aSpans [
	"insert new span(s) after receiver. "
	| oldNext |
	oldNext := next.
	aSpans prev: self.
	
	(oldNext == self)
		ifFalse: [ aSpans last next: oldNext ].

	^ aSpans
]

{ #category : #accessing }
TxBasicSpan >> insertPrev: aSpan [
	
	self isAtStart 
		ifFalse: [ aSpan prev: prev ].
	aSpan next: self.
	^ aSpan

]

{ #category : #testing }
TxBasicSpan >> isAtEnd [
	^ false
]

{ #category : #testing }
TxBasicSpan >> isAtLineEnd [
	^ self isAtEnd or: [ next isLineSeparator ]
]

{ #category : #testing }
TxBasicSpan >> isAtLineStart [
	^ self isAtStart or: [ self prev isLineSeparator ]
]

{ #category : #testing }
TxBasicSpan >> isAtLineStart: spanPosition [
	"just after the line start"
	^ spanPosition = 0 and: [ prev isLineSeparator ]
]

{ #category : #testing }
TxBasicSpan >> isAtStart [
	^ false
]

{ #category : #testing }
TxBasicSpan >> isCharacterSpan [
	^ false
]

{ #category : #testing }
TxBasicSpan >> isLastPosition: aNumber [
	^ false
]

{ #category : #testing }
TxBasicSpan >> isLineSeparator [
	^ false
]

{ #category : #enumerating }
TxBasicSpan >> last [
	| span |
	span := self.
	[ span next == span ] whileFalse: [ span := span next ].
	^ span
]

{ #category : #accessing }
TxBasicSpan >> lastInsertPosition [
	^ 0
]

{ #category : #accessing }
TxBasicSpan >> lineEndSpan [
	"Answer the last span in the same line as receiver" 
	self
		detect: [ :span | span isAtLineEnd ]
		ifFound: [ :span | ^ span ].
	Error signal: 'Should not happen'.
]

{ #category : #accessing }
TxBasicSpan >> lineNumber [
	| number |
	number := 1.
	text spansDo: [:span |
		span isLineSeparator ifTrue: [ number := number + 1].
		span == self ifTrue: [ ^ number ].
		].

	self error: 'cannot happen'
]

{ #category : #accessing }
TxBasicSpan >> lineNumberAt: aTxTextPosition [ 
	self subclassResponsibility.
]

{ #category : #accessing }
TxBasicSpan >> lineSize [
	^ self lineStartSpan sizeToLineEnd 
]

{ #category : #accessing }
TxBasicSpan >> lineStartSpan [
	" return the closest line start span "
	self reverseDo: [ :span | 
		span isAtLineStart ifTrue: [ ^ span ]].
	Error signal: 'Should not happen'.
]

{ #category : #accessing }
TxBasicSpan >> lineStartSpanIfNone: aBlock [
	self reverseDo: [ :span | 
		span isAtLineStart ifTrue: [ ^ span ]].
	^ aBlock value 
]

{ #category : #accessing }
TxBasicSpan >> next [
	
	^ next
]

{ #category : #accessing }
TxBasicSpan >> next: anObject [
	
	self basicNext: anObject.
	anObject basicPrev: self.
	^ anObject
]

{ #category : #accessing }
TxBasicSpan >> nextIfNone: aBlock [
	
	^ next == self ifTrue: [ aBlock value] ifFalse: [ next ]
]

{ #category : #operation }
TxBasicSpan >> nextLineIfNone: aBlock [
	| span |
	
	span := self lineEndSpan.
	span isAtEnd ifTrue: [ ^ aBlock value ].
	^ span next next
]

{ #category : #accessing }
TxBasicSpan >> nextLineSeparatorIfNone: aBlock [
	"Find a nearest line separator next to receiver or evaluate a block if none found"
	
	| span |
	span := self.
	[ span := span nextIfNone: aBlock. span isLineSeparator ] whileFalse.
	^ span
]

{ #category : #accessing }
TxBasicSpan >> numberOfLinesBefore [
	"Count the number of lines just before the receiver"
	| number |
	number := 1.
	text spansDo: [:span |
		span == self ifTrue: [ ^ number ].
		span isLineSeparator ifTrue: [ number := number + 1].
		].

	self error: 'cannot happen'
]

{ #category : #'accessing-text position' }
TxBasicSpan >> positionAt: characterIndex [
	^ TxTextPosition span: self spanPosition: characterIndex
]

{ #category : #accessing }
TxBasicSpan >> prev [
	
	^ prev
]

{ #category : #accessing }
TxBasicSpan >> prev: anObject [
	
	self basicPrev: anObject.
	anObject basicNext: self.
	^ anObject
]

{ #category : #accessing }
TxBasicSpan >> prevIfNone: aBlock [
	
	^ prev == self ifTrue: [ aBlock value] ifFalse: [ prev ]
]

{ #category : #printing }
TxBasicSpan >> printTextOn: aStream upTo: endSpan [ 
	self do: [ :eachSpan |
		
		eachSpan == endSpan ifTrue: [ ^self ].
		eachSpan asStringOn: aStream.			
		
	 ]

		
]

{ #category : #attributes }
TxBasicSpan >> replaceAttributes: newAttributes [
	"replace receiver's attributes by copying from given one"
	self subclassResponsibility 
]

{ #category : #enumerating }
TxBasicSpan >> reverseDo: aBlock [
	| span |
	span := self.
	
	[ aBlock value: span. span := span prevIfNone: [ ^ self ] ] repeat
]

{ #category : #accessing }
TxBasicSpan >> sizeToLineEnd [
	| size |
	size := 0.
	self do: [ :span| 
		size := size + span size.
		span isAtLineEnd ifTrue: [ ^ size ]].
	Error signal: 'Should not happen!'.
]

{ #category : #enumerating }
TxBasicSpan >> spanAndPositionDo:  aBlock [
	| position |
	position := 0.
	self do: [ :span|
		aBlock value: span value: position.
		position := position + span size ]
]

{ #category : #private }
TxBasicSpan >> splitLinesOf: aString [


	| lines |
	
	lines := OrderedCollection new.
	self string: aString linesDo: [:line | lines add: line ].

	^ lines
]

{ #category : #'accessing-text position' }
TxBasicSpan >> startPosition [
	"answer the text position, pointing to the start of receiver"
	self subclassResponsibility
]

{ #category : #private }
TxBasicSpan >> string: aString linesDo: aBlock [

	| stream cr current|
	
	stream := aString readStream.
	current := String new writeStream.
	cr := Character cr.
	
	[ stream atEnd ] whileFalse: [ | c |
		(c := stream next) == cr ifTrue: [
			aBlock value: current contents.
			current := String new writeStream ]
		ifFalse: [ current nextPut: c ]
	].
	aBlock value: current contents
]

{ #category : #accessing }
TxBasicSpan >> style [
	^ self subclassResponsibility
]

{ #category : #accessing }
TxBasicSpan >> styleAtPosition: txPosition [ 

	"The receiver's attributes is defined for the next line,
	however a text position pointing to beginning of receiver is formally an insertion point belonging
	to previous line, therefore we must use previous span attributes"
	
	^ self style
]

{ #category : #accessing }
TxBasicSpan >> text [
	
	^ text
]

{ #category : #accessing }
TxBasicSpan >> text: aTxModel [
	text := aTxModel.
]

{ #category : #operation }
TxBasicSpan >> tryMergeWithNext [
	"Applicable only to character spans"
	^ self
]

{ #category : #operation }
TxBasicSpan >> tryMergeWithNextPreserving: selection [
	"Applicable only to character spans"
	^ self
]
