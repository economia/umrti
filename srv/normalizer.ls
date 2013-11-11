require! {
    csv
    fs
    iconv.Iconv
    async
}
iconv = new Iconv 'CP1250' 'UTF8'
dir = "#__dirname/../data/csv"
(err, files) <~ fs.readdir dir
<~ async.each files, (file, cb) ->
    (err, data) <~ fs.readFile "#dir/#file"
    <~ fs.writeFile "#dir/#file" iconv.convert data
    cb!
console.log "Done!"
process.exit!
