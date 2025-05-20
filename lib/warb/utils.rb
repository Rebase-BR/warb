class String
  def normalize
    unicode_normalize(:nfd).gsub(/\p{Mn}/, "")
  end
end
