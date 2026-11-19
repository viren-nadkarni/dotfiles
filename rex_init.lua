rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- tabs
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>,", "client.tab.rename")

rex.bind("ctrl+a>shift+,", "client.tab.move", { direction = "backward" })
rex.bind("ctrl+a>shift+.", "client.tab.move", { direction = "forward" })

rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>r", "client.tab.rename")

for i = 1, 9 do
    rex.bind("ctrl+a>" .. i, "client.tab.goto", { index = i })
end

-- sessions
rex.bind("ctrl+a>space", "session.switch")

rex.bind("ctrl+a>ctrl+c", "session.new")
rex.bind("ctrl+a>ctrl+r", "session.rename")

rex.bind("ctrl+a>ctrl+p", "session.previous")
rex.bind("ctrl+a>ctrl+n", "session.next")

-- panes
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>x", "pane.close")

rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })

rex.bind("ctrl+a>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+a>shift+5", "pane.split", { direction = "right" })

rex.bind("ctrl+shift+v", "pane.paste")
rex.bind("ctrl+shift+c", "pane.copy")
