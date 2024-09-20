// Generated automatically by nearley, version undefined
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "MAIN", "symbols": ["NUMBER"]},
    {"name": "NUMBER$ebnf$1", "symbols": [/[0-9]/]},
    {"name": "NUMBER$ebnf$1", "symbols": [/[0-9]/, "NUMBER$ebnf$1"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "NUMBER", "symbols": ["NUMBER$ebnf$1"]},
    {"name": "NUMBER$ebnf$2", "symbols": [/[0-9]/]},
    {"name": "NUMBER$ebnf$2", "symbols": [/[0-9]/, "NUMBER$ebnf$2"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "NUMBER$ebnf$3", "symbols": [/[0-9]/]},
    {"name": "NUMBER$ebnf$3", "symbols": [/[0-9]/, "NUMBER$ebnf$3"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "NUMBER", "symbols": ["NUMBER$ebnf$2", {"literal":".","pos":25}, "NUMBER$ebnf$3"]},
    {"name": "NUMBER$ebnf$4", "symbols": [/[0-9]/]},
    {"name": "NUMBER$ebnf$4", "symbols": [/[0-9]/, "NUMBER$ebnf$4"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "NUMBER$ebnf$5", "symbols": [/[0-9]/]},
    {"name": "NUMBER$ebnf$5", "symbols": [/[0-9]/, "NUMBER$ebnf$5"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "NUMBER", "symbols": ["NUMBER$ebnf$4", {"literal":",","pos":35}, "NUMBER$ebnf$5"]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
