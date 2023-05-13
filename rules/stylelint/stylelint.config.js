module.exports = {
	extends: ["stylelint-config-standard"],
	rules  : {
		// https://stylelint.io/user-guide/rules/#avoid-errors
		"at-rule-no-unknown": [true, {
			ignoreAtRules: ["tailwind", "apply"],
		}],
		"declaration-property-value-no-unknown": [true, {
			ignoreProperties: ["theme"],
		}],
		"function-no-unknown": [true, {
			ignoreFunctions: ["theme"],
		}],
		"no-unknown-animations"       : true,
		"no-unknown-custom-properties": true,

		// https://stylelint.io/user-guide/rules/#enforce-conventions
		"at-rule-property-required-list": {
			"font-face": ["src", "font-display", "font-family", "font-style"],
		},
		"color-hex-alpha"                      : "never",
		"color-named"                          : "always-where-possible",
		"media-feature-name-value-allowed-list": {
		  "/resolution/"       : "/dpcm$/",
			"/^(min|max)-width$/": ["320px", "480px", "768px", "1024px", "1280px", "1366px", "1440px", "1600px", "1920px", "2560px", "3840px"],
		},
		"selector-no-qualifying-type"      : [true, { ignore: ["attribute", "class"] }],
		"value-keyword-case"               : ["lower", { camelCaseSvgKeywords: true }],
		"custom-property-empty-line-before": null,
		"selector-max-attribute"           : 2,
		"selector-max-class"               : 3,
		"selector-max-combinators"         : 2,
		"selector-max-compound-selectors"  : 3,
		"selector-max-id"                  : 1,
		"selector-max-pseudo-class"        : 2,
		"selector-max-type"                : 2,
		"selector-max-universal"           : 1,
		"font-weight-notation"             : "named-where-possible",
		"import-notation"                  : "string",
		"font-family-name-quotes"          : "always-unless-keyword",
	},
}
