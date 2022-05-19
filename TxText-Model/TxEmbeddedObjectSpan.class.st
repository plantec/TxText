"
To place an embedded object into text
"
Class {
	#name : #TxEmbeddedObjectSpan,
	#superclass : #TxSpanWithStyle,
	#instVars : [
		'object'
	],
	#category : #'TxText-Model'
}

{ #category : #visitor }
TxEmbeddedObjectSpan >> accept: anObject [
	"visitor pattern"
	
	^ anObject visitEmbeddedObjectSpan: self
]

{ #category : #attributes }
TxEmbeddedObjectSpan >> applyAttribute: anAttribute from: startPosition to: endPosition [
	"do not apply only if start position is > 1 or end < 1"
	
	(startPosition span == self and: [ startPosition spanPosition > 0 ]) ifTrue: [ ^ self ].
	(endPosition span == self and: [ endPosition spanPosition = 0 ]) ifTrue: [ ^ self ].
	self applyAttribute: anAttribute.

]

{ #category : #'accessing-text position' }
TxEmbeddedObjectSpan >> endPosition [
	"answer the text position, pointing to the end of receiver"
	^ self positionAt: 1
]

{ #category : #'as yet unclassified' }
TxEmbeddedObjectSpan >> initWithText: aText [
	super initWithText: aText.
	"add a default style"
	self setStyle: TxStyle new.
]

{ #category : #operation }
TxEmbeddedObjectSpan >> insertCharacters: aString at: aTxTextPosition attributes: aTxAttributes [ 
	^ self next insertCharacters: aString at: self next startPosition attributes: aTxAttributes 
]

{ #category : #operation }
TxEmbeddedObjectSpan >> insertLineSeparator: separator at: position [ 

	position spanPosition > 0 ifTrue: [
		self insertNext: separator. 
		^ next endPosition ].
	
	self insertPrev: separator.
	^ self startPosition
]

{ #category : #accessing }
TxEmbeddedObjectSpan >> lineNumberAt: aTxTextPosition [ 
	^ self numberOfLinesBefore.
]

{ #category : #accessing }
TxEmbeddedObjectSpan >> object [
	^ object
]

{ #category : #accessing }
TxEmbeddedObjectSpan >> object: anObject [
	object := anObject
]

{ #category : #printing }
TxEmbeddedObjectSpan >> printContentsOn: aStream [ 
	aStream nextPut: $[; print: object; nextPut: $].
]

{ #category : #operation }
TxEmbeddedObjectSpan >> removeBefore: anIndex [
	anIndex = 1 ifTrue: [
			"remove ourselves"
			self delete.
	].

]

{ #category : #accessing }
TxEmbeddedObjectSpan >> size [
	^ 1
]

{ #category : #'accessing-text position' }
TxEmbeddedObjectSpan >> startPosition [
	^ self positionAt: 0
]
