import tsPlugin from "@typescript-eslint/eslint-plugin"
import mdPlugin from "eslint-plugin-markdown"

/** @type { import('eslint').Linter.FlatConfig[] } */
export const markdown = [
	{
		files        : ["**/*.md"],
		processor    : "markdown/markdown",
		linterOptions: {
			reportUnusedDisableDirectives: true,
		},
		plugins: {
			markdown: mdPlugin,
		},
		rules: {
			...mdPlugin.configs.recommended.overrides[1].rules,
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

