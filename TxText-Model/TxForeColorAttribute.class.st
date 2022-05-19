"
I represent the foreground color of a text span
"
Class {
	#name : #TxForeColorAttribute,
	#superclass : #TxAttribute,
	#category : #'TxText-Model'
}

{ #category : #defaults }
TxForeColorAttribute class >> defaultValue [ 
	^ Smalltalk ui theme textColor
]
