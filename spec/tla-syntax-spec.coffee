describe 'SMT-LIB grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-tla-pluscal')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.tla')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.tla'

  describe "literals", ->
    it "tokenizes integer literals", ->
      {tokens} = grammar.tokenizeLine "1 = 5"
      expect(tokens[0]).toEqual value: '1', scopes: [ 'source.tla', 'constant.numeric.tla' ]
      expect(tokens[2]).toEqual value: '=', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[4]).toEqual value: '5', scopes: [ 'source.tla', 'constant.numeric.tla' ]

  describe "operators", ->
    it "tokenizes some operators correctly", ->
      {tokens} = grammar.tokenizeLine "x > 15 => x > 10"
      expect(tokens[0]).toEqual value: 'x', scopes: [ 'source.tla', 'identifier.tla' ]
      expect(tokens[2]).toEqual value: '>', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[4]).toEqual value: '15', scopes: [ 'source.tla', 'constant.numeric.tla' ]
      expect(tokens[6]).toEqual value: '=>', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[8]).toEqual value: 'x', scopes: [ 'source.tla', 'identifier.tla' ]
      expect(tokens[10]).toEqual value: '>', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[12]).toEqual value: '10', scopes: [ 'source.tla', 'constant.numeric.tla' ]
    it "tokenizes more operators correctly", ->
      {tokens} = grammar.tokenizeLine "[x \\in S |-> e]"
      expect(tokens[0]).toEqual value: '[', scopes: [ 'source.tla' ]
      expect(tokens[1]).toEqual value: 'x', scopes: [ 'source.tla', 'identifier.tla' ]
      expect(tokens[3]).toEqual value: '\\in', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[5]).toEqual value: 'S', scopes: [ 'source.tla', 'identifier.tla' ]
      expect(tokens[7]).toEqual value: '|->', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[9]).toEqual value: 'e', scopes: [ 'source.tla', 'identifier.tla' ]

      ###
      "[A -> B]"
      "(a + b) - 5 <= 3 * c"
      "a % b"
      "~ p \/ q"
      "p ^ q"
    it "tokenizes temporal operators correctly", ->
      "A -+-> B"
      "([] A) \/ (<> B)"
      ###

  describe "latex operators", ->
    it "colorizes latex operators correctly", ->
      {tokens} = grammar.tokenizeLine "ID == /\\ id2 \\in 1..7"
      expect(tokens[0]).toEqual value: 'ID', scopes: [ 'source.tla', 'identifier.tla' ]
      expect(tokens[2]).toEqual value: '==', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[4]).toEqual value: '/\\', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[6]).toEqual value: 'id2', scopes: [ 'source.tla', 'identifier.tla' ]
      expect(tokens[8]).toEqual value: '\\in', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[10]).toEqual value: '1', scopes: [ 'source.tla', 'constant.numeric.tla' ]
      expect(tokens[11]).toEqual value: '..', scopes: [ 'source.tla', 'keyword.operator.tla' ]
      expect(tokens[12]).toEqual value: '7', scopes: [ 'source.tla', 'constant.numeric.tla' ]

  describe "comments", ->
    it "tokenizes a comment", ->
      {tokens} = grammar.tokenizeLine '(* this is my comment *)'
      expect(tokens[0]).toEqual value: '(*', scopes: [ 'source.tla', 'comment.block.tla', 'punctuation.definition.comment.tla' ]
      expect(tokens[1]).toEqual value: ' this is my comment ', scopes: [ 'source.tla', 'comment.block.tla' ]
      expect(tokens[2]).toEqual value: '*)', scopes: [ 'source.tla', 'comment.block.tla', 'punctuation.definition.comment.tla' ]
