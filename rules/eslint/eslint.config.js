import { extended, formatting, javascript, typescript, json, markdown, toml, yaml } from "./index.js"

/** @type { import('eslint').Linter.FlatConfig[] } */
export default [...javascript, ...typescript, ...json, ...markdown, ...toml, ...yaml, ...extended, ...formatting]
