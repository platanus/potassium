module AnswerHelpers
  def answer(key, &fallback)
    found = get(:answers)[key]
    found.nil? ? fallback.call : found
  end

  def load_answers
    set(:answers, extract_answers(self.class.cli_options))
  end

  private

  def extract_answers(options)
    options.except("version-check", :"version-check").reduce({}) do |hash, (k, v)|
      hash.merge(k => v == "none" ? nil : v)
    end
  end
end
