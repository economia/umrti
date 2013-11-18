window.Histogram = class Histogram
    categories:
        "1919":
            [0 0]
            [1 4]
            [5 9]
            [10 14]
            [15 19]
            [20 29]
            [30 39]
            [40 59]
            [60 79]
            [80 89]

        "1949":
            [0 0]
            [1 1]
            [2 2]
            [3 3]
            [4 4]
            [5 14]
            [15 24]
            [25 34]
            [35 44]
            [45 54]
            [55 64]
            [65 74]
            [75 84]
            [85 89]

        "1960":
            [0 0]
            [1 1]
            [2 2]
            [3 3]
            [4 4]
            [5 9]
            [10 14]
            [15 19]
            [20 24]
            [25 29]
            [30 34]
            [35 39]
            [40 44]
            [45 49]
            [50 54]
            [55 59]
            [60 64]
            [65 69]
            [70 74]
            [75 79]
            [80 84]
            [85 89]

    (@parentElement, {@width, @height}) ->
        @parentElement.style \width "#{@width}px"

    draw: (id, gender) ->
        (err, data) <~ d3.csv "../data/csv_histograms/#id-#gender.csv"
        x = d3.scale.linear!
            ..domain [0 data.length]
            ..range [0 @width]
        y = d3.scale.linear!
            ..domain [0 90]
            ..range [0 @height]
        datapoints = []
        maxVal = -Infinity
        currentCategory = null
        for row, xPos in data
            year = row['year']
            if @categories[year]
                currentCategory = that
            continue if not currentCategory
            cells = [1 to currentCategory.length].map -> row["C#it"]
            for cell, yPos in cells
                val = +cell
                category = currentCategory[yPos]
                y0 = y category.0
                y1 = y category.1 + 1
                if maxVal < val
                    maxVal = val
                datapoints.push do
                    x: x xPos
                    y: y0
                    height: y1 - y0
                    category: category
                    val: val
                    year: year
        color = d3.scale.linear!
            ..domain [0, maxVal * 0.125, maxVal * 0.25, maxVal * 0.375, maxVal * 0.5, maxVal * 0.625, maxVal * 0.75, maxVal * 0.875, maxVal]
            ..range <[ #FFFFCC #FFEDA0 #FED976 #FEB24C #FD8D3C #FC4E2A #E31A1C #B10026 ]>
        width = "#{x 1}px"
        height = "#{y 1}px"
        @parentElement.selectAll \div
            .data datapoints
            .enter!append \div
                ..style \width width
                ..style \height -> "#{it.height}px"
                ..style \top -> "#{it.y}px"
                ..style \left -> "#{it.x}px"
                ..style \background-color -> "#{color it.val}"
                ..attr \data-tooltip -> "#{it.year}, #{it.category.0} - #{it.category.1}: #{it.val}"
