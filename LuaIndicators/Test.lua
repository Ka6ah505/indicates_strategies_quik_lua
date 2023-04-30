Settings=
{
	Name = "(custom)TestTrend",
	period = 20,
	line =
	{
		{
			Name = "MA",
			Color = RGB(255, 0, 0),
			Type = TYPE_LINE,
			Width = 2
		}
	}	
}
function Init()
	return 1
end

function OnCalculate(index)
	if index < Settings.period then
		return nil
	else 
		avY=0
		XY=0
		qX = 0
		avX = 0
		xn = Settings.period
		for i=index-xn+1, index do
			avY = avY + C(i)
			XY = XY + (C(i) * (i-(index-xn)))
			avX = avX + (i-(index-xn))
			qX = qX+(i-(index-xn))*(i-(index-xn))
		end
		avX = avX/xn
		avY = avY / xn
		b = (XY - xn*avX*avY)/(qX-xn*avX*avX)
		a = avY-b*avX
		return a+b*xn
	end	
end
