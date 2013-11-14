require! {
    fs
    csv
    async
}
generate-category-biggest-killers = (cb) ->
    categories = []
    c = csv!.from.stream fs.createReadStream "#__dirname/../data/klic.csv"
        ..on \record ([name, external, y1994, y1979, y1968, y1958, y1949, y1941, y1931, y1925, y1919], index) ->
            return if name == 'Kategorie'
            is_external = external is 'e'
            id = index - 2 + 1 # minus header, minus totals, one based
            categories.push {name, id, is_external, y1994, y1979, y1968, y1958, y1949, y1941, y1931, y1925, y1919}
    <~ c.on \end
    categories.shift! # remove totals line
    # categories.length = 1
    (err, results) <~ async.each categories, (category, cb) ->
        rangeInUse = null
        (err, sums) <~ async.eachSeries [1919 to 2006], (year, cb) ->
            use_external = category.is_external and year >= 1949
            if category.["y#year"]
                rangeInUse := that.split "+" .map -> it.split "-" .map -> parseInt it, 10 # code & forget ftw
                rangeInUse.forEach -> if it.length == 1 then it.push it.0
            filename = "#__dirname/../data/csv_normalized/#{year}"
            suffix = if use_external then "e" else ""

            (err, women) <~ get-category-parts "#{filename}z#{suffix}.csv", rangeInUse
            (err, men) <~ get-category-parts "#{filename}m#{suffix}.csv", rangeInUse
            both = women.map (subcategory, subcategoryIndex) ->
                subcategory.map (cell, index) ->
                    | index == 0 => cell
                    | otherwise  => cell + men[subcategoryIndex][index]
            [women, men, both].forEach -> it.sort (a, b) -> b.1 - a.1
            header =
                | year < 1949 => <[subcategory total 0 1-4 5-9 10-14 15-19 20-29 30-39 40-59 60-79 80+ unknown]>
                | year < 1960 => <[subcategory total 0 1 2 3 4 5-14 15-24 25-34 35-44 45-54 55-64 65-74 75-84 85+ unknown]>
                | otherwise   => <[subcategory total 0 1 2 3 4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 65-69 70-74 75-79 80-84 85]>
            parts =
                *   name: \women
                    data: women
                *   name: \men
                    data: men
                *   name: \both
                    data: both
            console.log "#{category.name}, #year"
            <~ async.each parts, ({name, data}, cb)->
                data.unshift header
                c2 = csv!.from.array data
                    .to.stream fs.createWriteStream "#__dirname/../data/csv_details/#{category.id}-#{year}-#{name}.csv"
                <~ c2.on \end
                cb!
            cb!

        cb!



get-category-parts = (filename, range, cb) ->
    lines = []
    c = csv!.from.stream fs.createReadStream filename
        ..on \record (data, index) ->
            lineno = index + 1
            lines[lineno] = data
    <~ c.on \end
    output = []
    range.forEach ([lineFrom, lineTo]) ->
        for lineno in [lineFrom to lineTo]
            if lines[lineno]
                outputData = that.slice 1
                    .map (cell, index) ->
                        if index == 0 # subcategory title
                            cell
                        else
                            (parseInt cell, 10) || 0
                output.push outputData

    cb null output

generate-category-biggest-killers!
