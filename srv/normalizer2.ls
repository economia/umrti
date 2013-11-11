require! {
    csv
    fs
    async
}
sourceDir = "#__dirname/../data/csv"
targetDir = "#__dirname/../data/csv_normalized"
tranformFile = (file, stream, delimiter, cb) ->
    c = csv!
        .from.stream stream, {delimiter}
        .to.path "#targetDir/#file", {delimiter: ","}
    c
        # ..on \record (line) ->
        #     console.log line
        ..on \error ->
            cb it
        ..on \end ->
            cb null
(err, files) <~ fs.readdir sourceDir
async.eachLimit files, 10, (file, cb) ->
    (err, data) <~ fs.readFile "#sourceDir/#file"
    firstLine = data.toString!split "\n" .0
    countSemicolon = firstLine.split ";" .length
    countTab = firstLine.split "\t" .length # that's quick and dirty!
    delimiter =
        | countSemicolon > countTab => ";"
        | otherwise => "\t"
    stream = fs.createReadStream "#sourceDir/#file"
    (err) <~ tranformFile file, stream, delimiter
    console.log "Done #file"
    cb!

