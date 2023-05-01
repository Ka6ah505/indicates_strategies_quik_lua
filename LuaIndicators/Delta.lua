--[=====[
	TODO: описать что делает этот код
	TODO: дать адекватное название индикатору
	TODO: привести в порядок стайл кода
	TODO: подготовить для работы на верии Lua 5.4.1
--]=====]
--[=====[
	Считает силу измениения текущей свечи (разница между Close и Open) 
		к последним N штук усредненным Close
	Занчение индикатора выше ноля в тех случаях если текущая свеча зеленая и 
		чем выше тем сильнее текущая свеча относительно среднего за N периодов
	Значение индикатора ниже ноля в тех случаях если текущая свеча красная и 
		чем ниже тем сильнее текущая свеча относительно среднего за N периодов
	Т.Е если показывается большое отклонение значит текущая свеча является импульсной,
		направление зависит от положения значения относительно ноля
--]=====]
Settings=
{
	Name = "(custom)Delta",
	period = 10,
	line =
	{
		{
			Name = "dlt1",
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
		xn = Settings.period
		xsr=0
		for i=index-xn+1, index do
			xsr = xsr + C(i)
		end
		xsr = xsr/xn

		return math.abs(xsr-(C(index)+O(index))/2)
	end	
end
