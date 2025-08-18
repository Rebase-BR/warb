# frozen_string_literal: true

class String
  def normalize
    unicode_normalize(:nfd).gsub(/\p{Mn}/, '')
  end
end
