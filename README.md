# project_dom_tree
Like leaves on the wind

[A data structures, algorithms, file I/O, ruby and regular expression (regex) project from the Viking Code School](http://www.vikingcodeschool.com)

by Sia Karamalegos

## About

This application will read in an html file, parse it into a tree of nodes (using Structs), search those nodes by attribute, render statistics about the tree and/or node, and rebuild an html file from the tree.  It will not work with self-closing tags, html comments, or doctype declarations.

## Instructions

To build the tree, create a new instance of the class DOMReader:
```
reader = DOMReader.new
```

Then, put an html file in the same folder and use the *build_tree* method to create the node tree, like so:
```
tree = reader.build_tree("test.html")
```

You can render statistics about a tree or specific node like so:
```
renderer = NodeRenderer.new(tree)
renderer.render()
```

To get the statistics about a node, pass it in as an argument to `render`.

To run searches, create a new instance of the class TreeSearcher.  Examples of how to use this plus the render statistics functionality are listed below:
```
searcher = TreeSearcher.new(tree)
searcher.search_by(:classes, "sidebar").each { |node| renderer.render(node) }
searcher.search_by(:tag, "div").each { |node| renderer.render(node) }
searcher.search_by(:text, "div").each { |node| renderer.render(node) }
my_node = searcher.search_by(:id, "main-area")
my_node.each { |node| renderer.render(node) }
descendants = searcher.search_descendants(my_node[0], :tag, "li")
descendants.each { |node| renderer.render(node) }
searcher.search_ancestors(my_node[0], :tag, "body").each { |node| renderer.render(node) }
```

To rebuild the html file from the tree, run the *build_file* method, passing in a file name to use when writing the new file:
```
renderer.build_file("build.html")
```
