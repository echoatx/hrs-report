#let report(
  title: none,
  date: none,
  author: none,
  content,
) = {
  set page(
    paper: "us-letter",
    margin: (top: 0.5in, bottom: 0.5in, x: 1in),
    footer: {
      rect(
        width: 100%,
        height: 0.3in,
        outset: (x: 25%),
        fill: rgb("#2373b9"),
        block([
          #grid(
            columns: (33%, 33%, 33%),
            align(center)[
              #text(
                title,
                fill: white,
                weight: "bold",
              )
            ],
            align(center)[
              #text(
                "austinecho.org",
                fill: white,
                weight: "bold",
              )
            ],
            align(center)[
              #text(
                date,
                fill: white,
                weight: "bold",
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

  show heading: set text(
    font: "Lora",
    fill: rgb("#2373b9"),
    size: 20pt,
    weight: "bold",
    style: "normal",
  )

  content
}
