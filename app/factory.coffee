module .exports =
	creator: ( args... )->
		res =Object .create @
		res .init args...
		res ._proto =@
		res
	define: ( schema )->
		schema .create =@creator
		schema .debug =console .log
		schema