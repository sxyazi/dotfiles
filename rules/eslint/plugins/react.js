import reactPlugin from "eslint-plugin-react"

export default [
	{
		files  : ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		plugins: {
			react: reactPlugin,
		},
		rules: {
			...reactPlugin.configs.recommended.rules,
		},
	},
]

