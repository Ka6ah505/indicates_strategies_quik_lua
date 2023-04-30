--[=====[
	TODO: описать что делает этот код
	TODO: дать адекватное название индикатору
	TODO: привести в порядок стайл кода
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
