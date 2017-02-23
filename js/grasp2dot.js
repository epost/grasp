const R = require('ramda')
const fs = require('fs')

const toGraphviz =
  R.compose(
    R.concat("digraph g1 {\n"),
    R.flip(R.concat)("\n}"),
    R.join("\n"),
    R.map(n => '  "' + n.s + '" -> "' + n.t + '" [label="' + R.defaultTo('', n.label) + '"]')
  )

const inputFilename = process.argv[2]
if (inputFilename) {
  const graphJson = fs.readFileSync(inputFilename, {encoding: 'utf8'})
  const graph = JSON.parse(graphJson)
  const graphGraphviz = toGraphviz(graph)
  console.log(graphGraphviz)
} else {
  console.error('Please specify an input file')
}
