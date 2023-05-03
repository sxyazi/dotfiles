import reactPlugin from "eslint-plugin-react"
import reactHooksPlugin from "eslint-plugin-react-hooks"

/** @type { import('eslint').Linter.FlatConfig[] } */
export const react = [
	{
		files  : ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		plugins: {
			"react"      : reactPlugin,
			"react-hooks": reactHooksPlugin,
		},
		settings: {
			react: {
				version: "detect",
			},
		},
		rules: {
			...reactPlugin.configs.recommended.rules,
			...reactHooksPlugin.configs.recommended.rules,
		},
	},
]

/** @type { import('eslint').Linter.FlatConfig[] } */
export const preact = [
	{
		files  : ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		plugins: {
			"react"      : reactPlugin,
			"react-hooks": reactHooksPlugin,
		},
		settings: {
			react: {
				version: "16.0",
			},
		},
		rules: {
			...reactPlugin.configs.recommended.rules,
			...reactHooksPlugin.configs.recommended.rules,

			"react/react-in-jsx-scope": "off",
		},
	},
]

