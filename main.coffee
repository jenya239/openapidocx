fs =require 'fs'
{ Packer } =require 'docx'

main =
	init: ->#( @source, @target ) ->
		@target =process .argv .pop()
		@source =process .argv .pop()
		# console .log @source, @target
		# return
		rawdata =fs .readFileSync @source
		@json =JSON .parse rawdata
		@list =[]
		require( './app/processing' ) .create @json, 0, @list
		@builder =require( './app/builder' ) .create @
		#console .log @json

		Packer .toBuffer( @builder .doc ) .then ( buffer ) =>
			fs.writeFileSync @target, buffer

module .exports =main .init .bind main