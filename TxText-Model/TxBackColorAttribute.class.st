"
I represent the background color of a text span
"
Class {
	#name : #TxBackColorAttribute,
	#superclass : #TxAttribute,
	#category : #'TxText-Model'
}

{ #category : #defaults }
TxBackColorAttribute class >> defaultValue [
	^ Smalltalk ui theme backgroundColor
]
