package com.animenight.rantlite 
{
	/**
	 * ...
	 * @author Andrew Rogers
	 */
	public class RantGrammar 
	{
		public function parse(input) {
			var options = arguments.length > 1 ? arguments[1] : {},

				peg$FAILED = {},

				peg$startRuleFunctions = { rant: peg$parserant },
				peg$startRuleFunction  = peg$parserant,

				peg$c0 = [],
				peg$c1 = peg$FAILED,
				peg$c2 = null,
				peg$c3 = function(t, s) { return { type: 'text', value: t.join('') + (s ? ' ' : '') } },
				peg$c4 = function() { return ' '; },
				peg$c5 = "{",
				peg$c6 = { type: "literal", value: "{", description: "\"{\"" },
				peg$c7 = "|",
				peg$c8 = { type: "literal", value: "|", description: "\"|\"" },
				peg$c9 = "}",
				peg$c10 = { type: "literal", value: "}", description: "\"}\"" },
				peg$c11 = function(first_weight, first_item, rest) {
						var items = [ first_item ];
						var weights = [first_weight !== null ? first_weight : 1];
						items = items.concat(rest.map(function(r,_,__) { weights.push(r[2] || 1); return r[r.length - 1]; }));
						return {
							type: 'block',
							items: items,
							weights: weights
						};
					},
				peg$c12 = function(weight, item) {
						return {
							type: 'block',
							items: [ item ],
							weights: [ weight === null ? 1 : weight ]
						};
					},
				peg$c13 = "(",
				peg$c14 = { type: "literal", value: "(", description: "\"(\"" },
				peg$c15 = ")",
				peg$c16 = { type: "literal", value: ")", description: "\")\"" },
				peg$c17 = function(w) { return w.value; },
				peg$c18 = function(q, s) { return [q, s]; },
				peg$c19 = function(b, s) { return [b, s]; },
				peg$c20 = function(f, s) { return [f, s]; },
				peg$c21 = function(a, s) { return {type: 'text', value: a.join('') + (s ? s.join('') : '') }; },
				peg$c22 = "<",
				peg$c23 = { type: "literal", value: "<", description: "\"<\"" },
				peg$c24 = /^[.]/,
				peg$c25 = { type: "class", value: "[.]", description: "[.]" },
				peg$c26 = /^[\-]/,
				peg$c27 = { type: "class", value: "[\\-]", description: "[\\-]" },
				peg$c28 = ">",
				peg$c29 = { type: "literal", value: ">", description: "\">\"" },
				peg$c30 = function(name, subtype, classes) { 
							var cs = classes.map(function(c,_,__) { return c[1].join(''); });
							var s = (subtype ? subtype[1].join('') : '');
							return { 
								type: 'query', name: name.join(''), subtype: s, classes: cs
							}; 
						},
				peg$c31 = /^[0-9]/,
				peg$c32 = { type: "class", value: "[0-9]", description: "[0-9]" },
				peg$c33 = function(n) { 
							var number = n[0].join('') + (n[1] ? '.' + n[1][1].join('') : '');
							return { 
								type: 'number',
								value: parseFloat(number)
							} 
						},
				peg$c34 = "[",
				peg$c35 = { type: "literal", value: "[", description: "\"[\"" },
				peg$c36 = ":",
				peg$c37 = { type: "literal", value: ":", description: "\":\"" },
				peg$c38 = "]",
				peg$c39 = { type: "literal", value: "]", description: "\"]\"" },
				peg$c40 = function(name, args) { 

						if(args == null) args = [];
						else args = args[1];
						return {
							type: 'function',
							name: name.join(''),
							args: args
						};
					},
				peg$c41 = ";",
				peg$c42 = { type: "literal", value: ";", description: "\";\"" },
				peg$c43 = function(value) { return value[0].join(''); },
				peg$c44 = function() { return 'query'; },
				peg$c45 = /^[A-Za-z0-9]/,
				peg$c46 = { type: "class", value: "[A-Za-z0-9]", description: "[A-Za-z0-9]" },
				peg$c47 = /^[A-Za-z0-9!:;,\-.?'"$%&*]/,
				peg$c48 = { type: "class", value: "[A-Za-z0-9!:;,\\-.?'\"$%&*]", description: "[A-Za-z0-9!:;,\\-.?'\"$%&*]" },
				peg$c49 = /^[ \n\t\r]/,
				peg$c50 = { type: "class", value: "[ \\n\\t\\r]", description: "[ \\n\\t\\r]" },

				peg$currPos          = 0,
				peg$reportedPos      = 0,
				peg$cachedPos        = 0,
				peg$cachedPosDetails = { line: 1, column: 1, seenCR: false },
				peg$maxFailPos       = 0,
				peg$maxFailExpected  = [],
				peg$silentFails      = 0,

				peg$result;

			if ("startRule" in options) {
				if (!(options.startRule in peg$startRuleFunctions)) {
				throw new Error("Can't start parsing from rule \"" + options.startRule + "\".");
				}

				peg$startRuleFunction = peg$startRuleFunctions[options.startRule];
			}

			function text() {
				return input.substring(peg$reportedPos, peg$currPos);
			}

			function offset() {
				return peg$reportedPos;
			}

			function line() {
				return peg$computePosDetails(peg$reportedPos).line;
			}

			function column() {
				return peg$computePosDetails(peg$reportedPos).column;
			}

			function expected(description) {
				throw peg$buildException(
				null,
				[{ type: "other", description: description }],
				peg$reportedPos
				);
			}

			function error(message) {
				throw peg$buildException(message, null, peg$reportedPos);
			}

			function peg$computePosDetails(pos) {
				function advance(details, startPos, endPos) {
				var p, ch;

				for (p = startPos; p < endPos; p++) {
					ch = input.charAt(p);
					if (ch === "\n") {
					if (!details.seenCR) { details.line++; }
					details.column = 1;
					details.seenCR = false;
					} else if (ch === "\r" || ch === "\u2028" || ch === "\u2029") {
					details.line++;
					details.column = 1;
					details.seenCR = true;
					} else {
					details.column++;
					details.seenCR = false;
					}
				}
				}

				if (peg$cachedPos !== pos) {
				if (peg$cachedPos > pos) {
					peg$cachedPos = 0;
					peg$cachedPosDetails = { line: 1, column: 1, seenCR: false };
				}
				advance(peg$cachedPosDetails, peg$cachedPos, pos);
				peg$cachedPos = pos;
				}

				return peg$cachedPosDetails;
			}

			function peg$fail(expected) {
				if (peg$currPos < peg$maxFailPos) { return; }

				if (peg$currPos > peg$maxFailPos) {
				peg$maxFailPos = peg$currPos;
				peg$maxFailExpected = [];
				}

				peg$maxFailExpected.push(expected);
			}

			function peg$buildException(message, expected, pos) {
				function cleanupExpected(expected) {
				var i = 1;

				expected.sort(function(a, b) {
					if (a.description < b.description) {
					return -1;
					} else if (a.description > b.description) {
					return 1;
					} else {
					return 0;
					}
				});

				while (i < expected.length) {
					if (expected[i - 1] === expected[i]) {
					expected.splice(i, 1);
					} else {
					i++;
					}
				}
				}

				function buildMessage(expected, found) {
				function stringEscape(s) {
					function hex(ch) { return ch.charCodeAt(0).toString(16).toUpperCase(); }

					return s
					.replace(/\\/g,   '\\\\')
					.replace(/"/g,    '\\"')
					.replace(/\x08/g, '\\b')
					.replace(/\t/g,   '\\t')
					.replace(/\n/g,   '\\n')
					.replace(/\f/g,   '\\f')
					.replace(/\r/g,   '\\r')
					.replace(/[\x00-\x07\x0B\x0E\x0F]/g, function(ch) { return '\\x0' + hex(ch); })
					.replace(/[\x10-\x1F\x80-\xFF]/g,    function(ch) { return '\\x'  + hex(ch); })
					.replace(/[\u0180-\u0FFF]/g,         function(ch) { return '\\u0' + hex(ch); })
					.replace(/[\u1080-\uFFFF]/g,         function(ch) { return '\\u'  + hex(ch); });
				}

				var expectedDescs = new Array(expected.length),
					expectedDesc, foundDesc, i;

				for (i = 0; i < expected.length; i++) {
					expectedDescs[i] = expected[i].description;
				}

				expectedDesc = expected.length > 1
					? expectedDescs.slice(0, -1).join(", ")
						+ " or "
						+ expectedDescs[expected.length - 1]
					: expectedDescs[0];

				foundDesc = found ? "\"" + stringEscape(found) + "\"" : "end of input";

				return "Expected " + expectedDesc + " but " + foundDesc + " found.";
				}

				var posDetails = peg$computePosDetails(pos),
					found      = pos < input.length ? input.charAt(pos) : null;

				if (expected !== null) {
				cleanupExpected(expected);
				}

				return new RantSyntaxError(
				message !== null ? message : buildMessage(expected, found),
				expected,
				found,
				pos,
				posDetails.line,
				posDetails.column
				);
			}

			function peg$parserant() {
				var s0, s1;

				s0 = [];
				s1 = peg$parseitem();
				while (s1 !== peg$FAILED) {
				s0.push(s1);
				s1 = peg$parseitem();
				}

				return s0;
			}

			function peg$parseitem() {
				var s0, s1, s2;

				s0 = peg$parseblock();
				if (s0 === peg$FAILED) {
				s0 = peg$parsefunction();
				if (s0 === peg$FAILED) {
					s0 = peg$parsequery();
					if (s0 === peg$FAILED) {
					s0 = peg$currPos;
					s1 = [];
					s2 = peg$parsetext_acceptable();
					if (s2 !== peg$FAILED) {
						while (s2 !== peg$FAILED) {
						s1.push(s2);
						s2 = peg$parsetext_acceptable();
						}
					} else {
						s1 = peg$c1;
					}
					if (s1 !== peg$FAILED) {
						s2 = peg$parsespace();
						if (s2 === peg$FAILED) {
						s2 = peg$c2;
						}
						if (s2 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c3(s1, s2);
						s0 = s1;
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					if (s0 === peg$FAILED) {
						s0 = peg$currPos;
						s1 = peg$parsespace();
						if (s1 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c4();
						}
						s0 = s1;
					}
					}
				}
				}

				return s0;
			}

			function peg$parseblock() {
				var s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12;

				s0 = peg$parsesingle_block();
				if (s0 === peg$FAILED) {
				s0 = peg$currPos;
				if (input.charCodeAt(peg$currPos) === 123) {
					s1 = peg$c5;
					peg$currPos++;
				} else {
					s1 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c6); }
				}
				if (s1 !== peg$FAILED) {
					s2 = [];
					s3 = peg$parsespace();
					while (s3 !== peg$FAILED) {
					s2.push(s3);
					s3 = peg$parsespace();
					}
					if (s2 !== peg$FAILED) {
					s3 = peg$parseblock_weight();
					if (s3 === peg$FAILED) {
						s3 = peg$c2;
					}
					if (s3 !== peg$FAILED) {
						s4 = [];
						s5 = peg$currPos;
						s6 = peg$parseblock_item();
						if (s6 !== peg$FAILED) {
						s7 = [];
						s8 = peg$parsespace();
						while (s8 !== peg$FAILED) {
							s7.push(s8);
							s8 = peg$parsespace();
						}
						if (s7 !== peg$FAILED) {
							s6 = [s6, s7];
							s5 = s6;
						} else {
							peg$currPos = s5;
							s5 = peg$c1;
						}
						} else {
						peg$currPos = s5;
						s5 = peg$c1;
						}
						while (s5 !== peg$FAILED) {
						s4.push(s5);
						s5 = peg$currPos;
						s6 = peg$parseblock_item();
						if (s6 !== peg$FAILED) {
							s7 = [];
							s8 = peg$parsespace();
							while (s8 !== peg$FAILED) {
							s7.push(s8);
							s8 = peg$parsespace();
							}
							if (s7 !== peg$FAILED) {
							s6 = [s6, s7];
							s5 = s6;
							} else {
							peg$currPos = s5;
							s5 = peg$c1;
							}
						} else {
							peg$currPos = s5;
							s5 = peg$c1;
						}
						}
						if (s4 !== peg$FAILED) {
						s5 = [];
						s6 = peg$currPos;
						if (input.charCodeAt(peg$currPos) === 124) {
							s7 = peg$c7;
							peg$currPos++;
						} else {
							s7 = peg$FAILED;
							if (peg$silentFails === 0) { peg$fail(peg$c8); }
						}
						if (s7 !== peg$FAILED) {
							s8 = [];
							s9 = peg$parsespace();
							while (s9 !== peg$FAILED) {
							s8.push(s9);
							s9 = peg$parsespace();
							}
							if (s8 !== peg$FAILED) {
							s9 = peg$parseblock_weight();
							if (s9 === peg$FAILED) {
								s9 = peg$c2;
							}
							if (s9 !== peg$FAILED) {
								s10 = [];
								s11 = peg$parsespace();
								while (s11 !== peg$FAILED) {
								s10.push(s11);
								s11 = peg$parsespace();
								}
								if (s10 !== peg$FAILED) {
								s11 = [];
								s12 = peg$parseblock_item();
								while (s12 !== peg$FAILED) {
									s11.push(s12);
									s12 = peg$parseblock_item();
								}
								if (s11 !== peg$FAILED) {
									s7 = [s7, s8, s9, s10, s11];
									s6 = s7;
								} else {
									peg$currPos = s6;
									s6 = peg$c1;
								}
								} else {
								peg$currPos = s6;
								s6 = peg$c1;
								}
							} else {
								peg$currPos = s6;
								s6 = peg$c1;
							}
							} else {
							peg$currPos = s6;
							s6 = peg$c1;
							}
						} else {
							peg$currPos = s6;
							s6 = peg$c1;
						}
						while (s6 !== peg$FAILED) {
							s5.push(s6);
							s6 = peg$currPos;
							if (input.charCodeAt(peg$currPos) === 124) {
							s7 = peg$c7;
							peg$currPos++;
							} else {
							s7 = peg$FAILED;
							if (peg$silentFails === 0) { peg$fail(peg$c8); }
							}
							if (s7 !== peg$FAILED) {
							s8 = [];
							s9 = peg$parsespace();
							while (s9 !== peg$FAILED) {
								s8.push(s9);
								s9 = peg$parsespace();
							}
							if (s8 !== peg$FAILED) {
								s9 = peg$parseblock_weight();
								if (s9 === peg$FAILED) {
								s9 = peg$c2;
								}
								if (s9 !== peg$FAILED) {
								s10 = [];
								s11 = peg$parsespace();
								while (s11 !== peg$FAILED) {
									s10.push(s11);
									s11 = peg$parsespace();
								}
								if (s10 !== peg$FAILED) {
									s11 = [];
									s12 = peg$parseblock_item();
									while (s12 !== peg$FAILED) {
									s11.push(s12);
									s12 = peg$parseblock_item();
									}
									if (s11 !== peg$FAILED) {
									s7 = [s7, s8, s9, s10, s11];
									s6 = s7;
									} else {
									peg$currPos = s6;
									s6 = peg$c1;
									}
								} else {
									peg$currPos = s6;
									s6 = peg$c1;
								}
								} else {
								peg$currPos = s6;
								s6 = peg$c1;
								}
							} else {
								peg$currPos = s6;
								s6 = peg$c1;
							}
							} else {
							peg$currPos = s6;
							s6 = peg$c1;
							}
						}
						if (s5 !== peg$FAILED) {
							s6 = [];
							s7 = peg$parsespace();
							while (s7 !== peg$FAILED) {
							s6.push(s7);
							s7 = peg$parsespace();
							}
							if (s6 !== peg$FAILED) {
							if (input.charCodeAt(peg$currPos) === 125) {
								s7 = peg$c9;
								peg$currPos++;
							} else {
								s7 = peg$FAILED;
								if (peg$silentFails === 0) { peg$fail(peg$c10); }
							}
							if (s7 !== peg$FAILED) {
								peg$reportedPos = s0;
								s1 = peg$c11(s3, s4, s5);
								s0 = s1;
							} else {
								peg$currPos = s0;
								s0 = peg$c1;
							}
							} else {
							peg$currPos = s0;
							s0 = peg$c1;
							}
						} else {
							peg$currPos = s0;
							s0 = peg$c1;
						}
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				}

				return s0;
			}

			function peg$parsesingle_block() {
				var s0, s1, s2, s3, s4, s5, s6;

				s0 = peg$currPos;
				if (input.charCodeAt(peg$currPos) === 123) {
				s1 = peg$c5;
				peg$currPos++;
				} else {
				s1 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c6); }
				}
				if (s1 !== peg$FAILED) {
				s2 = [];
				s3 = peg$parsespace();
				while (s3 !== peg$FAILED) {
					s2.push(s3);
					s3 = peg$parsespace();
				}
				if (s2 !== peg$FAILED) {
					s3 = peg$parseblock_weight();
					if (s3 === peg$FAILED) {
					s3 = peg$c2;
					}
					if (s3 !== peg$FAILED) {
					s4 = [];
					s5 = peg$parseblock_item();
					while (s5 !== peg$FAILED) {
						s4.push(s5);
						s5 = peg$parseblock_item();
					}
					if (s4 !== peg$FAILED) {
						s5 = [];
						s6 = peg$parsespace();
						while (s6 !== peg$FAILED) {
						s5.push(s6);
						s6 = peg$parsespace();
						}
						if (s5 !== peg$FAILED) {
						if (input.charCodeAt(peg$currPos) === 125) {
							s6 = peg$c9;
							peg$currPos++;
						} else {
							s6 = peg$FAILED;
							if (peg$silentFails === 0) { peg$fail(peg$c10); }
						}
						if (s6 !== peg$FAILED) {
							peg$reportedPos = s0;
							s1 = peg$c12(s3, s4);
							s0 = s1;
						} else {
							peg$currPos = s0;
							s0 = peg$c1;
						}
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				} else {
				peg$currPos = s0;
				s0 = peg$c1;
				}

				return s0;
			}

			function peg$parseblock_weight() {
				var s0, s1, s2, s3, s4, s5, s6, s7;

				s0 = peg$currPos;
				if (input.charCodeAt(peg$currPos) === 40) {
				s1 = peg$c13;
				peg$currPos++;
				} else {
				s1 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c14); }
				}
				if (s1 !== peg$FAILED) {
				s2 = [];
				s3 = peg$parsespace();
				while (s3 !== peg$FAILED) {
					s2.push(s3);
					s3 = peg$parsespace();
				}
				if (s2 !== peg$FAILED) {
					s3 = peg$parsenumber();
					if (s3 !== peg$FAILED) {
					s4 = [];
					s5 = peg$parsespace();
					while (s5 !== peg$FAILED) {
						s4.push(s5);
						s5 = peg$parsespace();
					}
					if (s4 !== peg$FAILED) {
						if (input.charCodeAt(peg$currPos) === 41) {
						s5 = peg$c15;
						peg$currPos++;
						} else {
						s5 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c16); }
						}
						if (s5 !== peg$FAILED) {
						s6 = [];
						s7 = peg$parsespace();
						while (s7 !== peg$FAILED) {
							s6.push(s7);
							s7 = peg$parsespace();
						}
						if (s6 !== peg$FAILED) {
							peg$reportedPos = s0;
							s1 = peg$c17(s3);
							s0 = s1;
						} else {
							peg$currPos = s0;
							s0 = peg$c1;
						}
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				} else {
				peg$currPos = s0;
				s0 = peg$c1;
				}

				return s0;
			}

			function peg$parseblock_item() {
				var s0, s1, s2, s3;

				s0 = peg$currPos;
				s1 = peg$parsequery();
				if (s1 !== peg$FAILED) {
				s2 = [];
				s3 = peg$parsespace();
				while (s3 !== peg$FAILED) {
					s2.push(s3);
					s3 = peg$parsespace();
				}
				if (s2 !== peg$FAILED) {
					peg$reportedPos = s0;
					s1 = peg$c18(s1, s2);
					s0 = s1;
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				} else {
				peg$currPos = s0;
				s0 = peg$c1;
				}
				if (s0 === peg$FAILED) {
				s0 = peg$currPos;
				s1 = peg$parseblock();
				if (s1 !== peg$FAILED) {
					s2 = [];
					s3 = peg$parsespace();
					while (s3 !== peg$FAILED) {
					s2.push(s3);
					s3 = peg$parsespace();
					}
					if (s2 !== peg$FAILED) {
					peg$reportedPos = s0;
					s1 = peg$c19(s1, s2);
					s0 = s1;
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				if (s0 === peg$FAILED) {
					s0 = peg$currPos;
					s1 = peg$parsefunction();
					if (s1 !== peg$FAILED) {
					s2 = [];
					s3 = peg$parsespace();
					while (s3 !== peg$FAILED) {
						s2.push(s3);
						s3 = peg$parsespace();
					}
					if (s2 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c20(s1, s2);
						s0 = s1;
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
					if (s0 === peg$FAILED) {
					s0 = peg$currPos;
					s1 = [];
					s2 = peg$parsetext_acceptable();
					if (s2 !== peg$FAILED) {
						while (s2 !== peg$FAILED) {
						s1.push(s2);
						s2 = peg$parsetext_acceptable();
						}
					} else {
						s1 = peg$c1;
					}
					if (s1 !== peg$FAILED) {
						s2 = [];
						s3 = peg$parsespace();
						while (s3 !== peg$FAILED) {
						s2.push(s3);
						s3 = peg$parsespace();
						}
						if (s2 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c21(s1, s2);
						s0 = s1;
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					}
				}
				}

				return s0;
			}

			function peg$parsequery() {
				var s0, s1, s2, s3, s4, s5, s6, s7;

				s0 = peg$currPos;
				if (input.charCodeAt(peg$currPos) === 60) {
				s1 = peg$c22;
				peg$currPos++;
				} else {
				s1 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c23); }
				}
				if (s1 !== peg$FAILED) {
				s2 = peg$parseacceptable();
				if (s2 !== peg$FAILED) {
					s3 = peg$currPos;
					if (peg$c24.test(input.charAt(peg$currPos))) {
					s4 = input.charAt(peg$currPos);
					peg$currPos++;
					} else {
					s4 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c25); }
					}
					if (s4 !== peg$FAILED) {
					s5 = peg$parseacceptable();
					if (s5 !== peg$FAILED) {
						s4 = [s4, s5];
						s3 = s4;
					} else {
						peg$currPos = s3;
						s3 = peg$c1;
					}
					} else {
					peg$currPos = s3;
					s3 = peg$c1;
					}
					if (s3 === peg$FAILED) {
					s3 = peg$c2;
					}
					if (s3 !== peg$FAILED) {
					s4 = [];
					s5 = peg$currPos;
					if (peg$c26.test(input.charAt(peg$currPos))) {
						s6 = input.charAt(peg$currPos);
						peg$currPos++;
					} else {
						s6 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c27); }
					}
					if (s6 !== peg$FAILED) {
						s7 = peg$parseacceptable();
						if (s7 !== peg$FAILED) {
						s6 = [s6, s7];
						s5 = s6;
						} else {
						peg$currPos = s5;
						s5 = peg$c1;
						}
					} else {
						peg$currPos = s5;
						s5 = peg$c1;
					}
					while (s5 !== peg$FAILED) {
						s4.push(s5);
						s5 = peg$currPos;
						if (peg$c26.test(input.charAt(peg$currPos))) {
						s6 = input.charAt(peg$currPos);
						peg$currPos++;
						} else {
						s6 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c27); }
						}
						if (s6 !== peg$FAILED) {
						s7 = peg$parseacceptable();
						if (s7 !== peg$FAILED) {
							s6 = [s6, s7];
							s5 = s6;
						} else {
							peg$currPos = s5;
							s5 = peg$c1;
						}
						} else {
						peg$currPos = s5;
						s5 = peg$c1;
						}
					}
					if (s4 !== peg$FAILED) {
						if (input.charCodeAt(peg$currPos) === 62) {
						s5 = peg$c28;
						peg$currPos++;
						} else {
						s5 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c29); }
						}
						if (s5 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c30(s2, s3, s4);
						s0 = s1;
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				} else {
				peg$currPos = s0;
				s0 = peg$c1;
				}

				return s0;
			}

			function peg$parsenumber() {
				var s0, s1, s2, s3, s4, s5, s6;

				s0 = peg$currPos;
				s1 = peg$currPos;
				s2 = [];
				if (peg$c31.test(input.charAt(peg$currPos))) {
				s3 = input.charAt(peg$currPos);
				peg$currPos++;
				} else {
				s3 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c32); }
				}
				if (s3 !== peg$FAILED) {
				while (s3 !== peg$FAILED) {
					s2.push(s3);
					if (peg$c31.test(input.charAt(peg$currPos))) {
					s3 = input.charAt(peg$currPos);
					peg$currPos++;
					} else {
					s3 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c32); }
					}
				}
				} else {
				s2 = peg$c1;
				}
				if (s2 !== peg$FAILED) {
				s3 = peg$currPos;
				if (peg$c24.test(input.charAt(peg$currPos))) {
					s4 = input.charAt(peg$currPos);
					peg$currPos++;
				} else {
					s4 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c25); }
				}
				if (s4 !== peg$FAILED) {
					s5 = [];
					if (peg$c31.test(input.charAt(peg$currPos))) {
					s6 = input.charAt(peg$currPos);
					peg$currPos++;
					} else {
					s6 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c32); }
					}
					if (s6 !== peg$FAILED) {
					while (s6 !== peg$FAILED) {
						s5.push(s6);
						if (peg$c31.test(input.charAt(peg$currPos))) {
						s6 = input.charAt(peg$currPos);
						peg$currPos++;
						} else {
						s6 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c32); }
						}
					}
					} else {
					s5 = peg$c1;
					}
					if (s5 !== peg$FAILED) {
					s4 = [s4, s5];
					s3 = s4;
					} else {
					peg$currPos = s3;
					s3 = peg$c1;
					}
				} else {
					peg$currPos = s3;
					s3 = peg$c1;
				}
				if (s3 === peg$FAILED) {
					s3 = peg$c2;
				}
				if (s3 !== peg$FAILED) {
					s2 = [s2, s3];
					s1 = s2;
				} else {
					peg$currPos = s1;
					s1 = peg$c1;
				}
				} else {
				peg$currPos = s1;
				s1 = peg$c1;
				}
				if (s1 !== peg$FAILED) {
				peg$reportedPos = s0;
				s1 = peg$c33(s1);
				}
				s0 = s1;

				return s0;
			}

			function peg$parsefunction() {
				var s0, s1, s2, s3, s4, s5, s6;

				s0 = peg$currPos;
				if (input.charCodeAt(peg$currPos) === 91) {
				s1 = peg$c34;
				peg$currPos++;
				} else {
				s1 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c35); }
				}
				if (s1 !== peg$FAILED) {
				s2 = peg$parseacceptable();
				if (s2 !== peg$FAILED) {
					s3 = peg$currPos;
					if (input.charCodeAt(peg$currPos) === 58) {
					s4 = peg$c36;
					peg$currPos++;
					} else {
					s4 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c37); }
					}
					if (s4 !== peg$FAILED) {
					s5 = [];
					s6 = peg$parsefunction_args();
					while (s6 !== peg$FAILED) {
						s5.push(s6);
						s6 = peg$parsefunction_args();
					}
					if (s5 !== peg$FAILED) {
						s4 = [s4, s5];
						s3 = s4;
					} else {
						peg$currPos = s3;
						s3 = peg$c1;
					}
					} else {
					peg$currPos = s3;
					s3 = peg$c1;
					}
					if (s3 === peg$FAILED) {
					s3 = peg$c2;
					}
					if (s3 !== peg$FAILED) {
					if (input.charCodeAt(peg$currPos) === 93) {
						s4 = peg$c38;
						peg$currPos++;
					} else {
						s4 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c39); }
					}
					if (s4 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c40(s2, s3);
						s0 = s1;
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				} else {
				peg$currPos = s0;
				s0 = peg$c1;
				}

				return s0;
			}

			function peg$parsefunction_args() {
				var s0, s1, s2, s3, s4;

				s0 = peg$currPos;
				s1 = [];
				s2 = peg$parsespace();
				while (s2 !== peg$FAILED) {
				s1.push(s2);
				s2 = peg$parsespace();
				}
				if (s1 !== peg$FAILED) {
				s2 = [];
				s3 = peg$parseacceptable();
				if (s3 !== peg$FAILED) {
					while (s3 !== peg$FAILED) {
					s2.push(s3);
					s3 = peg$parseacceptable();
					}
				} else {
					s2 = peg$c1;
				}
				if (s2 !== peg$FAILED) {
					s3 = [];
					s4 = peg$parsespace();
					while (s4 !== peg$FAILED) {
					s3.push(s4);
					s4 = peg$parsespace();
					}
					if (s3 !== peg$FAILED) {
					if (input.charCodeAt(peg$currPos) === 59) {
						s4 = peg$c41;
						peg$currPos++;
					} else {
						s4 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c42); }
					}
					if (s4 === peg$FAILED) {
						s4 = peg$c2;
					}
					if (s4 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c43(s2);
						s0 = s1;
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				} else {
				peg$currPos = s0;
				s0 = peg$c1;
				}
				if (s0 === peg$FAILED) {
				s0 = peg$currPos;
				s1 = [];
				s2 = peg$parsespace();
				while (s2 !== peg$FAILED) {
					s1.push(s2);
					s2 = peg$parsespace();
				}
				if (s1 !== peg$FAILED) {
					s2 = peg$parsequery();
					if (s2 !== peg$FAILED) {
					s3 = [];
					s4 = peg$parsespace();
					while (s4 !== peg$FAILED) {
						s3.push(s4);
						s4 = peg$parsespace();
					}
					if (s3 !== peg$FAILED) {
						if (input.charCodeAt(peg$currPos) === 59) {
						s4 = peg$c41;
						peg$currPos++;
						} else {
						s4 = peg$FAILED;
						if (peg$silentFails === 0) { peg$fail(peg$c42); }
						}
						if (s4 === peg$FAILED) {
						s4 = peg$c2;
						}
						if (s4 !== peg$FAILED) {
						peg$reportedPos = s0;
						s1 = peg$c44();
						s0 = s1;
						} else {
						peg$currPos = s0;
						s0 = peg$c1;
						}
					} else {
						peg$currPos = s0;
						s0 = peg$c1;
					}
					} else {
					peg$currPos = s0;
					s0 = peg$c1;
					}
				} else {
					peg$currPos = s0;
					s0 = peg$c1;
				}
				}

				return s0;
			}

			function peg$parseacceptable() {
				var s0, s1;

				s0 = [];
				if (peg$c45.test(input.charAt(peg$currPos))) {
				s1 = input.charAt(peg$currPos);
				peg$currPos++;
				} else {
				s1 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c46); }
				}
				if (s1 !== peg$FAILED) {
				while (s1 !== peg$FAILED) {
					s0.push(s1);
					if (peg$c45.test(input.charAt(peg$currPos))) {
					s1 = input.charAt(peg$currPos);
					peg$currPos++;
					} else {
					s1 = peg$FAILED;
					if (peg$silentFails === 0) { peg$fail(peg$c46); }
					}
				}
				} else {
				s0 = peg$c1;
				}

				return s0;
			}

			function peg$parsetext_acceptable() {
				var s0;

				if (peg$c47.test(input.charAt(peg$currPos))) {
				s0 = input.charAt(peg$currPos);
				peg$currPos++;
				} else {
				s0 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c48); }
				}

				return s0;
			}

			function peg$parsespace() {
				var s0;

				if (peg$c49.test(input.charAt(peg$currPos))) {
				s0 = input.charAt(peg$currPos);
				peg$currPos++;
				} else {
				s0 = peg$FAILED;
				if (peg$silentFails === 0) { peg$fail(peg$c50); }
				}

				return s0;
			}

			peg$result = peg$startRuleFunction();

			if (peg$result !== peg$FAILED && peg$currPos === input.length) {
				return peg$result;
			} else {
				if (peg$result !== peg$FAILED && peg$currPos < input.length) {
				peg$fail({ type: "end", description: "end of input" });
				}

				throw peg$buildException(null, peg$maxFailExpected, peg$maxFailPos);
			}
		}
	}

}