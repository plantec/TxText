"
(ConfigurationOfTxText project version: '2.6') load: 'Tests'

ConfigurationOfTxText loadDevelopment

""last without Tool-TxWorkspace""
(ConfigurationOfTxText project version: '2.7') load.

""with Tool-TxWorkspace""
(ConfigurationOfTxText project version: '2.8') load.
"
Class {
	#name : #ConfigurationOfTxText,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfTxText
}

{ #category : #'development support' }
ConfigurationOfTxText class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfTxText class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfTxText class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfTxText class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfTxText class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfTxText class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfTxText class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfTxText class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project latestVersion: #development ) load
]

{ #category : #accessing }
ConfigurationOfTxText class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfTxText class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfTxText >> baseline01: spec [
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			package: 'TxText-Model';
			package: 'TxText-Layout' with: [
				spec requires: 'TxText-Model']; 
			package: 'TxText-UI' with: [
				spec requires: 'TxText-Layout'];
			package: 'TxTextTests-Model' with: [ 
				spec requires: 'TxText-Model' ];
			package: 'TxTextTests-Layout' with: [ 
				spec requires: 'TxText-Layout' ]
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline02: spec [
	<version: '0.2-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
			package: 'TxText-Model';
			package: 'TxText-Layout' with: [
				spec requires: 'TxText-Model']; 
			package: 'TxText-UI' with: [
				spec requires: 'TxText-Layout'];
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			package: 'TxTextTests-Layout' with: [ 
				spec requires: #('TxText-Layout' 'Mocketry default')].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('TxText-Model' 'TxText-Layout' 'TxText-UI');
			group: 'Tests' with: #('TxTextTests-Model' 'TxTextTests-Layout' 'Mocketry Tests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline03: spec [
	<version: '0.3-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
			package: 'TxText-Model';
			package: 'TxText-Layout' with: [
				spec requires: 'TxText-Model']; 
			package: 'TxText-Editor' with: [
				spec requires: 'TxText-Layout']; 
			package: 'TxText-UI' with: [
				spec requires: 'TxText-Editor'];
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			package: 'TxTextTests-Layout' with: [ 
				spec requires: #('TxText-Layout' 'Mocketry default')];
			package: 'TxTextTests-Editor' with: [ 
				spec requires: #('TxText-Editor' 'Mocketry default')].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('TxText-Model' 'TxText-Layout' 'TxText-UI');
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxTextTests-Layout' 'TxTextTests-Editor' 'Mocketry Tests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline04: spec [
	<version: '0.4-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  

			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
				
			package: 'StructuredEditor' with: [
				spec repository: 'http://www.smalltalkhub.com/mc/CamilleTeruel/StructuredEditor/main'
			]; 
				
				
			package: 'TxText-Model';
			package: 'TxText-Layout' with: [
				spec requires: 'TxText-Model']; 
			package: 'TxText-Editor' with: [
				spec requires: 'TxText-Layout']; 
			package: 'TxText-UI' with: [
				spec requires: 'TxText-Editor'];
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			package: 'TxTextTests-Layout' with: [ 
				spec requires: #('TxText-Layout' 'Mocketry default')];
			package: 'TxTextTests-Editor' with: [ 
				spec requires: #('TxText-Editor' 'Mocketry default')];
			
			package: 'TxText-Athens' with: [ spec requires: #('StructuredEditor') ];
			package: 'TxText-AthensTests' with: [ spec requires: #('TxText-Athens') ]
			
			.
			
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('TxText-Model' 'TxText-Layout' 'TxText-UI' 'TxText-Athens' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxTextTests-Layout' 'TxTextTests-Editor' 'Mocketry Tests' 'TxText-AthensTests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline05: spec [
	<version: '0.5-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  

			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
				
			package: 'StructuredEditor' with: [
				spec repository: 'http://www.smalltalkhub.com/mc/CamilleTeruel/StructuredEditor/main'
			]; 
				
				
			package: 'TxText-Model';
			package: 'TxText-OldLayout' with: [
				spec requires: 'TxText-Model']; 
			package: 'TxText-OldEditor' with: [
				spec requires: 'TxText-OldLayout']; 
			package: 'TxText-OldUI' with: [
				spec requires: 'TxText-OldEditor'];
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			package: 'TxTextTests-OldLayout' with: [ 
				spec requires: #('TxText-OldLayout' 'Mocketry default')];
			package: 'TxTextTests-OldEditor' with: [ 
				spec requires: #('TxText-OldEditor' 'Mocketry default')];
			
			package: 'TxText-Athens' with: [ spec requires: #('StructuredEditor') ];
			package: 'TxText-AthensTests' with: [ spec requires: #('TxText-Athens') ]
			
			.
			
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('TxText-Model' 'TxText-OldLayout' 'TxText-OldUI' 'TxText-Athens' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxTextTests-OldLayout' 'TxTextTests-OldEditor' 'Mocketry Tests' 'TxText-AthensTests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline06: spec [
	<version: '0.6-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
	
			project: 'Athens' with: [
			    spec 
				className: 'ConfigurationOfAthens';
				loads: 'default';
				repository: 'http://www.smalltalkhub.com/mc/Pharo/Athens/main'];  

			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
				
			package: 'StructuredEditor' with: [
				spec repository: 'http://www.smalltalkhub.com/mc/CamilleTeruel/StructuredEditor/main'
			]; 
				
				
			package: 'TxText-Model';
			package: 'TxText-OldLayout' with: [
				spec requires: 'TxText-Model']; 
			package: 'TxText-OldEditor' with: [
				spec requires: 'TxText-OldLayout']; 
			package: 'TxText-OldUI' with: [
				spec requires: 'TxText-OldEditor'];
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			package: 'TxTextTests-OldLayout' with: [ 
				spec requires: #('TxText-OldLayout' 'Mocketry default')];
			package: 'TxTextTests-OldEditor' with: [ 
				spec requires: #('TxText-OldEditor' 'Mocketry default')];
			
			package: 'TxText-Athens' with: [ spec requires: #('StructuredEditor') ];
			package: 'TxText-AthensTests' with: [ spec requires: #('TxText-Athens') ]
			
			.
			
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('TxText-Model' 'TxText-OldLayout' 'TxText-OldUI' 'TxText-Athens' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxTextTests-OldLayout' 'TxTextTests-OldEditor' 'Mocketry Tests' 'TxText-AthensTests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline07: spec [
	<version: '0.7-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
	
			project: 'Athens' with: [
			    spec 
				className: 'ConfigurationOfAthens';
				loads: 'default';
				repository: 'http://www.smalltalkhub.com/mc/Pharo/Athens/main'];  

			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
			
				
			package: 'TxText-Model';
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			
			
			package: 'TxText-Athens' with: [ spec requires: #('TxText-Model') ];
			package: 'TxText-AthensTests' with: [ spec requires: #('TxText-Athens') ].
			
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('TxText-Model' 'TxText-Athens' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'Mocketry Tests' 'TxText-AthensTests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline08: spec [
	<version: '0.8-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Mocketry default' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'default';
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
	
			project: 'Athens' with: [
			    spec 
				className: 'ConfigurationOfAthens';
				loads: 'default';
				repository: 'http://www.smalltalkhub.com/mc/Pharo/Athens/main'];  

			project: 'Mocketry Tests' with: [
		     		spec 
					className: 'ConfigurationOfMocketry';
					loads: 'Tests';					
					repository: 'http://www.smalltalkhub.com/mc/dionisiy/Mocketry/main'];  
			
				
			package: 'TxText-Model';
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model' 'Mocketry default' )];
			
			
			package: 'TxText-Athens' with: [ spec requires: #('TxText-Model') ];
			package: 'TxText-AthensTests' with: [ spec requires: #('TxText-Athens') ];
			package: 'TxText-Styler' with: [ spec requires: #('TxText-Athens') ].

			
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('TxText-Model' 'TxText-Athens' 'TxText-Styler' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'Mocketry Tests' 'TxText-AthensTests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline09: spec [
	<version: '0.9-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/sig/TxText/main'.
		spec 
			project: 'Athens' with: [
			    spec 
				className: 'ConfigurationOfAthens';
				loads: 'default';
				repository: 'http://www.smalltalkhub.com/mc/Pharo/Athens/main'];  

			package: 'TxText-Model';
			package: 'TxTextTests-Model' with: [ 
				spec requires: #('TxText-Model')];
			
			
			package: 'TxText-Athens' with: [ spec requires: #('TxText-Model') ];
			package: 'TxText-AthensTests' with: [ spec requires: #('TxText-Athens') ];
			package: 'TxText-Styler' with: [ spec requires: #('TxText-Athens') ].

			
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('TxText-Model' 'TxText-Athens' 'TxText-Styler' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxText-AthensTests'). 
			
	].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline101: spec [
	<version: '1.0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/Pharo/TxText/main'.
		spec description: 'Adding Tool-TxWorkspace'.
		spec 
			package: 'TxText-Model';
			package: 'TxTextTests-Model' 
				with: [ spec requires: #('TxText-Model')];
			package: 'TxText-Athens' 
				with: [ spec requires: #('TxText-Model') ];
			package: 'TxText-AthensTests' 
				with: [ spec requires: #('TxText-Athens') ];
			package: 'TxText-Styler' 
				with: [ spec requires: #('TxText-Athens') ];
			package: 'Tool-TxWorkspace' 
				with: [ spec requires: #('TxText-Athens' 'TxText-Styler') ].
		spec
			group: 'default' with: #('Core' 'Tests' 'Tools');
			group: 'Core' with: #('TxText-Model' 'TxText-Athens' 'TxText-Styler' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxText-AthensTests');
			group: 'Tools' with: #('Core' 'Tool-TxWorkspace') ].

]

{ #category : #baselines }
ConfigurationOfTxText >> baseline10: spec [
	<version: '1.0-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://www.smalltalkhub.com/mc/Pharo/TxText/main'.
		spec description: 'Adding Tool-TxWorkspace'.
		spec 
			project: 'Athens' with: [
			    spec 
				className: 'ConfigurationOfAthens';
				loads: 'default';
				repository: 'http://www.smalltalkhub.com/mc/Pharo/Athens/main'];  

			package: 'TxText-Model';
			package: 'TxTextTests-Model' 
				with: [ spec requires: #('TxText-Model')];
			package: 'TxText-Athens' 
				with: [ spec requires: #('TxText-Model') ];
			package: 'TxText-AthensTests' 
				with: [ spec requires: #('TxText-Athens') ];
			package: 'TxText-Styler' 
				with: [ spec requires: #('TxText-Athens') ];
			package: 'Tool-TxWorkspace' 
				with: [ spec requires: #('TxText-Athens' 'TxText-Styler') ].
		spec
			group: 'default' with: #('Core' 'Tests' 'Tools');
			group: 'Core' with: #('TxText-Model' 'TxText-Athens' 'TxText-Styler' );
			group: 'Tests' with: #('Core' 'TxTextTests-Model' 'TxText-AthensTests');
			group: 'Tools' with: #('Core' 'Tool-TxWorkspace'). 
	].

]

{ #category : #versions }
ConfigurationOfTxText >> bleedingVersion: spec [
	<version: 'bleeding' imports: #('0.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'bleedingEdge'.
		spec description: 'Bleeding edge of everything'.
		 
		spec
			project: 'Athens' with: '2.5';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #'symbolic versions' }
ConfigurationOfTxText >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.0.1-baseline'.

]

{ #category : #accessing }
ConfigurationOfTxText >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfTxText >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '2.13'.

]

{ #category : #versions }
ConfigurationOfTxText >> version01: spec [
	<version: '0.1' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'TxText is new text model system. It is possible replacement of old text editors stuff'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudryashov.1';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudryashov.1';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudryashov.1';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudryashov.1';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudryashov.1'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version02: spec [
	<version: '0.2' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'TxText is new text model system. It is possible replacement of old text editors stuff'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudryashov.2';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudryashov.2';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudryashov.2';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudryashov.2';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudryashov.2';
			project: 'Mocketry default' with: '2.1';
			project: 'Mocketry Tests' with: '2.1'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version03: spec [
	<version: '0.3' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'merge with Tristan work'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-TristanBourgois.3';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudryashov.3';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudryashov.3';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-TristanBourgois.3';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudryashov.3';
			project: 'Mocketry default' with: '2.1';
			project: 'Mocketry Tests' with: '2.1'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version04: spec [
	<version: '0.4' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'merge with Tristan work and layout cursor positioning'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudryashov.6';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudryashov.14';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudryashov.8';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudryashov.4';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudryashov.13';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version05: spec [
	<version: '0.5' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Cursor navigation refactored and improved'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.9';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.18';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.11';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.5';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.16';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version06: spec [
	<version: '0.6' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'edit and selection behaviour done. TxTextMorph live'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.19';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.27';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.21';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.9';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.19';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version07: spec [
	<version: '0.7' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Standart shortcuts for navigation and editing done.'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.22';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.31';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.25';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.12';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.21';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version08: spec [
	<version: '0.8' imports: #('0.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Edit decorators done'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.26';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.33';
			package: 'TxText-Editor' with: 'TxText-Editor-DenisKudrayshov.12';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.29';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.13';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.22';
			package: 'TxTextTests-Editor' with: 'TxTextTests-Editor-DenisKudrayshov.10';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version09: spec [
	<version: '0.9' imports: #('0.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Edit decorators renamings and new TxSecretEditDecorator'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.26';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.33';
			package: 'TxText-Editor' with: 'TxText-Editor-DenisKudrayshov.14';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.30';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.13';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.22';
			package: 'TxTextTests-Editor' with: 'TxTextTests-Editor-DenisKudrayshov.12';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version10: spec [
	<version: '1.0' imports: #('0.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Edit validation logic with text specs'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.27';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.33';
			package: 'TxText-Editor' with: 'TxText-Editor-DenisKudrayshov.17';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.33';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.14';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.22';
			package: 'TxTextTests-Editor' with: 'TxTextTests-Editor-DenisKudrayshov.15';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version11: spec [
	<version: '1.1' imports: #('0.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'TxTextMorph with halo menu items and correct transparent drawing'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-DenisKudrayshov.28';
			package: 'TxText-Layout' with: 'TxText-Layout-DenisKudrayshov.34';
			package: 'TxText-Editor' with: 'TxText-Editor-DenisKudrayshov.17';
			package: 'TxText-UI' with: 'TxText-UI-DenisKudrayshov.37';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-DenisKudrayshov.15';
			package: 'TxTextTests-Layout' with: 'TxTextTests-Layout-DenisKudrayshov.22';
			package: 'TxTextTests-Editor' with: 'TxTextTests-Editor-DenisKudrayshov.15';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version20: spec [
	<version: '2.0' imports: #('0.4-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'TxTextMorph with more recent workings'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.37';
		 
			package: 'TxText-UI' with: 'TxText-UI-IgorStasenko.39';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.20';


		 
 			package: 'StructuredEditor' with: 'StructuredEditor-CamilleTeruel.11';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.17';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.3';
			
			
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version210: spec [
	<version: '2.10' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Issue 15567 - TxText Cleanup for Pharo 5.0 #4
https://pharo.fogbugz.com/default.asp?15567
		
### This version:
- Update tests which were failing due to #selection -> #newSelection switch

### v. 1
#### Critics Browser - another pass, fix a bunch of rule violations
#### TxModel
- Move factory methods into a suitable protocol
    - Rename #cursor to #newCursor to be clear that it''s not *the* cursor, but *a* cursor
    - Simplify selecting protocol
        - Only keep #newSelection, which captures the concept the best because this is a different concept than what we think of as "select all" i.e. an editor has only-one selection; here we can have any number of selections which live independently of the text
        - Remove other methods, which all did the same thing as the above
- Remove unsent private methods

#### Other
- [ENH]: Clarify TxTextCursor comment'.
		spec author: 'SeanDeNigris'.
		spec timestamp: '5/21/2015 01:38'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.61';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-SeanDeNigris.50';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-SeanDeNigris.6';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-TorstenBergmann.5'. ].
]

{ #category : #versions }
ConfigurationOfTxText >> version211: spec [
	<version: '2.11' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'merge lates changes'.
		spec author: 'NicolaiHess'.
		spec timestamp: '2015-07-26T19:19:00.943441+02:00'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.61';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-NicolaiHess.51';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-ThomasHeniart.9';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].
]

{ #category : #versions }
ConfigurationOfTxText >> version2121: spec [
	<version: '2.12.1' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: '16122 TextLink positions are wrong
16121 TxTextStyler can not process RBSelfNode'.
		spec author: 'MarcusDenker'.
		spec timestamp: '10/8/2015 15:03'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.61';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-NicolaiHess.52';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-MarcusDenker.17';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version2122: spec [
	<version: '2.12.2' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: '16122 TextLink positions are wrong
16121 TxTextStyler can not process RBSelfNode'.
		spec author: 'MarcusDenker'.
		spec timestamp: '10/8/2015 15:03'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.61';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-GuillermoPolito.53';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-MarcusDenker.17';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version2123: spec [
	<version: '2.12.3' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'sync with Pharo package versions'.
		spec author: 'PavelKrivanek'.
		spec timestamp: '1/6/2016 11:05'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-EstebanLorenzano.63';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-GuillermoPolito.53';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-MarcusDenker.17';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version2124: spec [
	<version: '2.12.4' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'issue 18072'.
		spec author: 'PavelKrivanek'.
		spec timestamp: '6/13/2016 11:05'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-PavelKrivanek.65';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-GuillermoPolito.53';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-MarcusDenker.17';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version2125: spec [
	<version: '2.12.5' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Removes a Halt in TxModel >> #postCopy, because it only has a halt. Issue #18073'.
		spec author: 'PabloTesone'.
		spec timestamp: '24 June 2016, 12:20'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-PabloTesone.66';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-GuillermoPolito.53';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-MarcusDenker.17';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version2126: spec [
	<version: '2.12.6' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'merge'.
		spec author: 'MarcusDenker'.
		spec timestamp: '22 September 2016'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-MarcusDenker.67';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-EstebanLorenzano.58';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-HenrikNergaard.18';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version212: spec [
	<version: '2.12' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Load new TxText version
issue 16078:
collecting recent changes:
16047 TxTextStyler needs to implement visitGlobalNode:
15559 TxTextEditorMorph default behavior is unsafe'.
		spec author: 'NicolaiHess'.
		spec timestamp: '2015-08-06T23:54:57.550758+02:00'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.61';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-NicolaiHess.52';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-NicolaiHess.11';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].
]

{ #category : #versions }
ConfigurationOfTxText >> version213: spec [
	<version: '2.13' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Remove test classes which are not in use.'.
		spec author: 'HenrikNergaard'.
		spec timestamp: '10/29/2016 00:00'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-MarcusDenker.67';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.29';
			package: 'TxText-Athens' with: 'TxText-Athens-EstebanLorenzano.58';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-HenrikNergaard.13';
			package: 'TxText-Styler' with: 'TxText-Styler-HenrikNergaard.18';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-NicolaiHess.7'. ].

]

{ #category : #versions }
ConfigurationOfTxText >> version21: spec [
	<version: '2.1' imports: #('0.5-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'TxTextMorph with more recent workings'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.37';
		 
			package: 'TxText-OldUI' with: 'TxText-OldUI-IgorStasenko.1';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.20';


		 
 			package: 'StructuredEditor' with: 'StructuredEditor-CamilleTeruel.11';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.17';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.3';
			
			
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version22: spec [
	<version: '2.2' imports: #('0.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'TxTextMorph with more recent workings'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.38';
		 
			package: 'TxText-OldUI' with: 'TxText-OldUI-IgorStasenko.1';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.20';


		 
 			package: 'StructuredEditor' with: 'StructuredEditor-CamilleTeruel.11';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.18';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.3';
			
			project: 'Athens' with: '2.5';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version23: spec [
	<version: '2.3' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Removed unused stuff'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.41';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.20';
		 
 			package: 'StructuredEditor' with: 'StructuredEditor-CamilleTeruel.11';
			package: 'TxText-Athens' with: 'TxText-Athens-StephaneDucasse.31';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.7';
			
			project: 'Athens' with: '2.5';
			project: 'Mocketry default' with: '2.2';
			project: 'Mocketry Tests' with: '2.2'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version24: spec [
	<version: '2.4' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Removed unused stuff'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.45';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.21';
		 
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.33';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.8';
			
			project: 'Athens' with: '2.5';
			project: 'Mocketry default' with: '2.3';
			project: 'Mocketry Tests' with: '2.3'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version25: spec [
	<version: '2.5' imports: #('0.8-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'New text styler'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.46';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.22';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.34';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.8';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.2';
			
			project: 'Athens' with: '2.5';
			project: 'Mocketry default' with: '2.3';
			project: 'Mocketry Tests' with: '2.3'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version26: spec [
	<version: '2.6' imports: #('0.9-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'New baseline without mocketry'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.46';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.24';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.34';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.2';
			
			project: 'Athens' with: '2.5'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version27: spec [
	<version: '2.7' imports: #('0.9-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Update to fix character stream issues.'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.48';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.35';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.3';
			
			
			project: 'Athens' with: '2.5'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version281: spec [
	<version: '2.8.1' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec timestamp: '2014-12-08 16:52'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.48';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.35';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.3';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-IgorStasenko.3' ]
]

{ #category : #versions }
ConfigurationOfTxText >> version282: spec [
	<version: '2.8.2' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec timestamp: '2015-02-15 12:52'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-NicolaiHess.50';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-NicolaiHess.40';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.3';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-IgorStasenko.3' ]
]

{ #category : #versions }
ConfigurationOfTxText >> version283: spec [
	<version: '2.8.3' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec timestamp: '2015-02-18T00:08:11.856022+01:00'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-NicolaiHess.50';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-NicolaiHess.42';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.3';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-MarcusDenker.4' ]
]

{ #category : #versions }
ConfigurationOfTxText >> version284: spec [
	<version: '2.8.4' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Issue 15414: TxText Cleanup for Pharo 5.0 #1'.
		spec timestamp: '2015-04-27T17:23:16.32781+02:00'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.53';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-SeanDeNigris.46';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-SeanDeNigris.4';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-TorstenBergmann.5' ]
]

{ #category : #versions }
ConfigurationOfTxText >> version285: spec [
	<version: '2.8.5' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Issue 15475: TxText Cleanup for Pharo 5.0 #2
- TxXyzMorphs
	- Push up #openInWindowWithString:, #openInWindowWithText:, and #text, which each had two materially-identical implementations
	- Clean examples
- TxModel - enhance class comment
- TxStyle
	- Enhance class comment
	- Clean #removeAll comment
- TxTextStyle
	- Enhance class comment
	- Clean #addStyle: comment
	- Clean #extend:with: comment
- Apply some Lint Rules found while fixing validation warnings
	- https://ci.inria.fr/pharo/job/Pharo-5.0-Issue-Validator/1141//artifact/validationReport.html
	- https://ci.inria.fr/pharo/job/Pharo-5.0-Issue-Validator/1174//artifact/validationReport.html
	- https://ci.inria.fr/pharo/job/Pharo-5.0-Issue-Validator/1179//artifact/validationReport.html'.
		spec author: 'SeanDeNigris'.
		spec timestamp: '5/3/2015 13:38'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.57';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-SeanDeNigris.48';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
			package: 'TxText-Styler' with: 'TxText-Styler-SeanDeNigris.5';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-TorstenBergmann.5'. ].
]

{ #category : #versions }
ConfigurationOfTxText >> version28: spec [
	<version: '2.8' imports: #('1.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'Add TxWorkspace.'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-IgorStasenko.48';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-IgorStasenko.26';
			package: 'TxText-Athens' with: 'TxText-Athens-IgorStasenko.35';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-IgorStasenko.9';
		 	package: 'TxText-Styler' with: 'TxText-Styler-IgorStasenko.3';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-IgorStasenko.3';
			
			project: 'Athens' with: '2.5'
	].

]

{ #category : #versions }
ConfigurationOfTxText >> version29: spec [
	<version: '2.9' imports: #('1.0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Issue 15481: TxText Cleanup for Pharo 5.0 #3
https://pharo.fogbugz.com/default.asp?15481

### This version:
[Fix validator errors](https://ci.inria.fr/pharo/job/Pharo-5.0-Issue-Validator/1233/artifact/validationReport.html)
Nuke last usages of TxModel>>#getAttribute:
- Spans - if they don''t have a requested attribute, get it from the text''s default style
- Update tests

### Previous version
- [Clean]: many comments, typo fixes, etc
- [ENH]: Remove TxModel>>#getAttribute:, which makes no sense - you must ask a span or position for an attribute, not a text
- [ENH]: Rename TxModel>>#import: -> #replaceAllWith:'.
		spec author: 'SeanDeNigris'.
		spec timestamp: '5/4/2015 01:38'.
		spec 
			package: 'TxText-Model' with: 'TxText-Model-SeanDeNigris.59';
			package: 'TxTextTests-Model' with: 'TxTextTests-Model-SeanDeNigris.28';
			package: 'TxText-Athens' with: 'TxText-Athens-SeanDeNigris.49';
			package: 'TxText-AthensTests' with: 'TxText-AthensTests-SeanDeNigris.10';
			package: 'TxText-Styler' with: 'TxText-Styler-SeanDeNigris.5';
			package: 'Tool-TxWorkspace' with: 'Tool-TxWorkspace-TorstenBergmann.5'. ].
]
