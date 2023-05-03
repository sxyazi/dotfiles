import jsonSchemaPlugin, { configs as jsonSchemaConfigs } from "eslint-plugin-json-schema-validator"
import jsoncPlugin, { configs as jsoncConfigs } from "eslint-plugin-jsonc"
import jsoncParser from "jsonc-eslint-parser"

import { fmRules } from "./formatting.js"

export const jsoncRules = {
	// https://ota-meshi.github.io/eslint-plugin-jsonc/rules/#jsonc-rules
	"jsonc/no-binary-expression"            : "warn",
	"jsonc/no-binary-numeric-literals"      : "warn",
	"jsonc/no-escape-sequence-in-identifier": "warn",
	"jsonc/no-hexadecimal-numeric-literals" : "warn",
	"jsonc/no-number-props"                 : "warn",
	"jsonc/no-numeric-separators"           : "warn",
	"jsonc/no-octal-numeric-literals"       : "warn",
	"jsonc/no-parenthesized"                : "warn",
	"jsonc/no-plus-sign"                    : "warn",
	"jsonc/no-template-literals"            : "warn",
	"jsonc/no-unicode-codepoint-escapes"    : "warn",
	"jsonc/valid-json-number"               : "warn",

	// https://ota-meshi.github.io/eslint-plugin-jsonc/rules/#extension-rules
	"jsonc/array-bracket-newline"  : fmRules["array-bracket-newline"],
	"jsonc/array-bracket-spacing"  : fmRules["array-bracket-spacing"],
	"jsonc/array-element-newline"  : fmRules["array-element-newline"],
	"jsonc/comma-dangle"           : ["warn", "never"],
	"jsonc/comma-style"            : fmRules["comma-style"],
	"jsonc/indent"                 : fmRules.indent,
	"jsonc/key-spacing"            : fmRules["key-spacing"],
	"jsonc/no-floating-decimal"    : fmRules["no-floating-decimal"],
	"jsonc/object-curly-newline"   : fmRules["object-curly-newline"],
	"jsonc/object-curly-spacing"   : fmRules["object-curly-spacing"],
	"jsonc/object-property-newline": fmRules["object-property-newline"],
	"jsonc/quote-props"            : "warn",
	"jsonc/quotes"                 : fmRules.quotes,
	"jsonc/space-unary-ops"        : fmRules["space-unary-ops"],
}

/** @type { import('eslint').Linter.FlatConfig[] } */
export const json = [
	{
		files          : ["**/*.{json,jsonc}"],
		languageOptions: { parser: jsoncParser },
		plugins        : {
			"jsonc"                : jsoncPlugin,
			"json-schema-validator": jsonSchemaPlugin,
		},
		rules: {
			// eslint-plugin-jsonc
			...jsoncConfigs["recommended-with-jsonc"].rules,
			...jsoncRules,

			// eslint-plugin-json-schema-validator
			...jsonSchemaConfigs.recommended.rules,
		},
	},
	{
		files          : ["**/*.json5"],
		languageOptions: { parser: jsoncParser },
		plugins        : {
			"jsonc"                : jsoncPlugin,
			"json-schema-validator": jsonSchemaPlugin,
		},
		rules: {
			// eslint-plugin-jsonc
			...jsoncConfigs["recommended-with-json5"].rules,
			...jsoncRules,

			"jsonc/no-hexadecimal-numeric-literals": "off",
			"jsonc/no-plus-sign"                   : "off",
			"jsonc/valid-json-number"              : "off",

			"jsonc/comma-dangle": fmRules["comma-dangle"],
			"jsonc/quote-props" : fmRules["quote-props"],

			// eslint-plugin-json-schema-validator
			...jsonSchemaConfigs.recommended.rules,
		},
	},
	{
		files: ["package.json"],
		rules: {
			"jsonc/sort-keys": [
				"warn",
				{
					pathPattern: "^$",
					order      : [
						"name",
						"type",
						"version",
						"scripts",
						"engines",
						"packageManager",

						"bin",
						"main",
						"module",
						"browser",
						"exports",

						"private",
						"author",
						"repository",
						"homepage",
						"bugs",
						"funding",
						"license",
						"description",
						"keywords",
						"publishConfig",

						"dependencies",
						"devDependencies",
						"peerDependencies",
						"peerDependenciesMeta",
						"bundledDependencies",
						"optionalDependencies",
					],
				},
				{
					pathPattern: "^scripts.*$",
					order      : [
						{ keyPattern: "^pre:.*$" },
						{ keyPattern: "^dev.*$" },
						{ keyPattern: "^build.*$" },
						{ keyPattern: "^generate.*$" },
						{ keyPattern: "^preview.*$" },
						{ keyPattern: "^test.*$" },
						{ keyPattern: "^lint.*$" },
						{ keyPattern: "^release.*$" },
					],
				},
				{
					pathPattern: "^exports.*$",
					order      : ["import", "require", "types"],
				},
				{
					pathPattern: "^(dev|peer|bundled|optional)?[Dd]ependencies$",
					order      : { type: "asc" },
				},
			],
			"jsonc/key-spacing": ["warn", {}],
		},
	},
]

