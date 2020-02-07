module .exports =
	retrive: ( obj, ref )->
		ret =retriving .create obj, ref
		ret .obj
		# ref =ref .split '/'
		# ref .shift()
		# for i in ref
		# 	obj =obj[ i ]
		# obj #$ref

retriving =require( './factory' ) .define
	init: ( @obj, @ref )->
		@ref =@ref .split '/'
		@ref .shift()
		for i in @ref
			@obj =@obj[ i ]
		@obj #$ref