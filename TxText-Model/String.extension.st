Extension { #name : #String }

{ #category : #'*TxText-Model' }
String >> asTxModel [
	^ TxModel fromString: self
]
