d3.selectAll \.fallback .remove!
yearRange = [1919 to 2006]
windowWidth = window.innerWidth
colorRange = d3.scale.category20!
yearsTotal = []
(err, basedata) <~ d3.csv do
    "../data/summary-both.csv"
    (row, index) ->
        name = row.name
        id = index
        abbreviation = abbreviations[name]
        color = colorRange name
        years = for year, yearIndex in yearRange
            value = +row[year]
            normalized =
                | index > 0 => value / yearsTotal[yearIndex].value
                | otherwise => 1
            {year, value, normalized}
        if index == 0
            yearsTotal := years
        return {id, name, abbreviation, color, years}

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
graphs.drawStacked!
# graphs.draw!

stackedOrNotSelector = new StackedOrNotSelector do
    d3.select \#content
    graphs

