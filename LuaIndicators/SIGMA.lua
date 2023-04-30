--[=====[
	TODO: описать что делает этот код
	TODO: дать адекватное название индикатору
	TODO: привести в порядок стайл кода
	TODO: подготовить для работы на верии Lua 5.4.1
--]=====]
Settings=
{
	Name = "(custom)Sigma",
	period = 10,
	signC = 3,
	line =
	{
		{
			Name = "sig1",
			Color = RGB(255, 150, 0),
			Type = TYPE_LINE,
			Width = 2
		},
		{
			Name = "MA",
			Color = RGB(0, 200, 255),
			Type = TYPE_LINE,
			Width = 2
		},
		{
			Name = "sig2",
			Color = RGB(255, 150, 0),
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
		sig = 0
		sigT = 0
		xn = Settings.period
		xsr=0
		for i=index-xn+1, index-1 do
			xsr = xsr + C(i)
		end
		xsr = xsr/(xn-1)
		for i=index-xn+1, index-1 do
			sig = sigT+math.pow(C(i)-xsr, 2)
		end
		--sigT = C(index-1)+3*math.pow(sig/(xn-1), 0.5)
		--sigB = C(index-1)-3*math.pow(sig/(xn-1), 0.5)
		sigT = xsr+Settings.signC*math.pow(sig/(xn), 0.5)
		sigB = xsr-Settings.signC*math.pow(sig/(xn), 0.5)
		return sigT, xsr, sigB
	end	
end
