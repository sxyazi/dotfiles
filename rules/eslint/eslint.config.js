import { extended, formatting, javascript, json, markdown, toml, typescript, yaml } from "./index.js"

/** @type { import('eslint').Linter.Config[] } */
export default [...javascript, ...typescript, ...json, ...markdown, ...toml, ...yaml, ...extended, ...formatting]
