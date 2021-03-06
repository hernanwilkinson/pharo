Extension { #name : #Object }

{ #category : #'*UnifiedFFI' }
Object >> calloutAPIClass [
	^ self ffiLibrary calloutAPIClass
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCall: fnSpec [
	<ffiCalloutTranslator>
	
	self ffiCall: fnSpec library: self ffiLibrary
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCall: fnSpec library: aLibrary [
	<ffiCalloutTranslator>
	
	self ffiCall: fnSpec library: aLibrary options: #()
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCall: fnSpec library: aLibrary options: callOptions [
	<ffiCalloutTranslator>
	
	| ffiLibrary |
	ffiLibrary := aLibrary asFFILibrary.
	^ (ffiLibrary calloutAPIClass inUFFIContext: thisContext)
		convention: self ffiCallingConvention;
		options: (ffiLibrary options), callOptions;
		function: fnSpec library: ffiLibrary
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCall: fnSpec module: aModuleName [
	<ffiCalloutTranslator>
	
	self ffiCall: fnSpec library: aModuleName
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCall: fnSpec module: aModuleName options: callOptions [
	<ffiCalloutTranslator>
	
	self ffiCall: fnSpec library: aModuleName options: callOptions
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCall: fnSpec options: callOptions [
	<ffiCalloutTranslator>
	
	self ffiCall: fnSpec library: self ffiLibrary libraryName options: callOptions
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCallingConvention [
	^ OSPlatform current ffiCallingConvention
]

{ #category : #'*UnifiedFFI' }
Object >> ffiCalloutIn: aContext [
	"For backwards compatibility.
	It receives the context that is performing the ffi callout.
	This context will be used to know what method to compile and where to restart the execution"
	^ self calloutAPIClass inContext: aContext
]

{ #category : #'*UnifiedFFI' }
Object >> ffiLibrary [
		
	^ self ffiLibraryName asFFILibrary
]

{ #category : #'*UnifiedFFI' }
Object >> ffiLibraryName [
	self flag: 'HACK: avoid direct subclassResponsibility to not break RB test cases..'.
	^ SubclassResponsibility signalFor: thisContext selector
]

{ #category : #'*UnifiedFFI' }
Object >> isExternalType [
	^ false
]

{ #category : #'*UnifiedFFI' }
Object >> newCallbackWithSignature: signature block: aBlock [
	"This method is used to create a callback in the same library and callout api of the receiver"
	
	^ (self ffiCalloutIn: thisContext sender)
		convention: self ffiCallingConvention;
		newCallbackWithSignature: signature
			block: aBlock
			library: self ffiLibrary
]

{ #category : #'*UnifiedFFI' }
Object >> newCallbackWithSignature: signature block: aBlock library: aFFILibrary [
	"This method is used to create a callback in the callout api of the receiver"
	
	^ (self ffiCalloutIn: thisContext sender)
		convention: self ffiCallingConvention;
		newCallbackWithSignature: signature
			block: aBlock
			library: aFFILibrary
]

{ #category : #'*UnifiedFFI' }
Object >> packToArity: arity [
	"This will answer a pointer to this object. 
	 It is like doing ==var ptr=&aVariable== in C (up to arity). 
	
	 In general, arity>1 will not work because then object has to be copied to 
	 heap, but my overrides will handle this case"
	| rolledPointer |
		
	rolledPointer := self.
	1 to: arity do: [ :index | rolledPointer := rolledPointer pointer ].
	^ rolledPointer
]

{ #category : #'*UnifiedFFI' }
Object >> pointer [
	"Answers a pointer to me (see overrides for implementations)"
	self error: 'You cannot get a pointer to me.'
]
