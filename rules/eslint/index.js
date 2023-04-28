/*
 * TODO
 * https://www.npmjs.com/package/eslint-plugin-import
 * https://github.com/sindresorhus/eslint-plugin-unicorn
 */

import javascript from "./plugins/javascript.js"
import typescript from "./plugins/typescript.js"
import markdown from "./plugins/markdown.js"
import react from "./plugins/react.js"

export default [
	...javascript,
	...typescript,
	...markdown,
	...react,
]

