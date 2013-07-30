# Copyright 2011 TGen. All rights reserved.
# Author: Preston Lee <plee@tgen.org>

require_relative '../../test_helper'


class GrammarTest < Minitest::Test

	# Helper function for batch rule validation.
	def assert_rule_with_data(rule = 'statement', good, bad)
		good.each do |line|
			refute_nil @g.parse line, :root => rule
		end
		
		bad.each do |line|
			assert_raises(Citrus::ParseError) { @g.parse line, :root => rule }
		end
	end
	
	
	def setup
		# puts 'setup!!!!'
		@g = CortexIOGrammar
	end
	
  def test_grammar_loaded
    assert defined?(CortexIOGrammar), "Grammar was not preloaded!"
  end



	# create element set(i)={235, 452, 786} set(a)={"symbol"="BRCA1", "source"="ncbi"}
	# create attribute "type"="node"
	# create attribute {"type"="node", "source"="ncbi"}
	# modify element 456 set(x)={578}
	# modify element with {"symbol"="DLC1", "foo"="bar"} set(i)={345, 87, 673, 4829}
	# remove element 6574
	# remove element {157}
	# remove element {157, 239842, 23}
	# recover 9875
	# recover 1 {235, 9875, 98}
	# recover max {42}
	# context 1 with "type"="equivalence" and "chromosome"="14"
	# context max 345
	# expand 1 element with "symbol" = "BRC*"
	# expand 2 {578, 418}
	
	
	def test_context
		good = [
			'context 0 42',
			'context 1 1234',
			'context 42 12341234',
			'context 42 {}',
			'context 42 {1}',
			'context 42 {1,2}',
			'context 42 { 1 , 2 }', 
			'context max 42',
			'context max with "type" = "equivalence" and "chromosome"="14" ',
			'Context Max WITH ("type" = "equivalence" AND "chromosome"="14")',
			'  CONTEXT   MAX   WITH "type" = "equivalence" and ("foo"="bar" OR "chromosome"="14") ',
			]
		bad = [
			"context",
			"context 1 {,}",
			"context 1 aoeu",
			"context 1 with"
			]
		assert_rule_with_data('statement', good, bad)
	end
	
	def test_expand
		good = [
			'expand 0 42',
			'expand 1 1234',
			'expand 42 12341234',
			'expand max 42',
			'expand max with "type" = "equivalence" and "chromosome"="14" ',
			'Expand Max WITH ("type" = "equivalence" AND "chromosome"="14")',
			'  EXPAND   MAX   WITH "type" = "equivalence" and ("foo"="bar" OR "chromosome"="14") ',
			]
		bad = [
			"expand",
			"expand 1 {,}",
			"expand 1 aoeu",
			"expand 1 with"
		]
		assert_rule_with_data('statement', good, bad)
	end
	
	
	def test_create_attribute
		good = [
			'create attribute "type"="node"',
			'create attribute {"type"="node"}',
			'create attribute {"type"="node", "name"="bob"}',
			'create attribute {}',
			'   create      attribute {  }   ',
			'CREATE ATTRIBUTE {"type"="node", "name"="bob"}',
			'Create Attribute {"type"="node", "name"="bob"}',
			]
		bad = [
			'create attribute',
			'create attribute {,}',
			'create attribute {"bob"}',
			'create attribute {aoeu}',
			'create attribute {aoeu,}',
			'create attribute {, 1234}',
			'create attribute {1234 2345}'
			]
		assert_rule_with_data('statement', good, bad)
	end
	
	def test_create_element
		good = [
			'create element set(i)={235, 452, 786}',
			'create element set(e)={42}',
			'create element set(a)={"symbol"="BRCA1", "source"="ncbi"}',
			'create element set(i)={} set(a)={}',
			'create element SET(I)={235, 452, 786} SET(E)={42} SET(A)={"symbol"="BRCA1", "source"="ncbi"}',
			'  CREATE   ELEMENT set(e)={}',
			'Create ELEMENT set(a)={"type"="node", "name"="bob"}',
			]
		bad = [
			'create element',
			'create element {,}',
			'create element {"bob"}',
			'create element {aoeu}',
			'create element {aoeu,}',
			'create element {, 1234}',
			'create element {1234 2345}'
			]
		assert_rule_with_data('statement', good, bad)
	end
	
	def test_recover
		good = [
			'recover 1234',
			'recover 0 1234',
			'recover 42 1234',
			'recover max 1234',
			'recover {}',
			'recover {1234}',
			'recover   {1234, 1234}',
			' recover    {1234, 2345}  ',
			'    recover {1234, 2345 }',
			'RECOVER 1 { 1234,2345 }',
			"Recover 33 {\t 1234, 2345 }",
			"rEcOveR MAX {1234,    2345\t}"
			]
		bad = [
			'recover',
			'recover element {,}',
			'recover element {1234,}',
			'recover element {aoeu}',
			'recover element {aoeu,}',
			'recover element {, 1234}',
			'recover element {1234 2345}'
			]
		assert_rule_with_data('statement', good, bad)
	end

	def test_remove_element
		good = [
			"remove element 1234",
			"remove element {}",
			"remove element {1234}",
			"remove element   {1234, 1234}",
			" remove   element {1234, 2345}  ",
			"    remove element {1234, 2345 }",
			"REMOVE ELEMENT { 1234,2345 }",
			"Remove Element {\t 1234, 2345 }",
			"REmoVE ELEMent {1234,    2345\t}"
			]
		bad = [
			"remove",
			"remove element {,}",
			"remove element {1234,}",
			"remove element {aoeu}",
			"remove element {aoeu,}",
			"remove element {, 1234}",
			"remove element {1234 2345}"
			]
		assert_rule_with_data('statement', good, bad)
	end
	
	def test_uuid_set
		good = [
			"{}",
			"{1234}",
			"{1234, 2345}",
			"  {1234,2345}    ",
			"{1234, 2345, 3456}",
			]
		bad = [
			"",
			"1234",
			"{1234",
			"1234}",
			"{,}",
			"{1234}}",
			"{{1234}}",
			]
		assert_rule_with_data('uuid_set', good, bad)
	end
	
	def test_expression
		good = [
			'"name"="alice"',
			'"name" = "alice"',
			'"name" ="alice"',
			"\"name\"=\t\"alice\"",
			'("name"="alice")',
			'( ("name"="alice"))',
			'( "name" = "alice" )',
			'"name" = "alice" AND "type"="user"  ',
			'("name" = "alice" AND "type"="user")',
			'("name" = "alice") AND ("type"="user")',
			'"name" = "alice" AND ("type"="admin")',
			'"name" = "alice" AND ("type"="admin" or "type"="manager")',
			'("name" = "alice" OR "email"="alice@example.com") and ("type"="admin" or "type"="manager")',
			'(("name" = "alice" OR "email"="alice@example.com") and ("type"="admin" or "type"="manager"))',
			'( ( "name" = "alice" OR "email"="alice@example.com") and ("type"="admin" or "type"="manager" ) ) '
		]


		bad = [
			'name',
			'"name"',
			'"name" =',
			'"name"=',
			'("name" = "alice" AND "type"="user" ',
			'("name" = "alice" AND "type"="user") )'
		]
		assert_rule_with_data('expression', good, bad)
	end



	
end
