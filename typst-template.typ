#let report(
  title: none,
  content,
) = {
  set page(
    paper: "us-letter",
    margin: (top: 0.5in, bottom: 1in, x: 1in),
  )

  set text(
    lang: "en",
    region: "US",
    font: "Comic Sans MS",
    size: 11pt,
  )

  content
}
