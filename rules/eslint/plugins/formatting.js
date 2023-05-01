// https://eslint.org/docs/latest/rules/#layout--formatting
const basic = {
	"array-bracket-newline"         : ["warn", "consistent"],
	"array-bracket-spacing"         : "warn",
	"array-element-newline"         : ["warn", "consistent"],
	"arrow-parens"                  : ["warn", "as-needed"],
	"arrow-spacing"                 : "warn",
	"block-spacing"                 : "warn",
	"brace-style"                   : ["warn", "1tbs", {allowSingleLine: true}],
	"comma-dangle"                  : ["warn", "always-multiline"],
	"comma-spacing"                 : "warn",
	"comma-style"                   : "warn",
	"computed-property-spacing"     : "warn",
	"dot-location"                  : ["warn", "property"],
	"eol-last"                      : "warn",
	"func-call-spacing"             : "warn",
	"function-call-argument-newline": ["warn", "consistent"],
	"function-paren-newline"        : "off",
	"generator-star-spacing"        : ["warn", {before: false, after: true}],
	"implicit-arrow-linebreak"      : "off",
	"indent"                        : ["warn", "tab", {
		VariableDeclarator      : "first",
		FunctionDeclaration     : {parameters: "first"},
		FunctionExpression      : {parameters: "first"},
		CallExpression          : {arguments: "first"},
		ArrayExpression         : "first",
		ObjectExpression        : "first",
		ImportDeclaration       : "first",
		flatTernaryExpressions  : true,
		offsetTernaryExpressions: true,
	}],
	"jsx-quotes"                 : "warn",
	"key-spacing"                : ["warn", {align: "colon"}],
	"keyword-spacing"            : "warn",
	"line-comment-position"      : "off",
	"linebreak-style"            : "warn",
	"lines-around-comment"       : "off",
	"lines-between-class-members": ["warn", "never"],
	"max-len"                    : ["warn", {code: 120, tabWidth: 2}],
	"max-statements-per-line"    : "warn",
	"multiline-ternary"          : ["warn", "always-multiline"],
	"new-parens"                 : "warn",
	"newline-per-chained-call"   : "off",
	"no-extra-parens"            : "warn",
	"no-mixed-spaces-and-tabs"   : ["warn", "smart-tabs"],
	"no-multi-spaces"            : ["warn", {
		ignoreEOLComments: true,
		exceptions       : {Property: true, VariableDeclarator: true, ImportDeclaration: true},
	}],
	"no-multiple-empty-lines"         : ["warn", {max: 1, maxBOF: 0, maxEOF: 1}],
	"no-tabs"                         : ["warn", {allowIndentationTabs: true}],
	"no-trailing-spaces"              : "warn",
	"no-whitespace-before-property"   : "warn",
	"nonblock-statement-body-position": ["warn", "any"],
	"object-curly-newline"            : "warn",
	"object-curly-spacing"            : "warn",
	"object-property-newline"         : ["warn", {allowAllPropertiesOnSameLine: true}],
	"operator-linebreak"              : ["warn", "before"],
	"padded-blocks"                   : ["warn", "never"],
	"padding-line-between-statements" : [
		"warn",
		{blankLine: "always", prev: "import", next: "*"},
		{blankLine: "any", prev: "import", next: "import"},
		{blankLine: "always", prev: "directive", next: "*"},
	],
	"quotes"                     : ["warn", "double", {avoidEscape: true, allowTemplateLiterals: true}],
	"rest-spread-spacing"        : "warn",
	"semi"                       : ["warn", "never", {beforeStatementContinuationChars: "never"}],
	"semi-spacing"               : "warn",
	"semi-style"                 : ["warn", "first"],
	"space-before-blocks"        : "warn",
	"space-before-function-paren": ["warn", {
		anonymous : "never",
		named     : "never",
		asyncArrow: "always",
	}],
	"space-in-parens"       : "warn",
	"space-infix-ops"       : "warn",
	"space-unary-ops"       : ["warn", {words: true, nonwords: false}],
	"switch-colon-spacing"  : "warn",
	"template-curly-spacing": "warn",
	"template-tag-spacing"  : "warn",
	"unicode-bom"           : "warn",
	"wrap-iife"             : ["warn", "outside", {functionPrototypeMethods: true}],
	"wrap-regex"            : "off",
	"yield-star-spacing"    : "warn",
}

// https://eslint.org/docs/latest/rules/#suggestions
const suggestions = {
	"arrow-body-style"              : "off",
	"capitalized-comments"          : "off",
	"curly"                         : "off",
	"dot-notation"                  : "warn",
	"eqeqeq"                        : "warn",
	"logical-assignment-operators"  : ["warn", "always", {enforceForIfStatements: true}],
	"multiline-comment-style"       : ["warn", "separate-lines", {checkJSDoc: true}],
	"no-confusing-arrow"            : ["warn", {onlyOneSimpleParam: true}],
	"no-div-regex"                  : "off",
	"no-else-return"                : "off",
	"no-extra-bind"                 : "warn",
	"no-extra-boolean-cast"         : ["warn", {enforceForLogicalOperands: true}],
	"no-extra-label"                : "warn",
	"no-floating-decimal"           : "warn",
	"no-implicit-coercion"          : ["warn", {boolean: false}],
	"no-lonely-if"                  : "warn",
	"no-undef-init"                 : "off",  // Covered by `unicorn/no-useless-undefined`
	"no-unneeded-ternary"           : "warn",
	"no-useless-computed-key"       : ["warn", {enforceForClassMembers: true}],
	"no-useless-rename"             : "warn",
	"no-useless-return"             : "warn",
	"no-var"                        : "warn",
	"object-shorthand"              : "warn",
	"one-var-declaration-per-line"  : "warn",
	"operator-assignment"           : "warn",
	"prefer-arrow-callback"         : ["warn", {allowNamedFunctions: true}],
	"prefer-const"                  : ["warn", {destructuring: "all"}],
	"prefer-destructuring"          : "off",
	"prefer-exponentiation-operator": "warn",
	"prefer-numeric-literals"       : "off",
	"prefer-object-has-own"         : "off",
	"prefer-object-spread"          : "warn",
	"prefer-template"               : "warn",
	"quote-props"                   : ["warn", "consistent-as-needed"],
	"sort-imports"                  : ["warn", {
		ignoreCase           : true,
		ignoreDeclarationSort: true,
		allowSeparatedGroups : true,
	}],
	"sort-vars"     : ["warn", {ignoreCase: true}],
	"spaced-comment": ["warn", "always", {
		line : {markers: ["/"]},
		block: {balanced: true},
	}],
	"strict": ["warn", "never"],
	"yoda"  : "warn",
}

export const formatting = [
	{
		files: ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		rules: {
			...basic,
			...suggestions,
		},
	},
	{
		files: ["**/*.{ts,tsx,cts,mts}"],
		rules: {
			"indent"                   : "off",
			"@typescript-eslint/indent": ["warn", "tab", {
				VariableDeclarator      : "first",
				FunctionDeclaration     : {parameters: "first"},
				FunctionExpression      : {parameters: "first"},
				CallExpression          : {arguments: "first"},
				ArrayExpression         : "first",
				ObjectExpression        : "first",
				ImportDeclaration       : "first",
				flatTernaryExpressions  : true,
				offsetTernaryExpressions: true,
			}],
			"no-extra-parens"                   : "off",
			"@typescript-eslint/no-extra-parens": ["warn", "functions"],
		},
	},
]
