--[=====[
	Считает квадратное отклонение и строит канал между отклонениями
--]=====]
-- Настройки линий, как они будут выглядеть на графике
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
		local sum_squared = 0
		local xn = Settings.period
		local sum_closes=0
		for i=index-xn, index-1 do
			sum_closes = sum_closes + C(i) -- сумма N предыдущих закрытий
		end
		local avg_closes = sum_closes/xn
		for i=index-xn+1, index-1 do
			sum_squared = sum_squared + (C(i)-avg_closes)^2 -- сумма квадратов отклонений
		end

		local sig = (sum_squared / xn) ^ 0.5
		local sigT = avg_closes + Settings.signC * sig
		local sigB = avg_closes - Settings.signC * sig
		return sigT, avg_closes, sigB
	end
end
