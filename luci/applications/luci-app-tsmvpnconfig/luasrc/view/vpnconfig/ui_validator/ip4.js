// Generated automatically by nearley, version undefined
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "MAIN", "symbols": ["IP"]},
    {"name": "IP", "symbols": ["NUMBER", {"literal":".","pos":19}, "NUMBER", {"literal":".","pos":23}, "NUMBER", {"literal":".","pos":27}, "NUMBER"]},
    {"name": "NUMBER", "symbols": ["From_0_to_255"]},
    {"name": "From_0_to_255", "symbols": [/[0-9]/]},
    {"name": "From_0_to_255", "symbols": [/[1-9]/, /[0-9]/]},
    {"name": "From_0_to_255", "symbols": [{"literal":"1","pos":55}, /[0-9]/, /[0-9]/]},
    {"name": "From_0_to_255", "symbols": [{"literal":"2","pos":65}, /[0-5]/, /[0-5]/]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
