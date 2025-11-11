#let yellowline() = {
  line(length: 100%, stroke: 1pt + rgb("#ffc107"))
}

#let info_box(info_box_text) = {
  show "Note:": strong

  box(
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
  let yellow = rgb("#ffc107")
  let blue = rgb("#026AB5")
  let title_font = "Montserrat"
  let paragraph_font = "Georgia"
  let toc_title = "Table of Contents"

  // text style for paragraphs
  set text(
    lang: "en",
    region: "US",
    font: (paragraph_font, "Times New Roman", "Arial"),
    size: 11pt,
    weight: "light",
    style: "italic",
  )

  // increase font size in bullet points
  show list: it => {
    set text(size: 12pt, style: "normal", font: title_font, weight: 400)
    it
  }

  // increase marker size in bullet points
  set list(marker: text(30pt, [•], baseline: -9pt))

  // overall style (footer/header, margins)
  set page(
    paper: "us-letter",
    margin: (x: 0.5in, bottom: 1in),
    footer: context {
      // footer middle element depends on the page
      let middle_footer = if here().page() == 1 {
        place(center + horizon, image("logo.png", width: 0.4in))
      } else {
        text(
          fill: white,
          weight: 600,
          size: 14pt,
          style: "normal",
          font: title_font,
        )[austinecho.org]
      }
      rect(
        width: 100%,
        height: 0.75in,
        outset: (x: 15%), // allow footer to grow over margins
        fill: blue,
        align(center + horizon)[#block(width: 100%, [
          #grid(
            columns: (1.8fr, 1fr, 1.8fr),
            inset: (x: 15%),
            align(left)[#text(
              fill: white,
              weight: 400,
              size: 14pt,
              font: title_font,
              style: "normal",
            )[#strong[State] of the #strong[HRS]]],
            align(center)[#middle_footer],
            align(right)[#text(fill: white, weight: 400, size: 14pt)[#date]],
          )
          #place(right + horizon, dx: 20pt)[#text(
            fill: white,
            weight: 400,
            size: 16pt,
            font: title_font,
          )[#here().page()]]
        ])],
      )
    },
    header: {
      rect(
        width: 100%,
        height: 0.75in,
        outset: (x: 15%), // allow header to grow over margins
        fill: yellow,
        align(center + horizon)[#block(width: 120%, [
          #text(
            fill: black,
            font: title_font,
            weight: 800,
            style: "normal",
            size: 12pt,
            tracking: 8pt, // spacing between letters
          )[Ending Community Homelesness Coalition]])],
      )
    },
  )

  // table of contents
  text(
    toc_title,
    fill: blue,
    size: 24pt,
    weight: 600,
    font: title_font,
    style: "normal",
  )
  block(
    inset: 15pt,
    stroke: blue + 2pt,
    below: 200pt,
  )[
    #show outline.entry.where(level: 1): set block(above: 20pt)
    #show outline.entry.where(level: 1): set text(size: 16pt, weight: 600, font: title_font, style: "normal")
    #show outline.entry.where(level: 1): it => block[#it]
    #outline(title: none, depth: 1);
  ]

  info_box(
    "The Ending Community Homelessness Coalition (ECHO) is the backbone of our community's Homelessness Response System. As the lead agency for the Austin/Travis County Continuum of Care, we lead and align a coalition responsible for planning and implementing community-wide strategies to end homelessness. We work alongside people with firsthand experience of homelessness and nonprofit, government, and philanthropic partners to build a future in which everyone in our community has housing of their choice that provides a foundation for optimal health, success, and stability. Learn more: austinecho.org",
  )

  // we set this AFTER the table of contents
  // set page(columns: 2)

  // dynamically style headings depending on the level
  show heading: it => {
    let sizes = (
      "1": 17pt,
      "2": 16pt,
      "3": 14pt,
      "4": 12pt,
    )
    let level = str(it.level)
    let size = if level in sizes { sizes.at(level) } else { 10pt }
    let heading_color = blue

    set text(
      size: size,
      fill: blue,
      font: title_font,
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


  // all the content from the Quarto document (text, graphs, code, etc)
  pagebreak()
  content
}
