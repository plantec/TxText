"
I am separate property which can be applied to single text span.
The concerete meaning or purpose of property defined by my subclasses.
"
Class {
	#name : #TxAttribute,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'TxText-Model'
}

{ #category : #defaults }
TxAttribute class >> defaultValue [
	self subclassResponsibility
]

{ #category : #'instance creation' }
TxAttribute class >> with: valueObject [
	^self new 
		value: valueObject 
]

{ #category : #comparing }
TxAttribute >> = anObject [
	^  self species == anObject species and: [ value = anObject value ]
]

{ #category : #comparing }
TxAttribute >> hash [
	^ self species hash
]

{ #category : #accessing }
TxAttribute >> value [
	^ value
]

{ #category : #accessing }
TxAttribute >> value: anObject [
	value := anObject
]
