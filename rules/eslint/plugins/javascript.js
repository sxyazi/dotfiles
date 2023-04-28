import globals from "globals"
import eslint from "@eslint/js"

import formatting from "./formatting.js"

export default [
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
			...formatting,
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
			...formatting,
		},
	},
]

