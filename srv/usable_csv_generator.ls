require! {
    fs
    csv
    async
}
generate-summary = (cb) ->
    categories = []
    c = csv!.from.stream fs.createReadStream "#__dirname/../data/klic.csv"
        ..on \record ([name, external, y1994, y1979, y1968, y1958, y1949, y1941, y1931, y1925, y1919]) ->
            return if name == 'Kategorie'
            is_external = external is 'e'
            categories.push {name, is_external, y1994, y1979, y1968, y1958, y1949, y1941, y1931, y1925, y1919}
    <~ c.on \end
    (err, results) <~ async.map categories, (category, cb) ->
        rangeInUse = null
        (err, sums) <~ async.mapSeries [1919 to 2006], (year, cb) ->
            use_external = category.is_external and year >= 1949
            if category.["y#year"]
                rangeInUse := that.split "+" .map -> it.split "-" .map -> parseInt it, 10 # code & forget ftw
                rangeInUse.forEach -> if it.length == 1 then it.push it.0
            filename = "#__dirname/../data/csv_normalized/#{year}"
            suffix = if use_external then "e" else ""
            (err, women) <~ get-file-sums "#{filename}z#{suffix}.csv", rangeInUse
            (err, men) <~ get-file-sums "#{filename}m#{suffix}.csv", rangeInUse
            console.log "#{category.name}, #year: #women, #men"
            cb null, {women, men, both: women + men}

        cb null, {name: category.name, sums}

    header = [ \name ] ++ [1919 to 2006]
    <~ async.each <[men women both]>, (gender, cb) ->
        genderResults = results.map -> [it.name] ++ it.sums.map -> it[gender]
        genderResults.unshift header
        c2 = csv!.from.array genderResults
            .to.stream fs.createWriteStream "#__dirname/../data/summary-#gender.csv"
        <~ c2.on \end
        cb!
    cb?!


get-file-sums = (filename, range, cb) ->
    lines = []
    c = csv!.from.stream fs.createReadStream filename
        ..on \record (data, index) ->
            lineno = index + 1
            lines[lineno] = data
    <~ c.on \end
    sum = 0
    range.forEach ([lineFrom, lineTo]) ->
        for lineno in [lineFrom to lineTo]
            data = lines[lineno]
            value = data[2].replace /[ ]+/g ""
            if parseInt value, 10 then sum += that
    cb null sum

# (err, v) <~ get-file-sums "#__dirname/../data/csv_normalized/1949m.csv", [[4 4]]
generate-summary!
