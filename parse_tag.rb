def get_captures(matches)
  matches.captures.select{ |match| match != nil }[0]
end

def parse_tag(tag_string)
  tag = {}

  if match = (/class='(.*?)'|class="(.*?)"/).match(tag_string)
    tag[:classes] = get_captures(match).split(' ')
  end
  if match = (/id='(.*?)'|id="(.*?)"/).match(tag_string)
    tag[:id] = get_captures(match)
  end
  if match = (/name='(.*?)'|name="(.*?)"/).match(tag_string)
    tag[:name] = get_captures(match)
  end
  if match = (/<(.*?) /).match(tag_string)
    tag[:tag] = match.captures[0]
  end

  puts tag
end

tag = parse_tag("<p class='foo bar' id='baz' name='fozzie'>")
# tag[:name] #=> "p"
# tag[:classes] #=> ["foo", "bar"]
# tag[:id] #=> "baz"
# tag[:name] #=> "fozzie"