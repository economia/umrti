require! {
    fs
    csv
    async
}
generate-summary = ->
    categories = []
    c = csv!.from.stream fs.createReadStream "#__dirname/../data/klic.csv"
        ..on \record ([name, is_external, y1994, y1979, y1968, y1958, y1949, y1941, y1931, y1925, y1919]) ->
            return if name == 'Kategorie'
            categories.push {name, is_external, y1994, y1979, y1968, y1958, y1949, y1941, y1931, y1925, y1919}

    <~ c.on \end



generate-summary!
