"
I organize attributes for a single text span.
I maintain the following invariant: a span can have any number of attributes, but only one per kind (e.g. foreground color, font, etc).
"
Class {
	#name : #TxStyle,
	#superclass : #Object,
	#instVars : [
		'attributes'
	],
	#category : #'TxText-Model'
}

{ #category : #comparing }
TxStyle >> = anAttributes [
	^ super = anAttributes or: [(anAttributes class == self class) and: [ attributes = anAttributes attributes ]]

]

{ #category : #accessing }
TxStyle >> add: aTxAttribute [ 
	attributes at: aTxAttribute class put: aTxAttribute 
]

{ #category : #accessing }
TxStyle >> add: anAttrabuteClass with: attributeValue [
	self add: (anAttrabuteClass with: attributeValue)
]

{ #category : #accessing }
TxStyle >> at: anAttributeClass [ 

	^ self at: anAttributeClass ifAbsent: nil
]

{ #category : #accessing }
TxStyle >> at: anAttributeClass ifAbsent: aBlock [

	^ (attributes at: anAttributeClass ifAbsent: aBlock)
]

{ #category : #accessing }
TxStyle >> at: anAttributeClass put: attributeValue [
	^ self add: (anAttributeClass with: attributeValue)
]

{ #category : #private }
TxStyle >> attributes [
	^ attributes
	
]

{ #category : #iterating }
TxStyle >> attributesDo: aBlock [

	attributes valuesDo: aBlock	
]

{ #category : #accessing }
TxStyle >> get: anAttributeClass [

	^ self get: anAttributeClass ifAbsent: [ anAttributeClass defaultValue ]
]

{ #category : #accessing }
TxStyle >> get: anAttributeClass ifAbsent: aBlock [

	^ (attributes at: anAttributeClass ifAbsent: aBlock) value
]

{ #category : #comparing }
TxStyle >> hash [

	^ (self species hash + attributes hash) hashMultiply 
]

{ #category : #testing }
TxStyle >> includes: anAttribute [
	"Note, we're testing an attribute value here.. the attribute set may already have 
	an attribute of same class, but it is important that it should match the attribute value as well,
	else receiver is not considered as one, which includes given attribute"
	^ ( attributes at: anAttribute class ifAbsent: [^false] ) = anAttribute
]

{ #category : #'initialize-release' }
TxStyle >> initialize [ 
	super initialize.
	
	attributes := IdentityDictionary new
]

{ #category : #testing }
TxStyle >> isEmpty [
	^ attributes isEmpty
]

{ #category : #copying }
TxStyle >> postCopy [
	
	attributes := attributes copy
]

{ #category : #accessing }
TxStyle >> removeAll [
	"Use with care"
	
	attributes removeAll.
]
