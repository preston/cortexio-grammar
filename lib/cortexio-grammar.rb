require 'citrus'
Citrus.load File.join(File.dirname(__FILE__), 'cortexio-grammar', 'parse', 'grammar'), :force => true

module CortexIO
	module Grammar
	end
end