import reactPlugin from "eslint-plugin-react"
import reactHooksPlugin from "eslint-plugin-react-hooks"

export const react = [
	{
		files  : ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		plugins: {
			"react"      : reactPlugin,
			"react-hooks": reactHooksPlugin,
		},
		rules: {
			...reactPlugin.configs.recommended.rules,
			...reactHooksPlugin.configs.recommended.rules,
		},
	},
]

export const preact = [
	{
		files  : ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		plugins: {
			"react"      : reactPlugin,
			"react-hooks": reactHooksPlugin,
		},
		rules: {
			...reactPlugin.configs.recommended.rules,
			...reactHooksPlugin.configs.recommended.rules,

			"react/react-in-jsx-scope": "off",
		},
	},
]

