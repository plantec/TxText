"
- this class need further revision. don't use
"
Class {
	#name : #TxPasswordSpan,
	#superclass : #TxCharacterSpan,
	#category : #'TxText-Model'
}

{ #category : #accessing }
TxPasswordSpan >> characters [

	^ String new: characters size withAll: $*
]
