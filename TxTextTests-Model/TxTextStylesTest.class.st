"
A TxTextStylesTest is a test class for testing the behavior of TxTextStyles
"
Class {
	#name : #TxTextStylesTest,
	#superclass : #TestCase,
	#instVars : [
		'text'
	],
	#category : #'TxTextTests-Model'
}

{ #category : #'as yet unclassified' }
TxTextStylesTest >> setUp [
	text := 'abc' asTxModel 
]

{ #category : #'as yet unclassified' }
TxTextStylesTest >> testAddingCopyOfSameStyleReturnsOriginalStyle [
	| style attribute result original copy |
	
	style := TxStyle new.
	attribute := TxForeColorAttribute with: Color red.
	style add: attribute.
	
	original := text addStyle: style.
	copy := original copy.
		
	result := text addStyle: copy.
	
	self assert: result == original
]

{ #category : #'as yet unclassified' }
TxTextStylesTest >> testAddingSameStyleTwice [
	| style attribute result |
	
	style := TxStyle new.
	attribute := TxForeColorAttribute with: Color red.
	style add: attribute.
	
	result := text addStyle: style.
	
	self assert: result == style
]
