local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets = {
  -- Main function
  s("main", fmt(
    "#include <iostream>\n\nint main(int argc, char* argv[]) {{\n  {}\n  return 0;\n}}",
    { i(1) }
  )),

  -- Class
  s("class", fmt(
    "class {} {{\npublic:\n  {}();\n  ~{}();\n\nprivate:\n  {}\n}};",
    { i(1, "MyClass"), rep(1), rep(1), i(2) }
  )),

  -- Struct
  s("struct", fmt("struct {} {{\n  {}\n}};", { i(1, "MyStruct"), i(2) })),

  -- Common includes
  s("inc", fmt('#include <{}>', { i(1) })),
  s("incs", fmt('#include "{}"', { i(1) })),
  s("stl", t({
    "#include <iostream>",
    "#include <string>",
    "#include <vector>",
    "#include <memory>",
    "#include <algorithm>",
  })),

  -- Loops
  s("fori", fmt("for (int {} = 0; {} < {}; {}++) {{\n  {}\n}}", { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) })),
  s("forr", fmt("for (auto& {} : {}) {{\n  {}\n}}", { i(1, "item"), i(2, "container"), i(3) })),
  s("forc", fmt("for (const auto& {} : {}) {{\n  {}\n}}", { i(1, "item"), i(2, "container"), i(3) })),
  s("while", fmt("while ({}) {{\n  {}\n}}", { i(1, "condition"), i(2) })),

  -- Smart pointers
  s("uptr", fmt("std::unique_ptr<{}> {} = std::make_unique<{}>({})", { i(1, "Type"), i(2, "ptr"), rep(1), i(3) })),
  s("sptr", fmt("std::shared_ptr<{}> {} = std::make_shared<{}>({})", { i(1, "Type"), i(2, "ptr"), rep(1), i(3) })),

  -- Lambda
  s("lam", fmt("[{}]({}) {{\n  {}\n}}", { i(1), i(2), i(3) })),

  -- Cout
  s("cout", fmt('std::cout << {} << std::endl;', { i(1) })),
  s("cerr", fmt('std::cerr << {} << std::endl;', { i(1) })),

  -- Namespace
  s("ns", fmt("namespace {} {{\n{}\n}}", { i(1, "name"), i(2) })),
  s("uns", t("using namespace std;")),

  -- Template
  s("tpl", fmt("template<{}>\n{}", { i(1, "typename T"), i(2) })),

  -- ifdef guard
  s("guard", fmt("#ifndef {}_H\n#define {}_H\n\n{}\n\n#endif // {}_H", { i(1, "HEADER"), rep(1), i(2), rep(1) })),
}

ls.add_snippets("c", snippets)
ls.add_snippets("cpp", snippets)
