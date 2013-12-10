yearsTotal = []
yearRange = [1919 to 2006]
colorRange = d3.scale.category20!
window.utils =
    formatPrice : (price) ->
        price .= toString!
        out = []
        len = price.length
        for i in [0 til len]
            out.unshift price[len - i - 1]
            if 2 == i % 3 and i isnt len - 1
                out.unshift ' '
        out.join ''

    csvTransform: (row, index) ->
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
        {id, name, abbreviation, color, years}
