Object subclass: #Nim
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nim-C2NIM'!
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Nim class
	instanceVariableNames: ''!

!Nim class methodsFor: 'accessing' stamp: 'GoranKrampe 7/1/2020 10:46'!
process
	"self process"
	
	| s splits path fn content protected newPath |
	protected := #('Setup*', 'Init*', 'Exit*', 'Create*', 'CreateFromConfig*', 'Get*(zName: cstring').
	path := FileDirectory default fullPathFor: '../../src/norx/'.
	newPath := FileDirectory default fullPathFor: '../../src/norxnew/'.
	#(('AABox' 'AABox')
	('FPS' 'FPS')
	('FX' 'FX')
	('FXPointer' 'FXPointer')
	('OBox' 'OBox')
	('anim' 'Anim')
	('animPointer' 'AnimPointer')
	('animSet' 'AnimSet')
	('bank' 'Bank')
	('body' 'Body')
	('clock' 'Clock')
	('camera' 'Camera')
	('command' 'Command')
	('config' 'Config')
	('console' 'Console')
	('debug' 'Debug')
	('display' 'Display')
	('../norxnew/display' 'Color')
	('event' 'Event')
	('file' 'File')
	('font' 'Font')
	('frame' 'Frame')
	('graphic' 'Graphic')
	('hashTable' 'HashTable')
	('joystick' 'Joystick' ('IsConnected*'))
	('keyboard' 'Keyboard' ('Show*'))
	('linkList' 'LinkList')
	('locale' 'Locale')
	('math' 'Math')
	"('memory' 'Memory')"
	('module' 'Module')
	('mouse' 'Mouse')
	"('oinput' 'Input')"
	('oobject' 'Object')
	('param' 'Param')
	('physics' 'Physics')
	('plugin' 'Plugin')
	"('pluginCore' 'Plugin')"
	('profiler' 'Profiler')
	('render' 'Render')
	('resource' 'Resource')
	('screenshot' 'Screenshot')
	('shader' 'Shader')
	('shaderPointer' 'ShaderPointer')
	('sound' 'Sound')
	('soundPointer' 'SoundPointer')
	('soundSystem' 'SoundSystem')
	('spawner' 'Spawner')
	('string' 'String')
	('structure' 'Structure')
	('system' 'System')
	('text' 'Text')
	('texture' 'Texture')
	('thread' 'Thread' ('GetName*' 'Enable*' 'GetCurrent*' 'Join*' 'Start*'))
	('timeLine' 'TimeLine')
	('tree' 'Tree')
	"('vector' 'Vector')"
	('viewport' 'Viewport')
	) do: [ :pair | | prot |
			fn := pair first .
			prot := protected, ((pair size > 2) ifTrue: [pair last] ifFalse: [ #() ]).
			s := (StandardFileStream oldFileNamed: path, fn, '.nim') contents.
			splits := OrderedCollection new.
			s splitOn: 'proc orx', pair second, '_' do: [ :each | splits add: each ].
			content := String
				streamContents: [ :stream | | prev |
					prev := splits removeFirst.
					splits do: [ :e | | com commentAndCode |
						commentAndCode := Nim collectComment: prev.
						prev := commentAndCode second. com := commentAndCode first.
						stream nextPutAll: prev.
						prev := Nim insertComment: com in: e.
						(protected anySatisfy: [ :p | e beginsWith: p ]) ifTrue: [ | repl |
							repl := pair first.
							repl first = $o ifTrue: [ repl := repl copyWithoutFirst ].
							stream nextPutAll: 'proc ', repl ]
						ifFalse: [ 
							stream nextPutAll: 'proc '.
							prev := prev uncapitalized ].
					].
					stream nextPutAll: prev.
				].
				
			(StandardFileStream fileNamed: newPath , fn , '.nim')
				nextPutAll: content;
				close ]! !


!Nim class methodsFor: 'as yet unclassified' stamp: 'GoranKrampe 7/1/2020 10:33'!
insertComment: com in: code

	| first inline |
	first := true.
	inline := (code includesSubstring: 'cdecl.} =') & (code includesSubstring:  'libORX.}') not.
	
	^String streamContents: [ :s |
		inline ifTrue: [ 
			code splitOn: 'cdecl.} =' do: [:each |
				first ifTrue: [
					first := false.
					s nextPutAll: each, 'cdecl.} ='; lf; nextPutAll: com
				] ifFalse: [
					s nextPutAll: each
				]
			]
		] ifFalse: [ 
			code splitOn: 'libORX.}' do: [:each |
				first ifTrue: [
					first := false.
					s nextPutAll: each, 'libORX.}'; lf; nextPutAll: com; lf
				] ifFalse: [
					s nextPutAll: each
				]
			]
		]
		
	]
! !

!ByteString methodsFor: 'splitting' stamp: 'AI 4/17/2024 10:00'!
splitOn: aString do: aBlock
    "Split the receiver using aString as delimiter and evaluate aBlock with each substring.
     Example: 'a,b,c' splitOn: ',' do: [:each | Transcript show: each]"
    
    | start marker |
    start := 1.
    marker := aString size.
    
    (self findString: aString startingAt: 1) > 0 
        ifTrue: [
            [start <= self size] whileTrue: [
                | next |
                next := self findString: aString startingAt: start.
                next = 0 
                    ifTrue: [
                        "Process the final piece"
                        aBlock value: (self copyFrom: start to: self size).
                        start := self size + 1]
                    ifFalse: [
                        "Process the piece and continue"
                        aBlock value: (self copyFrom: start to: next - 1).
                        start := next + marker]]]
        ifFalse: [
            "No delimiter found, process the whole string"
            aBlock value: self]! ! 

!Nim class methodsFor: 'as yet unclassified' stamp: 'GoranKrampe 7/1/2020 01:41'!
collectComment: code
	"comment stating purpose of message"

	| clines  stripped lines commenting comment |
	clines := OrderedCollection new.
	stripped := OrderedCollection new.
	commenting := true.
	lines := code lines reversed.
	lines do: [ :l |
		(l beginsWith: '#') & commenting ifTrue: [
			commenting := true.
			clines add: l
		] ifFalse: [
			commenting & clines notEmpty ifTrue: [
				commenting := false.
			].
			stripped add: l
		]].
	clines := clines reversed select: [ :each | each ~= '##' ].
	clines := clines collect: [ :each | (each beginsWith: '## * ') ifTrue: [ '  ## ', (each copyFrom: 6 to: each size)] ifFalse: [ '  ', each ] ].
	comment := String lf join: clines.
	
	^{comment. String lf join: stripped reversed}! !

Nim process.
Smalltalk snapshot: false andQuit: true !