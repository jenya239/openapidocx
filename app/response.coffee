
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'

module .exports =require( './factory' ) .define
	init: ( @method, @code, @data )->
		@list =@method .list