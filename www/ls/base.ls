d3.selectAll \.fallback .remove!
yearRange = [1919 to 2006]
windowWidth = window.innerWidth
colorRange = d3.scale.ordinal!
    .range <[#000000 #E41A1C #377EB8 #4DAF4A #984EA3 #FF7F00 #FFFF33 #A65628 #F781BF #999999 #FBB4AE #B3CDE3 #CCEBC5 #DECBE4 #FED9A6 #FFFFCC #E5D8BD #FDDAEC #F2F2F2 #B2DF8A #FDBF6F ]>
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
            console.log years
            yearsTotal := years
        return {id, name, abbreviation, color, years}

menu = new Menu do
    d3.select \.reasonsList
    basedata

graphs = new Graphs do
    d3.select \.reasonsGraph
    [1919 2006]
    basedata
    {width: windowWidth - 300, height: 600}
graphs.draw!
