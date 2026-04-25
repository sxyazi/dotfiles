import tsPlugin from "@typescript-eslint/eslint-plugin"
import mdPlugin from "@eslint/markdown"

/** @type { import('eslint').Linter.Config[] } */
export const markdown = [
	...mdPlugin.configs.processor,
	{
		files        : ["**/*.md"],
		linterOptions: {
			reportUnusedDisableDirectives: true,
		},
	},
	{
		files          : ["**/*.md/*.{js,jsx}"],
		languageOptions: {
			parserOptions: {
				ecmaFeatures: { impliedStrict: true },
			},
		},
	},
	{
		files  : ["**/*.md/*.{ts,tsx}"],
		plugins: {
			"@typescript-eslint": tsPlugin,
		},
	},
]

