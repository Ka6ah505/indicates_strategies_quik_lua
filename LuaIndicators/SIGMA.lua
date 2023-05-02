--[=====[
	TODO: описать что делает этот код
	TODO: дать адекватное название индикатору
	TODO: привести в порядок стайл кода
	TODO: подготовить для работы на верии Lua 5.4.1
	TODO: Кажется формула не верная. Нужно сдедать как в примере 
		https://ru.wikipedia.org/wiki/Среднеквадратическое_отклонение
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
		sigT = 0
		xn = Settings.period
		avg_close=0
		for i=index-xn, index-1 do
			avg_close = avg_close + C(i) -- сумма N предыдущих закрытий
		end
		avg_close = avg_close/xn
		for i=index-xn, index-1 do
			sig = sig + (C(i)-avg_close)^2 -- сумма квадратов отклонений
		end

		pow = (sig/xn)^0.5
		sigT = xsr+Settings.signC*pow
		sigB = xsr-Settings.signC*pow
		return sigT, xsr, sigB
	end	
end
