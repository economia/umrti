new Tooltip!watchElements!
return unless Modernizr.svg
d3.selectAll \.fallback .remove!
windowWidth = window.innerWidth

(err, basedata) <~ d3.csv do
    "../data/summary-both.csv"
    utils.csvTransform

menu = new Menu do
    d3.select \.reasonsList
    null
    basedata
details = new Details do
    d3.select \.details
    basedata
    histogramWidth: windowWidth - 220
histogram = new Histogram do
    d3.select \.histogram
    {width: windowWidth - 200, height: 600}

menu.graphs = graphs = new Graphs do
    d3.select \.reasonsGraph
    menu
    details
    histogram
    [1919 2006]
    basedata
    {width: windowWidth - 200, height: 600}

# graphs.drawStacked!
graphs.draw!
# graphs.drawSingle 2
# details.display 3 1997 \both

# histogram.draw 20, \both


stackedOrNotSelector = new StackedOrNotSelector do
    d3.select \#content
    graphs
