import eslint from "@eslint/js"
import globals from "globals"

export const jsRules = {
	"no-case-declarations": "off",
}

/** @type { import('eslint').Linter.FlatConfig[] } */
export const javascript = [
	{
		files          : ["**/*.{js,jsx,cjs,mjs}"],
		languageOptions: {
			globals: {
				...globals.browser,
				...globals.es2021,
				...globals.node,
			},
		},
		linterOptions: {
			reportUnusedDisableDirectives: true,
		},
		rules: {
			...eslint.configs.recommended.rules,
			...jsRules,
		},
	},
	{
		files          : ["**/*.jsx"],
		languageOptions: {
			globals: {
				...globals.browser,
				...globals.es2021,
			},
			parserOptions: {
				ecmaFeatures: { jsx: true },
			},
		},
	},
]

