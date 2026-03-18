local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local c   = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets = {
  -- Functional component
  s("rfc", fmt(
    'import React from "react"\n\ninterface {}Props {{\n  {}\n}}\n\nconst {}: React.FC<{}Props> = ({{{}}}) => {{\n  return (\n    <div>\n      {}\n    </div>\n  )\n}}\n\nexport default {}',
    { i(1, "Component"), i(2), rep(1), rep(1), i(3), i(4), rep(1) }
  )),

  -- useState
  s("us", fmt("const [{}, set{}] = useState<{}>({});", {
    i(1, "state"), rep(1), i(2, "type"), i(3, "initialValue")
  })),

  -- useEffect
  s("ue", fmt("useEffect(() => {{\n  {}\n}}, [{}]);", { i(1), i(2) })),
  s("uec", fmt("useEffect(() => {{\n  {}\n  return () => {{\n    {}\n  }}\n}}, [{}]);", { i(1), i(2), i(3) })),

  -- useRef
  s("ur", fmt("const {} = useRef<{}>({})", { i(1, "ref"), i(2, "HTMLElement"), i(3, "null") })),

  -- useContext
  s("uc", fmt("const {} = useContext({})", { i(1, "ctx"), i(2, "Context") })),

  -- useCallback
  s("ucb", fmt("const {} = useCallback(({}) => {{\n  {}\n}}, [{}]);", { i(1, "fn"), i(2), i(3), i(4) })),

  -- useMemo
  s("um", fmt("const {} = useMemo(() => {{\n  {}\n}}, [{}]);", { i(1, "value"), i(2), i(3) })),

  -- useReducer
  s("urd", fmt("const [{}, {}] = useReducer({}, {})", { i(1, "state"), i(2, "dispatch"), i(3, "reducer"), i(4, "initialState") })),

  -- Props destructure
  s("pd", fmt("const {{ {} }} = props", { i(1) })),

  -- Fragment
  s("fr", fmt("<>\n  {}\n</>", { i(1) })),

  -- className (Tailwind)
  s("cn", fmt('className="{}"', { i(1) })),

  -- onClick
  s("oc", fmt("onClick={{() => {}}}", { i(1) })),

  -- conditional render
  s("cr", fmt("{} && (\n  {}\n)", { i(1, "condition"), i(2) })),
  s("tc", fmt("{} ? (\n  {}\n) : (\n  {}\n)", { i(1, "condition"), i(2), i(3) })),
}

ls.add_snippets("javascriptreact", snippets)
ls.add_snippets("typescriptreact", snippets)
