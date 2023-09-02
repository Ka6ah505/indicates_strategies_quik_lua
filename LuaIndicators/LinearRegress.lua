-- https://smart-lab.ru/blog/337952.php?ysclid=llqvdprxln252474520
Settings =
{
    Name = "xLinReg",
    period = 20,
    deviation=2,
    line=
    {
        {
            Name = "xLinReg",
            Color = RGB(0, 0, 255),
            Type = TYPE_LINE,
            Width = 3
        },
        {
            Name = "xLinReg",
            Color = RGB(192, 0, 0),
            Type = TYPE_LINE,
            Width = 3
        },
        {
            Name = "xLinReg",
            Color = RGB(0, 128, 0),
            Type = TYPE_LINE,
            Width = 3
        }
    }
}


----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
function c_FF()

    local AMA={}
    local CC={}

    return function(ind, _p,_ddd)
        local period = _p
        local index = ind

        local vol = 0

        local sigma = 0
        local sigma2 = 0

        local aav = 0
        local bb = 0
        local ZZZ = 0

        if index == 1 then
            AMA={}
            CC={}

            CC[index]=(C(index)+H(index)+L(index))/3
            AMA[index]=(C(index)+O(index))/2

            return nil
        end

        ------------------------------
        AMA[index]=AMA[index-1]
        CC[index]=(C(index)+H(index)+L(index))/3
        ---------------------

        if index < (_p) then return nil end
        ----------------------------------------------------

        period =_p
        if index < period then period = index end
        --------------- 
        sigma=0
        sigma2=0
        aav=0
        ZZZ=0
        for i = 0, period-1 do
            ZZZ=CC[index+i-period+1]
            aav=aav+ZZZ
            sigma=sigma+ZZZ*(-(period-1)/2+i)
            sigma2=sigma2+(-(period-1)/2+i)^2
        end

            ------------------------
        bb=sigma/sigma2
        aav=aav/period

        AMA[index]=aav+bb*((period-1)/2) ---------линейная регрессия
        -------------------------------

        sigma=0
        sigma2=0
        sigma3 = 0
        for i = 0, period-1 do
            ZZZ=CC[index+i-period+1]
            sigma2=aav+bb*(-(period-1)/2+i)
            sigma=sigma+(ZZZ-sigma2)^2
        end
        sigma=(sigma/period)^(1/2)

        for i = 1, period-1 do
            ZZZ=aav+bb*(-(period-1)/2+i)
            SetValue(index+i-period+1, 3, ZZZ)
            SetValue(index+i-period+1, 2, ZZZ+sigma*_ddd)
            SetValue(index+i-period+1, 1, ZZZ-sigma*_ddd)

        end
        SetValue(index+0-period+1, 3, nil)
        SetValue(index+0-period+1, 2, nil)
        SetValue(index+0-period+1, 1, nil)

        ----------------------------------

        return AMA[index]-sigma*_ddd,AMA[index]+sigma*_ddd, AMA[index]
    end
end
----------------------------    ----------------------------    ----------------------------
----------------------------    ----------------------------    ----------------------------
----------------------------    ----------------------------    ----------------------------

function Init()
    myFF = c_FF()
    return 3
end

function OnCalculate(index)
    return myFF(index, Settings.period,Settings.deviation)
end
