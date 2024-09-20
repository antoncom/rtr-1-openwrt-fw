// Generated automatically by nearley, version undefined
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "MAIN", "symbols": ["URL"]},
    {"name": "URL$ebnf$1", "symbols": []},
    {"name": "URL$ebnf$1$subexpression$1", "symbols": [{"literal":".","pos":20}, "DOMAIN"]},
    {"name": "URL$ebnf$1", "symbols": ["URL$ebnf$1$subexpression$1", "URL$ebnf$1"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "URL", "symbols": ["DOMAIN", "URL$ebnf$1"]},
    {"name": "DOMAIN$ebnf$1$subexpression$1", "symbols": ["LETTER"]},
    {"name": "DOMAIN$ebnf$1$subexpression$1", "symbols": ["NUMBER"]},
    {"name": "DOMAIN$ebnf$1$subexpression$1", "symbols": ["SYMBOL"]},
    {"name": "DOMAIN$ebnf$1", "symbols": ["DOMAIN$ebnf$1$subexpression$1"]},
    {"name": "DOMAIN$ebnf$1$subexpression$2", "symbols": ["LETTER"]},
    {"name": "DOMAIN$ebnf$1$subexpression$2", "symbols": ["NUMBER"]},
    {"name": "DOMAIN$ebnf$1$subexpression$2", "symbols": ["SYMBOL"]},
    {"name": "DOMAIN$ebnf$1", "symbols": ["DOMAIN$ebnf$1$subexpression$2", "DOMAIN$ebnf$1"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "DOMAIN", "symbols": ["DOMAIN$ebnf$1"]},
    {"name": "LETTER", "symbols": [/[a-zA-Z]/]},
    {"name": "NUMBER", "symbols": [/[0-9]/]},
    {"name": "SYMBOL", "symbols": [/[_\-%/:?&=]/]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
