Class {
	#name : #TxSpanTestCase,
	#superclass : #TestCase,
	#instVars : [
		'span',
		'textModel'
	],
	#category : #'TxTextTests-Model'
}

{ #category : #testing }
TxSpanTestCase class >> isAbstract [ 
	^self == TxSpanTestCase
]

{ #category : #running }
TxSpanTestCase >> setUp [
	super setUp.
	textModel := TxModel new.
	
	span := self spanClass new.
	span text: textModel
]
