"
I am the span which holds characters. Usually i am most often used span type (along with line separator).
"
Class {
	#name : #TxCharacterSpan,
	#superclass : #TxSpanWithStyle,
	#instVars : [
		'characters'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxCharacterSpan class >> text: aText [
	^ self text: aText characters: String empty
]

{ #category : #'instance creation' }
TxCharacterSpan class >> text: aText characters: aString [
	^ self new
		text: aText;
		characters: aString;
		yourself.
]

{ #category : #visitor }
TxCharacterSpan >> accept: anObject [
	"visitor pattern"
	
	^ anObject visitCharacterSpan: self
]

{ #category : #operation }
TxCharacterSpan >> applyAttribute: anAttribute from: startPosition to: endPosition [
	| splitStart splitEnd secondSpan |
	(style includes: anAttribute)
		ifTrue: [ ^ self ].
	splitStart := startPosition span == self
		ifTrue: [ startPosition spanPosition ]
		ifFalse: [ 0 ].
	splitEnd := endPosition span == self
		ifTrue: [ endPosition spanPosition ]
		ifFalse: [ self size ].
	secondSpan := splitStart > 0
		ifTrue: [ self splitAt: splitStart ]
		ifFalse: [ self ].
	splitEnd - splitStart < secondSpan size
		ifTrue: [ 
			secondSpan splitAt: splitEnd - splitStart.	"update the position"
			endPosition position: secondSpan endPosition ].
	secondSpan applyAttribute: anAttribute
]

{ #category : #printing }
TxCharacterSpan >> asStringOn: aStream [
	aStream nextPutAll: characters.
]

{ #category : #printing }
TxCharacterSpan >> asStringOn: aStream startingAt: index [
	self asStringOn: aStream startingAt: index upTo: characters size.
]

{ #category : #printing }
TxCharacterSpan >> asStringOn: aStream startingAt: startIndex upTo: endIndex [
	aStream nextPutAll: (characters copyFrom: startIndex + 1 to: endIndex).
]

{ #category : #printing }
TxCharacterSpan >> asStringOn: aStream upTo: index [
	self asStringOn: aStream startingAt: 0 upTo: index.
]

{ #category : #operation }
TxCharacterSpan >> at: aTxPosition insertSingleLine: aString [
	"Insert a single line character string at the given position,
	answer a new position pointing to the end of inserted string"
	| insertionEnd |
	insertionEnd := self size - aTxPosition spanPosition.
	characters := String new: self size + aString size streamContents: [ :s|
		s
			next: aTxPosition spanPosition putAll: characters; 
			nextPutAll: aString;
			next: insertionEnd putAll: characters startingAt: aTxPosition spanPosition + 1 ].
	
	^ self positionAt: aTxPosition spanPosition + aString size.
]

{ #category : #operations }
TxCharacterSpan >> canMerge: aCharacterSpan [
	^ self style = aCharacterSpan style.
]

{ #category : #accessing }
TxCharacterSpan >> characterBeforePosition: spanPosition ifNone: aBlock [

	"Answer character which is right before the position, located in receiver
	or evaluate a block if there's none"
	^ characters at: spanPosition ifAbsent: aBlock

]

{ #category : #accessing }
TxCharacterSpan >> characters [
	^ characters
]

{ #category : #accessing }
TxCharacterSpan >> characters: anObject [
	
	characters := anObject
]

{ #category : #operation }
TxCharacterSpan >> deleteUpTo: endPosition startingAt: startPosition [
	"Note, startPosition span == self" 
	
	self assert: startPosition span == self.
	
	endPosition span = self ifTrue: [
		"perform a local removal"
		self removeFrom: startPosition spanPosition to: endPosition spanPosition ]
	ifFalse: [
		self removeAfter: startPosition spanPosition.
		self next: endPosition span.
		self next removeBefore: endPosition spanPosition.
	].
	^ self tryMergeAndUpdatePosition: startPosition copy 
	

]

{ #category : #'accessing-text position' }
TxCharacterSpan >> endPosition [
	^ self positionAt: self lastInsertPosition
]

{ #category : #accessing }
TxCharacterSpan >> height [
	| font |
	font := self getAttribute: TxFontAttribute.
	^font height
]

{ #category : #'initialize-release' }
TxCharacterSpan >> initialize [ 

	super initialize.

	characters := String empty.
]

{ #category : #operation }
TxCharacterSpan >> insertCharacters: chars at: position attributes: insertAttributes [
	"Insert a single line character string at the given position,
	answer a new position pointing to the end of inserted string"

	| spanPos insertionEnd |

	spanPos := position spanPosition.
	
	style = insertAttributes ifFalse: [
		"going to create a separate character span, since attributes are incompatible"
		| newSpan |
		newSpan := (text newCharacterSpan: chars) replaceAttributes: insertAttributes.
		
		spanPos = 0 ifTrue: [
			self insertPrev: newSpan.
			^ self startPosition
			].
		
		spanPos < self size ifTrue: [ self splitAt: spanPos ].
			
		self insertNext: newSpan.
		^ newSpan endPosition.
	].
		
	"attributes are same, just insert characters"
 	insertionEnd := self size - spanPos.
	characters := String new: self size + chars size streamContents: [ :s|
		s
			next: spanPos putAll: characters; 
			nextPutAll: chars;
			next: insertionEnd putAll: characters startingAt: spanPos + 1 ].
	
	^ self positionAt: spanPos + chars size.
]

{ #category : #operation }
TxCharacterSpan >> insertLineSeparator: separator at: position [
	
	| spanPos |
	
	spanPos := position spanPosition.
	
	"at start"
	spanPos = 0 ifTrue: [
		self insertPrev: separator.
		^ position
		].
	
	"at end & middle"
	spanPos < self size ifTrue: [ self splitAt: spanPos ].
	
	self insertNext: separator.
	^ next endPosition
 
]

{ #category : #testing }
TxCharacterSpan >> isCharacterSpan [
	^ true
]

{ #category : #testing }
TxCharacterSpan >> isEmpty [
	^self size = 0
]

{ #category : #testing }
TxCharacterSpan >> isLastPosition: position [
	^ position = self size
]

{ #category : #accessing }
TxCharacterSpan >> lastInsertPosition [
	^ characters size 
]

{ #category : #accessing }
TxCharacterSpan >> lineNumberAt: aTxTextPosition [ 
	"i am not changing the number of lines"
	^ self numberOfLinesBefore.
]

{ #category : #actions }
TxCharacterSpan >> merge: aSpan [
	self characters: ((self characters), aSpan characters).
	"I'am at the end of the text"
	(self next  = self next next) ifTrue:[
			self next: self.
		]
	ifFalse:[
			self next: aSpan next.
		].
	
	
	
]

{ #category : #operations }
TxCharacterSpan >> mergeUpTo: aSpan [
	aSpan = self next
		ifTrue: [
			(self canMerge: self next) ifTrue: [
				self merge: self next.
				^ self ]
		ifFalse: [ ^ self next ] ].
	
	(self canMerge: self next) 
		ifTrue: [
			self merge: self next.
			^ self mergeUpTo: aSpan ]
		ifFalse: [ ^ self next mergeUpTo: aSpan ].
]

{ #category : #copying }
TxCharacterSpan >> postCopy [
	
	super postCopy.
	characters := characters copy.
]

{ #category : #printing }
TxCharacterSpan >> printContentsOn: aStream [
	aStream 
		nextPutAll: '"';
		nextPutAll: characters; 
		nextPutAll: '"'.
	
]

{ #category : #operation }
TxCharacterSpan >> removeAfter: anOffset [
	characters := characters first: anOffset.
	characters isEmpty ifTrue: [ self delete ]
]

{ #category : #operation }
TxCharacterSpan >> removeBefore: aSize [
	characters := characters allButFirst: aSize
]

{ #category : #private }
TxCharacterSpan >> removeFrom: start to: end [
	"remove all the characters in the given range. 
	Note that start is 0 based as it is the start point of the selection, left from the character"
	characters := characters copyReplaceFrom: (start + 1) to: end with: ''.
]

{ #category : #accessing }
TxCharacterSpan >> size [
	^ characters size
]

{ #category : #operation }
TxCharacterSpan >> splitAt: offset [
	| newSpan |
	characters ifEmpty: [ ^ self ].

	newSpan := text newCharacterSpan: (characters allButFirst: offset).
	characters := characters first: offset.
	"also inherit style"
	newSpan setStyle: self style.
	
	^ self insertNext: newSpan.
]

{ #category : #'accessing-text position' }
TxCharacterSpan >> startPosition [
	^ self positionAt: 0
]

{ #category : #operation }
TxCharacterSpan >> tryMergeAndUpdatePosition: position [

	"try to merge receiver with its neighbors, answer the updated position"
	
	"position is assumed to be inside of receiver"
	self assert: position span == self.
	
	self isEmpty ifTrue: [  
		self delete.
		^ prev endPosition ].
		
	^ position
]

{ #category : #operation }
TxCharacterSpan >> tryMergeWithNext [
	"Applicable only to character spans.
	
	Merge with next span, if it has same attributes"
	characters size isZero ifTrue: [ ^ self delete ].
	
	[ next isCharacterSpan ] whileTrue: [
	
		next style = self style ifTrue: [
			characters := characters , next characters.
			next delete
		] ifFalse: [ ^ self ]
	]

]

{ #category : #operation }
TxCharacterSpan >> tryMergeWithNextPreserving: selection [
	"Applicable only to character spans"
	
	"Merge with next span, if it has same attributes"
	characters size isZero ifTrue: [ ^ self delete ].
	
	[ next isCharacterSpan ] whileTrue: [
	
		next style = self style ifTrue: [
			characters := characters , next characters.
			
			"preserve the selection, while merging"
			selection start span == next ifTrue: [ 
				selection start: (self positionAt: (self size + selection start spanPosition))
				 ].
			
			selection end span == next ifTrue: [ 
				selection end: (self positionAt: (self size + selection end spanPosition))
				 ].

			next delete.
		] ifFalse: [ ^ self ]
	]

]
