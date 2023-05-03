import { extended, formatting, javascript, json } from "./index.js"

/** @type { import('eslint').Linter.FlatConfig[] } */
export default [
	...javascript,
	...json,
	...extended,
	...formatting,
]

