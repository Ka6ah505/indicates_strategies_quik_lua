--[=====[
	Считает силу измениения текущей свечи (середина тела между Close и Open) 
		к последним N штук усредненным телам (Open+Close)
	Занчение индикатора выше ноля в тех случаях если текущая свеча зеленая и 
		чем выше тем сильнее текущая свеча относительно среднего за N периодов
	Значение индикатора ниже ноля в тех случаях если текущая свеча красная и 
		чем ниже тем сильнее текущая свеча относительно среднего за N периодов
	Т.Е если показывается большое отклонение значит текущая свеча является импульсной,
		направление зависит от положения значения относительно ноля
--]=====]
-- Настройки линии, как она будет выглядеть на графике
Settings=
{
	Name = "(custom)Body Impulse",
	period = 10,
	line =
	{
		{
			Name = "body_impuls",
			Color = RGB(255, 150, 0),
			Type = TYPE_LINE,
			Width = 2
		}
	}
}

function Init()
	return #Settings.line
end

function OnCalculate(index)
	if index-1 < Settings.period then
		return nil
	else
		xn = Settings.period
		x_bodies=0
		for i=index-xn, index-1 do
			x_bodies = x_bodies + (C(i)+O(i))/2
		end
		x_bodies = x_bodies/xn

		return (C(index)+O(index))/2 - x_bodies
	end	
end
