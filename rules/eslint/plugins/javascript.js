import eslint from "@eslint/js"
import globals from "globals"

export const eslintOverride = {
	"no-case-declarations": "off",
}

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
			...eslintOverride,
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
			...eslintOverride,
		},
	},
]

