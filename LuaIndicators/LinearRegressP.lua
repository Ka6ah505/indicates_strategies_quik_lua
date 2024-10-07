-- https://smart-lab.ru/blog/337978.php
Settings =
{
    Name = "xLinRegP",
    period = 20,
    deviation=2,
    line=
    {
        {
            Name = "xLinRegP",
            Color = RGB(128, 128, 255),
            Type = TYPE_LINE,
            Width = 4
        },
        {
            Name = "xLinRegP",
            Color = RGB(192,128,128),
            Type = TYPE_LINE,
            Width = 4
        },
        {
            Name = "xLinRegP",
            Color = RGB(96, 128,96),
            Type = TYPE_LINE,
            Width = 4
        }
    }
}

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
function cached_FF()
    local AMA={}
    local CC={}
    local II2 = 0
    local II4 = 0


    return function(ind, _p,_ddd)
        local period = _p
        local index = ind

        local vol = 0

        local sigma = 0
        local sigma2 = 0
        local sigma3 = 0
        local sigma4 = 0

        local aav = 0
        local aa = 0
        local bb = 0
        local cc = 0
        local ZZZ = 0
        local ttt = 0

        if index == 1 then

            AMA={}

            CC={}

            CC[index]=(C(index)+H(index)+L(index))/3

            AMA[index]=(C(index)+O(index))/2

                II2=0
                II4=0
            for i = 0, period-1 do
                ttt=(-(period-1)/2+i)^2
                II2=II2+ttt
                II4=II4+ttt^2
            end

            return nil
        end

            ------------------------------

        AMA[index]=AMA[index-1]
        ----------------------------------
        CC[index]=(C(index)+H(index)+L(index))/3
        ---------------------

        if index < (Size()-2) then return nil end

        ----------------------------------------------------

        sigma=0
        sigma2=0
        sigma3=0
        sigma4=0
        aav=0
        ZZZ=0
        for i = 0, period-1 do
            ZZZ=CC[index+i-period+1]

            aav=aav+ZZZ
            sigma=sigma+ZZZ*(-(period-1)/2+i)
            ttt=(-(period-1)/2+i)^2
            sigma3=sigma3+ZZZ*ttt
        end
        ------------------------
        bb=sigma/II2
        cc=(sigma3-aav*II2/period)/(II4-II2*II2/period)
        aa=(aav-cc*II2)/period
        aav=aav/period

        AMA[index]=aa+bb*((period-1)/2)+cc*((period-1)/2)^2             ------- парабола
        -------------------------------

        sigma=0
        sigma2=0
        sigma3 = 0
        for i = 0, period-1 do
            ZZZ=CC[index+i-period+1]
            sigma2=aa+bb*(-(period-1)/2+i)+cc*(-(period-1)/2+i)^2           ------- парабола
            sigma=sigma+(ZZZ-sigma2)^2
        end
        sigma=(sigma/period)^(1/2)

        for i = 1, period-1 do
            ZZZ=aa+bb*(-(period-1)/2+i)+cc*(-(period-1)/2+i)^2
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
    myFF = cached_FF()
    return 3
end

function OnCalculate(index)
    return myFF(index, Settings.period,Settings.deviation)         
end
