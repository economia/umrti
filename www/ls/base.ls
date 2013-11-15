new Tooltip!watchElements!
d3.selectAll \.fallback .remove!
windowWidth = window.innerWidth

(err, basedata) <~ d3.csv do
    "../data/summary-both.csv"
    utils.csvTransform

menu = new Menu do
    d3.select \.reasonsList
    null
    basedata

menu.graphs = graphs = new Graphs do
    d3.select \.reasonsGraph
    menu
    [1919 2006]
    basedata
    {width: windowWidth - 200, height: 600}
# graphs.drawStacked!
graphs.draw!

stackedOrNotSelector = new StackedOrNotSelector do
    d3.select \#content
    graphs


maleFemaleBothSelector = new MaleFemaleBothSelector do
    d3.select \#content
    basedata
    graphs
