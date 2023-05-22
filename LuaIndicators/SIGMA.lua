--[=====[
	TODO: описать что делает этот код
	TODO: дать адекватное название индикатору
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
	if index-1 < Settings.period then
		return nil
	else 
		sig = 0
		sum_squared = 0
		xn = Settings.period
		avg_close=0
		for i=index-xn, index-1 do
			avg_close = avg_close + C(i) -- сумма N предыдущих закрытий
		end
		avg_close = avg_close/xn
		for i=index-xn+1, index-1 do
			sum_squared = sum_squared + (C(i)-avg_close)^2 -- сумма квадратов отклонений
		end

		sig = (sum_squared / xn) ^ 0.5
		sigT = avg_close + Settings.signC * sig
		sigB = avg_close - Settings.signC * sig
		return sigT, avg_close, sigB
	end	
end
