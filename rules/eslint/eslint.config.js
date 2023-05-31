import { extended, formatting, javascript, json, markdown, toml, yaml } from "./index.js"

/** @type { import('eslint').Linter.FlatConfig[] } */
export default [...javascript, ...json, ...markdown, ...toml, ...yaml, ...extended, ...formatting]

