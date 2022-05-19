"
I represent the font of a text span
"
Class {
	#name : #TxFontAttribute,
	#superclass : #TxAttribute,
	#category : #'TxText-Model'
}

{ #category : #defaults }
TxFontAttribute class >> defaultValue [ 
	| font |
	
	font := TextStyle defaultFont. 
	
	(font isKindOf: StrikeFont) ifTrue: [ 
		"no strike fonts please"
"		^  LogicalFont familyName: 'Verdana' pointSize: 12. "
		
		^  LogicalFont familyName: 'Helvetica' pointSize: 12. 
		 ].
	^ font
]

{ #category : #'instance creation' }
TxFontAttribute class >> fontNamed: aFamilyName size: pointSize [

	^  self new value: (LogicalFont familyName: aFamilyName pointSize: pointSize )
]
