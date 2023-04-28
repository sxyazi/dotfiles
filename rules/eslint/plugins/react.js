import reactPlugin from "eslint-plugin-react"

export default [
	{
		files  : ["**/*.{js,cjs,mjs,jsx,ts,tsx}"],
		plugins: {
			react: reactPlugin,
		},
		rules: {
		},
	},
]

