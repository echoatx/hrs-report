#show: doc => report(
  $if(title)$
    title: [$title$],
  $endif$
  $if(date)$
    date: [$date$],
  $endif$
    doc,
)