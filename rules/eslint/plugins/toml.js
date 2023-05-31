import jsonSchemaPlugin, { configs as jsonSchemaConfigs } from "eslint-plugin-json-schema-validator"
import tomlPlugin, { configs as tomlConfigs } from "eslint-plugin-toml"
import tomlParser from "toml-eslint-parser"

import { fmRules } from "./formatting.js"

export const tomlRules = {
	// https://ota-meshi.github.io/eslint-plugin-toml/rules/#toml-rules
	"toml/indent"                     : ["warn", "tab", { subTables: 1 }],
	"toml/keys-order"                 : "warn",
	"toml/no-non-decimal-integer"     : "warn",
	"toml/no-space-dots"              : "warn",
	"toml/padding-line-between-pairs" : "warn",
	"toml/padding-line-between-tables": "warn",
	"toml/quoted-keys"                : "warn",
	"toml/tables-order"               : "warn",

	// https://ota-meshi.github.io/eslint-plugin-toml/rules/#extension-rules
	"toml/array-bracket-newline"     : fmRules["array-bracket-newline"],
	"toml/array-bracket-spacing"     : fmRules["array-bracket-spacing"],
	"toml/array-element-newline"     : fmRules["array-element-newline"],
	"toml/comma-style"               : fmRules["comma-style"],
	"toml/inline-table-curly-spacing": fmRules["object-curly-spacing"],
	"toml/key-spacing"               : ["warn", { align: "equal" }],
	"toml/spaced-comment"            : ["warn", "always", { markers: ["#"] }],
	"toml/table-bracket-spacing"     : fmRules["array-bracket-spacing"],
}

/** @type { import('eslint').Linter.FlatConfig[] } */
export const toml = [
	{
		files          : ["**/*.toml"],
		languageOptions: { parser: tomlParser },
		plugins        : {
			"toml"                 : tomlPlugin,
			"json-schema-validator": jsonSchemaPlugin,
		},
		rules: {
			// eslint-plugin-toml
			...tomlConfigs.recommended.rules,
			...tomlRules,

			// eslint-plugin-json-schema-validator
			...jsonSchemaConfigs.recommended.rules,
		},
	},
]
