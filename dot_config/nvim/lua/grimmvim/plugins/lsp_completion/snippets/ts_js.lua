local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local c   = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets = {
  -- console.log
  s("cl", fmt("console.log({})", { i(1, "value") })),
  s("clv", fmt('console.log("{}: ", {})', { i(1, "label"), rep(1) })),
  s("cle", fmt("console.error({})", { i(1, "error") })),
  s("clw", fmt("console.warn({})", { i(1, "value") })),

  -- Arrow function
  s("af", fmt("const {} = ({}) => {{\n  {}\n}}", { i(1, "fn"), i(2, "args"), i(3) })),
  s("afa", fmt("const {} = async ({}) => {{\n  {}\n}}", { i(1, "fn"), i(2, "args"), i(3) })),

  -- Function
  s("fn", fmt("function {}({}) {{\n  {}\n}}", { i(1, "name"), i(2, "args"), i(3) })),
  s("afn", fmt("async function {}({}) {{\n  {}\n}}", { i(1, "name"), i(2, "args"), i(3) })),

  -- Imports
  s("imp", fmt('import {} from "{}"', { i(1, "module"), i(2, "path") })),
  s("imd", fmt('import {{ {} }} from "{}"', { i(1, "items"), i(2, "path") })),
  s("ima", fmt('import * as {} from "{}"', { i(1, "alias"), i(2, "path") })),

  -- Promise / async
  s("prom", fmt("new Promise(({}, {}) => {{\n  {}\n}})", { i(1, "resolve"), i(2, "reject"), i(3) })),
  s("trycatch", fmt("try {{\n  {}\n}} catch ({}) {{\n  {}\n}}", { i(1), i(2, "error"), i(3) })),
  s("aw", fmt("const {} = await {}", { i(1, "result"), i(2) })),

  -- Array / Object
  s("map", fmt("{}.map(({}) => {})", { i(1, "arr"), i(2, "item"), i(3) })),
  s("filter", fmt("{}.map(({}) => {})", { i(1, "arr"), i(2, "item"), i(3) })),
  s("reduce", fmt("{}.reduce(({}, {}) => {{\n  {}\n}}, {})", { i(1, "arr"), i(2, "acc"), i(3, "curr"), i(4), i(5, "[]") })),
  s("foreach", fmt("{}.forEach(({}) => {{\n  {}\n}})", { i(1, "arr"), i(2, "item"), i(3) })),
  s("fo", fmt("for (const {} of {}) {{\n  {}\n}}", { i(1, "item"), i(2, "items"), i(3) })),
  s("fi", fmt("for (let {} = 0; {} < {}.length; {}++) {{\n  {}\n}}", { i(1, "i"), rep(1), i(2, "arr"), rep(1), i(3) })),

  -- Ternary
  s("ter", fmt("{} ? {} : {}", { i(1, "condition"), i(2, "true"), i(3, "false") })),

  -- Export
  s("exp", fmt("export default {}", { i(1) })),
  s("exn", fmt("export const {} = {}", { i(1, "name"), i(2) })),
}

ls.add_snippets("javascript", snippets)
ls.add_snippets("typescript", snippets)
ls.add_snippets("javascriptreact", snippets)
ls.add_snippets("typescriptreact", snippets)
