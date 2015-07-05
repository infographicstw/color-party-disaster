<- $ document .ready
(data) <- d3.csv \stat.csv
console.log data
hash = {}
dates = []
rc = 39
delay = 2000
color-by-cat = remain: \#67b238, icu: \#efb639, danger: \#e13123, ecmo: \#771d18, death: \#333333
cname = remain: \一般病房, icu: \加護病房, danger: \病危, ecmo: \使用葉克膜, death: \死亡
order = remain: 0, icu: 1, danger: 2, ecmo: 3, death: 4
for line in data
  date = line["日期"]
  dates.push date
  icu = parseInt(line["加護病房"])
  danger = parseInt(line["病危數"])
  ecmo = parseInt(line["葉克膜"])
  death = parseInt(line["死亡"])
  count = parseInt(line["傷患數"])
  if !isNaN(ecmo) => 
    icu = icu - ecmo
    if !isNaN(danger) => danger = danger - ecmo
  if !isNaN(danger) => icu = icu - danger
  list = []
  for i from 0 til icu => list.push {icu: true, color: color-by-cat[\icu], order: order[\icu]}
  for i from 0 til danger => list.push {danger: true, color: color-by-cat[\danger], order: order[\danger]}
  for i from 0 til ecmo => list.push {ecmo: true, color: color-by-cat[\ecmo], order: order[\ecmo]}
  for i from 0 til death => list.push {death: true, color: color-by-cat[\death], order: order[\death]}
  remain = count - list.length
  for i from 0 til remain => list.push {color: color-by-cat[\remain], order: order[\remain]}
  list.sort (a,b) -> b.order - a.order
  for item in list =>
    hsl = tinycolor(item.color).toHsl!
    hsl.l = hsl.l / 2
    item.border = tinycolor(hsl).toHexString!
  if !isNaN(ecmo) =>
    if !isNaN(danger) => danger = danger + ecmo
    icu = icu + ecmo
  if !isNaN(danger) => icu = icu + danger
  hash[date] = {date, count, icu, danger, ecmo, death, list,remain} 

colors = <[#dcd38e #cda06a #c67f39 #bc6029 #b1270b #6c090e]>
colormap = d3.scale.ordinal!domain [0 to 100 by 100/(colors.length - 1)] .range colors

init-chart = (data) ->
  list = data.list
  d3.select \#legend .selectAll \g .data [{name: cname[k], color: [v], count: data[k]} for k,v of color-by-cat]
    ..enter!append \g 
      ..append \circle .attr do
        cx: (it, idx) -> idx * 80
        cy: 0
        r: 10
        fill: -> it.color
      ..append \text 
        ..attr do
          x: (it, idx) -> idx * 80
          y: 20
          fill: \#ddd
          "dominant-baseline": "central"
          "text-anchor": "middle"
          "font-size": 12
        ..text -> it.name
      ..append \text
        ..attr do
          class: \count
          x: (it, idx) -> idx * 80
          y: 35
          fill: \#ddd
          "dominant-baseline": "central"
          "text-anchor": "middle"
          "font-size": 12
    d3.select \#legend .selectAll \g .select \text.count .text -> if isNaN(it.count) => "-" else it.count

  d3.select \#svg .selectAll \g.victim .data list
    ..enter!append \g
      ..attr do
        class: \victim
        transform: (it, idx) ->  
          x = idx % rc
          y = parseInt(idx / rc)
          "translate(#{x * 180} #{y * 360}) scale(1.0)"
      ..append \rect .attr do
        width: 180
        #height: -> 20 + it.area * 340 / 100
        x: 0
        #y: -> 340 - it.area * 340 / 100
        #fill: -> colormap it.area #\#f00
        "clip-path": 'url(#clip-man)'
        
      ..append \use .attr do
        x: 0
        y: 0
        stroke: \#720
        "stroke-width": 8
        fill: -> \#000
        "xlink:href": '#shape-man'
        filter: 'url(#shadow)'
    ..exit!remove!

update-chart = ->
  d3.select \#svg .selectAll \g.victim .transition!duration delay/2 .attr do
    transform: (it, idx) ->  
      x = idx % rc
      y = parseInt(idx / rc)
      "translate(#{x * 20} #{y * 35}) scale(0.1)"
  d3.select \#svg .selectAll \g.victim .select \use .transition!duration delay/2 .attr do
    fill: -> it.color
    stroke: -> it.border

set-date = (date) ->
  d3.select \#text .text "2015 #{date}"
  init-chart hash[date]
  update-chart!

idx = 0
iterate = ->
  set-date dates[idx]
  idx := (idx + 1) % (dates.length)
setInterval (-> iterate!), delay
iterate!
