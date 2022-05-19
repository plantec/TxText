Class {
	#name : #TxCharacterSpanTests,
	#superclass : #TxSpanTestCase,
	#category : #'TxTextTests-Model'
}

{ #category : #accessing }
TxCharacterSpanTests >> spanClass [
	^TxCharacterSpan 
]

{ #category : #tests }
TxCharacterSpanTests >> testGettingAbsentAttribute [

	| actual |

	textModel := TxModel new.
	textModel defaultStyle at: TxFontAttribute put: #mockValue.
	span text: textModel.
	
	actual := span getAttribute: TxFontAttribute.
	
	self assert: actual equals: #mockValue
]

{ #category : #tests }
TxCharacterSpanTests >> testGettingExistedAttribute [

	|  actual |
	
	span style add: TxFontAttribute with: #font.
	
	actual := span getAttribute: TxFontAttribute.
	
	self assert: actual == #font
	
]
