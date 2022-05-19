Class {
	#name : #TxCharacterStreamTest,
	#superclass : #TestCase,
	#category : #'TxTextTests-Model'
}

{ #category : #tests }
TxCharacterStreamTest >> testBasicStuff [

	| text stream |
	text := 'asdf' asTxModel.
	stream := text characterStream.

	self assert: stream next equals: $a.
	self assert: stream next equals: $s.
	self assert: stream next equals: $d.
	self assert: stream next equals: $f.
	self assert: stream next equals: nil.
	self assert: stream next equals: nil.

	self assert: stream isAtEnd.
]

{ #category : #tests }
TxCharacterStreamTest >> testFreshInstanceDefaults [

	| text stream |
	
	text := 'asdf' asTxModel.
	stream := text characterStream.
	
	self assert: stream text == text.
	self assert: stream position isAtStart.
]
