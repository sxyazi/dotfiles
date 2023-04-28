import mdPlugin from "eslint-plugin-markdown"
import tsPlugin from "@typescript-eslint/eslint-plugin"

export default [
	{
		files    : ["**/*.md"],
		processor: "markdown/markdown",
		plugins  : {
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
				ecmaFeatures: {
					impliedStrict: true,
				},
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

