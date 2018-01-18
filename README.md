# HTML to PDF Explorations

Inspired by [Evadne Wu's Elixir London 2016 talk][1], I decided to use my
[HelloSign][2] hackathon to explore how to improve the overhead of using
`wkhtmltopdf` with `System.cmd`.

I've created a simple C server that accepts commands over stdin which uses
`wkhtmltopdf`'s C bindings to perform the conversion.

`HtmlToPdf.run\0` performs a basic benchmark. On my 2 core 2.5 GHz i7
Macbook Pro, I see approximately 30%-40% speedup.


