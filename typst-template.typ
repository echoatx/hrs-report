#let report(title: none, date: none, doc) = {
  set page(
    paper: "us-letter",
    margin: (x: 0.5in, bottom: 1in),
    footer: context {
      rect(
        width: 100%,
        height: 0.75in,
        outset: (x: 15%), // allow footer to grow over margins
        fill: blue,
      )[#here().page()]
    },
  )

  show par: set text(
    style: "italic",
  )

  show heading: heading_style => {
    let sizes = (
      "1": 27pt,
      "2": 16pt,
      "3": 14pt,
      "4": 12pt,
    )

    let level = str(heading_style.level)
    let size = if level in sizes { sizes.at(level) } else { 10pt }

    set text(
      size: size,
      fill: red,
    )
    heading_style
  }


  doc
}
