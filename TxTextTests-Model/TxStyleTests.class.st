Class {
	#name : #TxStyleTests,
	#superclass : #TestCase,
	#instVars : [
		'style'
	],
	#category : #'TxTextTests-Model'
}

{ #category : #running }
TxStyleTests >> setUp [
	super setUp.
	
	style := TxStyle new
]

{ #category : #tests }
TxStyleTests >> testAddingAttribute [

	| attribute |
	attribute := TxFontAttribute new.
	
	style add: attribute.
	
	self assert: (style includes: attribute)
]

{ #category : #tests }
TxStyleTests >> testAddingAttributeWithValue [

	| actual |
	style add: TxFontAttribute with: #font.
	
	actual := style at: TxFontAttribute. 

	self assert: (actual value == #font)
]

{ #category : #tests }
TxStyleTests >> testGettingAbsentAttributeValue [

	| actual |
	
	style removeAll.
	
	actual := style at: TxFontAttribute ifAbsent: [#result].
	
	self assert: actual == #result
]

{ #category : #tests }
TxStyleTests >> testGettingExistedAttributeValue [

	| attribute actual |
	attribute := TxFontAttribute with: #font.
	
	style add: attribute.
	
	actual := style get: TxFontAttribute ifAbsent: nil.
	
	self assert: actual == #font
]

{ #category : #tests }
TxStyleTests >> testHasEmptyContentsByDefault [

	self assert: style isEmpty
]
