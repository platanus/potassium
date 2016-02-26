languages = {
  es: "Spanish",
  en: "English"
}

lang = answer(:lang) do
  languages.keys[Ask.list("What is the main language of your app?", languages.values)]
end

set(:lang, lang)
