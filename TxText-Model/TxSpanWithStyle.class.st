"
i am common ancestor of spans which can carry separate (own) list of attributes.
"
Class {
	#name : #TxSpanWithStyle,
	#superclass : #TxBasicSpan,
	#instVars : [
		'style'
	],
	#category : #'TxText-Model'
}

{ #category : #copying }
TxSpanWithStyle >> appendCopyTo: anotherText [

	"Create a copy of receiver and append it to the another text (at the end of it).
	Answer the copy"

	| copy |
	
	copy := self copy.
	
	copy 
		text: anotherText;
		basicNext: copy.
	
	anotherText endSpan prev insertNext: copy.
	
	^ copy
	
]

{ #category : #operation }
TxSpanWithStyle >> applyAttribute: anAttribute [
	"Apply attribute to whole receiver"
	style := self text styles extend: style with: anAttribute.

]

{ #category : #copying }
TxSpanWithStyle >> postCopy [

	style := style copy.	

]

{ #category : #printing }
TxSpanWithStyle >> printContentsOn: aStream [
]

{ #category : #printing }
TxSpanWithStyle >> printOn: aStream [
	self printContentsOn: aStream.
]

{ #category : #accessing }
TxSpanWithStyle >> replaceAttributes: newAttributes [
	"replace receiver's attributes by copying from given one"
	style := newAttributes copy.
]

{ #category : #accessing }
TxSpanWithStyle >> setStyle: aStyle [

	style := text styles addStyle: aStyle.
]

{ #category : #accessing }
TxSpanWithStyle >> style [
	^ style
]

{ #category : #accessing }
TxSpanWithStyle >> text: aTxModel [

	super text: aTxModel.
	
	style := text defaultStyle.
]
