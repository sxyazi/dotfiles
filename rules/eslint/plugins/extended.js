import importPlugin from "eslint-plugin-import"
import unicornPlugin from "eslint-plugin-unicorn"

const unicorn = {
	...Object.fromEntries(
		Object.entries(unicornPlugin.configs.recommended.rules)
			.map(([k, v]) => [k, v === "error" ? "warn" : v]),
	),

	// Disabled
	"unicorn/explicit-length-check"     : "off",
	"unicorn/no-array-reduce"           : "off",
	"unicorn/no-await-expression-member": "off",
	"unicorn/no-null"                   : "off",
	"unicorn/prefer-number-properties"  : "off",
	"unicorn/prefer-top-level-await"    : "off",
	"unicorn/prevent-abbreviations"     : "off",

	// Default "off" → enable as "warn"
	"unicorn/better-regex"            : "warn",
	"unicorn/consistent-destructuring": "warn",
	"unicorn/custom-error-definition" : "warn",
	"unicorn/prefer-json-parse-buffer": "warn",
	"unicorn/string-content"          : "warn",

	// Custom options
	"unicorn/catch-error-name"    : ["warn", { name: "e" }],
	"unicorn/filename-case"       : ["error", { cases: { camelCase: true, pascalCase: true } }],
	"unicorn/no-typeof-undefined" : ["warn", { checkGlobalVariables: true }],
	"unicorn/no-useless-undefined": ["warn", { checkArguments: false }],
	"unicorn/prefer-array-find"   : ["warn", { checkFromLast: true }],
	"unicorn/prefer-export-from"  : ["warn", { ignoreUsedVariables: true }],
	"unicorn/prefer-switch"       : ["warn", { emptyDefaultCase: "no-default-case" }],
	"unicorn/switch-case-braces"  : ["warn", "avoid"],
}

const imports = {
	...importPlugin.configs.recommended.rules,

	"import/no-empty-named-blocks"          : "warn",
	"import/no-import-module-exports"       : "warn",
	"import/no-absolute-path"               : "warn",
	"import/no-relative-packages"           : "warn",
	"import/no-useless-path-segments"       : ["warn", { noUselessIndex: true, commonjs: true }],
	"import/consistent-type-specifier-style": "warn",
	"import/first"                          : "warn",
	"import/newline-after-import"           : ["warn", { considerComments: true }],
	// Temporarily disabled until eslint-plugin-import ships full ESLint 10 compatibility.
	"import/order"                          : "off",
}

/** @type { import('eslint').Linter.Config[] } */
export const extended = [
	// eslint-plugin-unicorn
	{
		files  : ["**/*.{ts,tsx,js,jsx,cjs,mjs,cts,mts}"],
		plugins: { unicorn: unicornPlugin },
		rules  : unicorn,
	},

	// eslint-plugin-import
	{
		files          : ["**/*.{js,jsx,mjs}"],
		// A hack to make the `eslint-plugin-import` works with ESLint's flat-config.
		languageOptions: {
			parserOptions: { ecmaVersion: "latest", sourceType: "module" },
		},
		plugins : { import: importPlugin },
		settings: {
			"import/extensions": [".js", ".jsx", ".mjs"],
			"import/parsers"   : { espree: [".js", ".jsx", ".mjs"] },
			"import/resolver"  : {
				typescript: { alwaysTryTypes: true },
				node      : true,
			},
		},
		rules: imports,
	},
	{
		files   : ["**/*.{ts,tsx,mts}"],
		plugins : { import: importPlugin },
		settings: {
			"import/extensions": [".ts", ".tsx", ".d.ts", ".js", ".jsx", ".mjs", ".mts"],
			"import/parsers"   : {
				"espree"                   : [".js", ".jsx", ".mjs"],
				"@typescript-eslint/parser": [".ts", ".tsx", ".d.ts", ".mts"],
			},
			"import/resolver"               : { typescript: { alwaysTryTypes: true } },
			"import/external-module-folders": ["node_modules", "node_modules/@types"],
		},
		rules: {
			// TypeScript compilation already ensures that named imports exist in the referenced module
			"import/named": "off",
		},
	},
	{
		files: ["eslint.config.js"],
		rules: {
			"import/no-useless-path-segments": ["warn", { noUselessIndex: false }],
		},
	},
]
