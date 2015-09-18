languages = {
  "Spanish" => "es",
  "English" => "en"
}

lang = languages.values[Ask.list("What is the main language of your app?", languages.keys)]

set(:lang, lang)
