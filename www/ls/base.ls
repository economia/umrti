new Tooltip!watchElements!
return unless Modernizr.svg
d3.selectAll \.fallback .remove!
windowWidth = window.innerWidth

(err, basedata) <~ d3.csv do
    "../data/summary-both.csv"
    utils.csvTransform

menu = new Menu do
    d3.select \.reasonsList
    null # graphs - monkey-patch later
    null # curtain - monkey-patch later
    basedata
details = new Details do
    d3.select \.details
    basedata
    histogramWidth: windowWidth - 280
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
    {width: windowWidth - 200, height: 470}

stackedOrNotSelector = new StackedOrNotSelector do
    d3.select \#content
    graphs

menu.redraw!
menu.curtain = curtain = new Curtain do
    d3.select \.reasonsGraph
    graphs~x
    200

stories = new Stories do
    d3.select \#story
    curtain
    menu
    graphs
    stackedOrNotSelector
    details
