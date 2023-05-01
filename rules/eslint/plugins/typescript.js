import eslint from "@eslint/js"
import tsPlugin from "@typescript-eslint/eslint-plugin"
import tsParser from "@typescript-eslint/parser"

export const typescript = [
	{
		files          : ["**/*.{ts,tsx,cts,mts}"],
		languageOptions: {
			parser: tsParser,
		},
		plugins: {
			"@typescript-eslint": tsPlugin,
		},
		rules: {
			...eslint.configs.recommended.rules,
			...tsPlugin.configs["eslint-recommended"].overrides[0].rules,
			...tsPlugin.configs.recommended.rules,

			"@typescript-eslint/ban-ts-comment"       : "off",
			"@typescript-eslint/no-non-null-assertion": "off",
		},
	},
]

