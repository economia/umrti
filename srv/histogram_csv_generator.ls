require! {
    fs
    csv
    async
}
generate-summary = (cb) ->
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
    (err, results) <~ async.map categories, (category, cb) ->
        rangeInUse = null
        (err, sums) <~ async.mapSeries [1919 to 2006], (year, cb) ->
            if year < 1925 and category.name == "Dopravní nehody"
                men = women = both = [0 0 0 0 0 0 0 0 0 0 0 0]
                cb null, {women, men, both}
                return
            use_external = category.is_external and year >= 1949
            if category.["y#year"]
                rangeInUse := that.split "+" .map -> it.split "-" .map -> parseInt it, 10 # code & forget ftw
                rangeInUse.forEach -> if it.length == 1 then it.push it.0
            filename = "#__dirname/../data/csv_normalized/#{year}"
            suffix = if use_external then "e" else ""
            (err, women) <~ get-file-sums "#{filename}z#{suffix}.csv", rangeInUse
            (err, men) <~ get-file-sums "#{filename}m#{suffix}.csv", rangeInUse
            both = for val, index in women
                women[index] + men[index]
            women.unshift year
            men.unshift year
            both.unshift year
            console.log "#{category.name}, #year", women
            cb null, {women, men, both}
        parts =
            *   gender: \women
                data: sums.map -> it["women"]
            *   gender: \men
                data: sums.map -> it["men"]
            *   gender: \both
                data: sums.map -> it["both"]
        header = <[year total C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22]>
        <~ async.each parts, ({gender, data}, cb)->
            data.unshift header
            c2 = csv!.from.array data
                .to.stream fs.createWriteStream "#__dirname/../data/csv_histograms/#{category.id}-#{gender}.csv"
            <~ c2.on \end
            cb!
        cb!
    cb?!

get-file-sums = (filename, range, cb) ->
    lines = []
    c = csv!.from.stream fs.createReadStream filename
        ..on \record (data, index) ->
            lineno = index + 1
            lines[lineno] = data
    <~ c.on \end
    ouput = null
    for [lineFrom, lineTo] in range
        for lineno in [lineFrom to lineTo]
            line = lines[lineno]
            histo = line.slice 2 .map -> (parseInt (it.replace /[ ]+/g ""), 10) || 0
            if ouput
                for val, i in ouput
                    ouput[i] += histo[i]
            else
                ouput = histo
    if ouput is null
        console.log \null, filename, range
    # console.log ouput
    cb? null ouput

# get-file-sums "#__dirname/../data/csv_normalized/1953ze.csv", [[7 9]]
generate-summary!
