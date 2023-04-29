import extended from "./plugins/extended.js"
import formatting from "./plugins/formatting.js"
import javascript from "./plugins/javascript.js"
import markdown from "./plugins/markdown.js"
import react from "./plugins/react.js"
import typescript from "./plugins/typescript.js"

export default [
	...javascript,
	...typescript,
	...markdown,
	...react,

	...extended,

	...formatting,
]

