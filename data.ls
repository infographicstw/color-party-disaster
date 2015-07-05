require! <[fs]>
data = do
  "台中榮總": 90: 1, 70: 1, 50: 2, 40: 1, 20: 1, icu: 4, die: 1
  "中國附醫": 90: 1, 70: 1, 50: 1, 40: 1, 20: 1, 10: 1, icu: 4
  "童綜合": 80: 1, 50: 1, 40: 1, 20: 1, 0: 1, icu: 3, liz: 1
  "中山附醫": "-1": 1
  "台中醫院": 40: 1, 30: 1, icu: 2
  "全民醫院": 40: 1
  "彰基": 40: 3, 30: 1
  "秀傳": 20: 1
  "嘉基": 50: 1, icu: 1
  "嘉義長庚": 30: 1, 10: 1, icu: 2
  "奇美": 50: 1, icu: 1, liz: 1
  "成大": 90: 1, 60: 1, 50: 1, 40: 1, icu: 4
  "國軍左營": 50: 1, 40: 2, 0: 1, icu: 3, liz: 2
  "高雄長庚": 70: 1, 60: 2, 40: 2, 30: 1, icu: 5, liz: 2
  "義大": 80: 1, icu: 1
  "台北馬偕": 90: 1, 80: 2, 70: 3, 50: 11, 20: 8, icu: 17, liz: 12
  "淡水馬偕": 90: 1, 80: 2, 70: 3, 50: 11, "-1": 9, liz: 10
  "新光醫院": 90: 2, 80: 2, 40: 12, "-1": 9, icu: 13, liz: 10
  "國泰醫院": "-1": 13, icu: 9
  "台北榮總": "-1": 38, icu: 24, 
  "台大醫院": "-1": 27, icu: 16, liz: 11
  "林口長庚": "-1": 44, icu: 39
  "三總": "-1": 55, liz: 22

result = []
for hospital, stat of data
  for k,v of stat
    k = parseInt(k)
    if isNaN(k) => continue
    for i from 0 til v => result.push k
result.sort!
console.log result, result.length
fs.write-file-sync \degree.json, JSON.stringify(result)
