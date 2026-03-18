local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
  -- Fenced code block
  s("code", fmt("```{}\n{}\n```", { i(1, "language"), i(2) })),

  -- Link
  s("link", fmt("[{}]({})", { i(1, "text"), i(2, "url") })),

  -- Image
  s("img", fmt("![{}]({})", { i(1, "alt"), i(2, "url") })),

  -- Table
  s("table", fmt(
    "| {} | {} |\n|---|---|\n| {} | {} |",
    { i(1, "Col 1"), i(2, "Col 2"), i(3), i(4) }
  )),

  -- Checkbox list
  s("todo", fmt("- [ ] {}", { i(1) })),
  s("done", fmt("- [x] {}", { i(1) })),

  -- Frontmatter (for static site generators)
  s("front", fmt(
    "---\ntitle: {}\ndate: {}\ntags: [{}]\n---\n\n{}",
    { i(1, "Title"), i(2, os.date("%Y-%m-%d")), i(3), i(4) }
  )),

  -- Callout / admonition
  s("note", fmt("> **Note**\n> {}", { i(1) })),
  s("warn", fmt("> **Warning**\n> {}", { i(1) })),
  s("tip",  fmt("> **Tip**\n> {}", { i(1) })),

  -- Headings
  s("h1", fmt("# {}", { i(1) })),
  s("h2", fmt("## {}", { i(1) })),
  s("h3", fmt("### {}", { i(1) })),

  -- Bold / italic
  s("bold", fmt("**{}**", { i(1) })),
  s("it",   fmt("*{}*", { i(1) })),

  -- Horizontal rule
  s("hr", t("---")),
}

ls.add_snippets("markdown", snippets)
