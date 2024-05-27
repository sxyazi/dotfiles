import jsonSchemaPlugin, { configs as jsonSchemaConfigs } from "eslint-plugin-json-schema-validator"
import ymlPlugin, { configs as ymlConfigs } from "eslint-plugin-yml"
import ymlParser from "yaml-eslint-parser"

import { fmRules } from "./formatting.js"

export const ymlRules = {
	// https://ota-meshi.github.io/eslint-plugin-yml/rules/#yaml-rules
	"yml/block-mapping-colon-indicator-newline": "warn",
	"yml/block-mapping-question-indicator-newline": "warn",
	"yml/block-mapping": ["warn", { singleline: "never", multiline: "always" }],
	"yml/block-sequence-hyphen-indicator-newline": "warn",
	"yml/block-sequence": ["warn", { singleline: "never", multiline: "always" }],
	"yml/indent": "warn",
	"yml/no-trailing-zeros": "warn",
	"yml/plain-scalar": "warn",
	"yml/quotes": "warn",

	// https://ota-meshi.github.io/eslint-plugin-yml/rules/#extension-rules
	"yml/flow-mapping-curly-newline": fmRules["object-curly-newline"],
	"yml/flow-mapping-curly-spacing": fmRules["object-curly-spacing"],
	"yml/flow-sequence-bracket-newline": fmRules["array-bracket-newline"],
	"yml/flow-sequence-bracket-spacing": fmRules["array-bracket-spacing"],
	"yml/key-spacing": fmRules["key-spacing"],
	"yml/no-multiple-empty-lines": fmRules["no-multiple-empty-lines"],
	"yml/spaced-comment": fmRules["spaced-comment"],
}

/** @type { import('eslint').Linter.FlatConfig[] } */
export const yaml = [
	{
		files: ["**/*.{yaml,yml}"],
		languageOptions: { parser: ymlParser },
		plugins: {
			"yml": ymlPlugin,
			"json-schema-validator": jsonSchemaPlugin,
		},
		rules: {
			// eslint-plugin-yml
			...ymlConfigs.recommended.rules,
			...ymlRules,

			// eslint-plugin-json-schema-validator
			...jsonSchemaConfigs.recommended.rules,
		},
	},
]
