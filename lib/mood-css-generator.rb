
mood_list = {
  alive:        'ffff00',
  open:         'ffaa00',
  happy:        '31ba21',
  good:         '08b663',
  love:         'ff6108',
  interested:   'def37b',
  positive:     '009252',
  strong:       'ffeba5',

  angry:        'ff0400',
  depressed:    '003c73',
  sad:          '2175bd',
  confused:     'ffe3ad',
  hurt:         'c6d7ef',
  helpless:     '001494',
  indifferent:  'e76db5',
  afraid:       'ffe729'
}

mood_list.each do |n, c|
  puts " ul#analysis-timeline li .#{n} { background-color: ##{c}; }"
end

puts mood_list.keys.join(', ')

