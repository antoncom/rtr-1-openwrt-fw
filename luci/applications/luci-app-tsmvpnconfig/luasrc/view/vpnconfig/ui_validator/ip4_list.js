// Generated automatically by nearley, version undefined
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "MAIN", "symbols": ["LIST"]},
    {"name": "LIST$ebnf$1", "symbols": []},
    {"name": "LIST$ebnf$1$subexpression$1", "symbols": ["DELIM", "IP"]},
    {"name": "LIST$ebnf$1", "symbols": ["LIST$ebnf$1$subexpression$1", "LIST$ebnf$1"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "LIST", "symbols": ["IP", "LIST$ebnf$1"]},
    {"name": "IP", "symbols": ["NUMBER", {"literal":".","pos":32}, "NUMBER", {"literal":".","pos":36}, "NUMBER", {"literal":".","pos":40}, "NUMBER"]},
    {"name": "NUMBER", "symbols": ["From_0_to_255"]},
    {"name": "From_0_to_255", "symbols": [/[0-9]/]},
    {"name": "From_0_to_255", "symbols": [/[1-9]/, /[0-9]/]},
    {"name": "From_0_to_255", "symbols": [{"literal":"1","pos":68}, /[0-9]/, /[0-9]/]},
    {"name": "From_0_to_255", "symbols": [{"literal":"2","pos":78}, /[0-5]/, /[0-5]/]},
    {"name": "DELIM$ebnf$1", "symbols": [/[, ]/]},
    {"name": "DELIM$ebnf$1", "symbols": [/[, ]/, "DELIM$ebnf$1"], "postprocess": function arrconcat(d) {return [d[0]].concat(d[1]);}},
    {"name": "DELIM", "symbols": ["DELIM$ebnf$1"]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
