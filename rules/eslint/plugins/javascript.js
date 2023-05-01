import eslint from "@eslint/js"
import globals from "globals"

export const javascript = [
	{
		files          : ["**/*.{js,cjs,mjs}"],
		languageOptions: {
			globals: {
				...globals.browser,
				...globals.es2021,
				...globals.node,
			},
		},
		rules: {
			...eslint.configs.recommended.rules,
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
				ecmaFeatures: {
					jsx: true,
				},
			},
		},
		rules: {
			...eslint.configs.recommended.rules,
		},
	},
]

