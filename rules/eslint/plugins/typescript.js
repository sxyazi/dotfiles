import eslint from "@eslint/js"
import tsPlugin from "@typescript-eslint/eslint-plugin"
import tsParser from "@typescript-eslint/parser"

import { jsRules } from "./javascript.js"

/** @type { import('eslint').Linter.FlatConfig[] } */
export const typescript = [
	{
		files          : ["**/*.{ts,tsx,cts,mts}"],
		languageOptions: {
			parser       : tsParser,
			parserOptions: { project: true },
		},
		linterOptions: {
			reportUnusedDisableDirectives: true,
		},
		plugins: {
			"@typescript-eslint": tsPlugin,
		},
		rules: {
			...eslint.configs.recommended.rules,
			...tsPlugin.configs["eslint-recommended"].overrides[0].rules,
			...tsPlugin.configs.recommended.rules,
			...tsPlugin.configs["recommended-requiring-type-checking"].rules,

			...jsRules,
			"@typescript-eslint/ban-ts-comment"       : "off",
			"@typescript-eslint/no-non-null-assertion": "off",
		},
	},
]

