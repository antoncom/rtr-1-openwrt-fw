// Generated automatically by nearley, version undefined
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "MAIN", "symbols": ["NETMASK"]},
    {"name": "NETMASK", "symbols": ["net_mask"]},
    {"name": "NETMASK", "symbols": ["From_0_to_32"]},
    {"name": "net_mask", "symbols": ["From_0_to_255", {"literal":".","pos":29}, "From_0_to_255", {"literal":".","pos":33}, "From_0_to_255", {"literal":".","pos":37}, "From_0_to_255"]},
    {"name": "From_0_to_255", "symbols": [/[0-9]/]},
    {"name": "From_0_to_255", "symbols": [/[1-9]/, /[0-9]/]},
    {"name": "From_0_to_255", "symbols": [{"literal":"1","pos":59}, /[0-9]/, /[0-9]/]},
    {"name": "From_0_to_255", "symbols": [{"literal":"2","pos":69}, /[0-5]/, /[0-5]/]},
    {"name": "From_0_to_32", "symbols": [/[0-9]/]},
    {"name": "From_0_to_32", "symbols": [/[0-2]/, /[0-9]/]},
    {"name": "From_0_to_32", "symbols": [{"literal":"3","pos":95}, /[0-2]/]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
