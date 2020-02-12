fs =require 'fs'
{ Packer } =require 'docx'

main =
	init: ->#( @source, @target ) ->
		@source =process .argv .pop()
		rawdata =fs .readFileSync @source
		@json =JSON .parse rawdata
		console .log @json .tags
		# return
		# @list =[]
		# require( './app/processing' ) .create @json, 0, @list
		for tag in @json .tags
			@process_tag tag
	process_tag: ( tag )->
		builder =require( './app/builder' ) .create @json, tag .name
		Packer .toBuffer( builder .doc ) .then ( buffer ) =>
			fs.writeFileSync "api_#{ builder .tag }.docx", buffer

module .exports =main .init .bind main