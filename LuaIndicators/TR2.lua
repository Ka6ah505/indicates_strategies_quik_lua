--[=====[
	TODO: описать что делает этот код
	TODO: дать адекватное название индикатору
	TODO: привести в порядок стайл кода
	TODO: подготовить для работы на верии Lua 5.4.1
--]=====]
Settings=
{
	Name = "(custom)C1/C2v2",
	period = 10,
	spred = 0.02,
	pribl = 2,
	line =
	{
		{
			Name = "CC1",
			Color = RGB(255, 0, 0),
			Type = TYPE_LINE,
			Width = 2
		},
		{
			Name = "CC2",
			Color = RGB(0, 0, 255),
			Type = TYPE_LINE,
			Width = 2
		}
	},
	Horizontal_line="off"
}
function Init()
	return #Settings.line
end

function OnCalculate(index)
	if index < Settings.period then
		return nil
	else 
		topN = 0
		botN = 0
		xn = Settings.period
		for i=index-xn+1, index do
			if O(i)-C(i) < 0 then --math.pow (x, y) candle uo
				topN = topN + math.pow(math.pow(H(i),Settings.pribl) + math.pow(C(i),1/Settings.pribl), 1/Settings.pribl)
				botN = botN + math.pow(math.pow(L(i),Settings.pribl) + math.pow(O(i),1/Settings.pribl), 1/Settings.pribl)
			else --candl down
				topN = topN + math.pow(math.pow(H(i),Settings.pribl) + math.pow(O(i),1/Settings.pribl), 1/Settings.pribl)
				botN = botN + math.pow(math.pow(L(i),Settings.pribl) + math.pow(C(i),1/Settings.pribl), 1/Settings.pribl)
			end
		end
		tAVR = topN/xn
		bAVR = botN/xn

		t = GetValue(index-1, 1)
		b = GetValue(index-1, 2)
		if t == nil or b == nil then 
			t = tAVR
			b = bAVR
		end
		if math.abs(tAVR - t) < Settings.spred then
			tAVR = t
		end
		if math.abs(bAVR - b) < Settings.spred then
			bAVR = b
		end
		return tAVR, bAVR
	end	
end
