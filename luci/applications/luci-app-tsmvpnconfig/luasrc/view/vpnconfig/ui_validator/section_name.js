// Generated automatically by nearley, version undefined
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "MAIN", "symbols": ["NAME"]},
    {"name": "NAME$ebnf$1$subexpression$1", "symbols": ["LETTER"]},
    {"name": "NAME$ebnf$1$subexpression$1", "symbols": ["NUMBER"]},
    {"name": "NAME$ebnf$1$subexpression$1", "symbols": ["SYMBOL"]},
    {"name": "NAME$ebnf$1", "symbols": ["NAME$ebnf$1$subexpression$1"]},
    {"name": "NAME$ebnf$1$subexpression$2", "symbols": ["LETTER"]},
    {"name": "NAME$ebnf$1$subexpression$2", "symbols": ["NUMBER"]},
    {"name": "NAME$ebnf$1$subexpression$2", "symbols": ["SYMBOL"]},
    {"name": "NAME$ebnf$1", "symbols": ["NAME$ebnf$1$subexpression$2", "NAME$ebnf$1"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "NAME", "symbols": ["NAME$ebnf$1"]},
    {"name": "LETTER", "symbols": [/[a-zA-Z]/]},
    {"name": "NUMBER", "symbols": [/[0-9]/]},
    {"name": "SYMBOL", "symbols": [/[_]/]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
