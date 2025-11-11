#let yellowline() = {
  line(length: 100%, stroke: 1pt + rgb("#ffc107"))
}


#let info_box(info_box_text) = {
  show "Note:": strong

  block(
    fill: rgb("#fdeab2"),
    width: 100%,
    inset: 12pt,
    [#info_box_text],
  )
}

#let report(
  title: none,
  date: none,
  author: none,
  content,
) = {
  set page(
    paper: "us-letter",
    margin: (top: 0.5in, bottom: 0.5in, x: 0.5in),
    header: {
      rect(
        width: 100%,
        height: 0.5in,
        outset: (x: 25%), // allow header to grow over margins
        fill: rgb("#ffc107"),
        align(center + horizon)[#block(width: 120%, [
          #text(
            fill: black,
            font: "Montserrat",
            weight: 800,
            style: "normal",
            size: 11pt,
            tracking: 8pt, // spacing between letters
          )[Ending Community Homelesness Coalition]])],
      )
    },
    footer: {
      rect(
        width: 100%,
        height: 0.4in,
        outset: (x: 25%),
        fill: rgb("#2373b9"),
        block([
          #grid(
            columns: (33%, 33%, 33%),
            align(center)[
              #text(
                title,
                font: "Montserrat",
                fill: white,
                weight: "bold",
                style: "normal",
              )
            ],
            align(center)[
              #text(
                "austinecho.org",
                font: "Montserrat",
                fill: white,
                weight: "bold",
                style: "normal",
              )
            ],
            align(center)[
              #text(
                date,
                fill: white,
                style: "normal",
              )
            ],
          )
        ]),
      )
    },
  )

  set text(
    lang: "en",
    region: "US",
    font: "Lora",
    size: 11pt,
    style: "italic",
  )

  // dynamically style headings depending on the level
  show heading: it => {
    let sizes = (
      "1": 20pt,
      "2": 16pt,
      "3": 14pt,
      "4": 12pt,
    )
    let level = str(it.level)
    let size = if level in sizes { sizes.at(level) } else { 10pt }

    set text(
      size: size,
      fill: rgb("#2373b9"),
      font: "Montserrat",
      style: "normal",
      weight: "bold",
    )

    if level == "1" {
      // add yellow lines before/after headings
      stack(
        spacing: 0.7em,
        yellowline(),
        it,
        yellowline(),
      )
    } else {
      it
    }
  }


  content
}
