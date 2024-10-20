local separator = "↑"
local percent = 1
luaDebugMode = true
function onCreatePost()
	makeLuaSprite("scoreTxtBG", "", 0, 0)
	makeGraphic("scoreTxtBG", 2048, 40, "000000")
	setObjectCamera("scoreTxtBG", "hud")
	screenCenter("scoreTxtBG", "x")
	setProperty("scoreTxtBG.alpha", 0.5)
	addLuaSprite("scoreTxtBG")
	makeLuaText("TheScore", "Hola soy un texto :D", screenWidth, 0, getProperty("healthBar.y")+35)
	setTextSize("TheScore", 23)
	setObjectCamera("TheScore", "hud")
	addLuaText("TheScore")
	makeLuaText("healthTxt", "Hola soy un texto :D", getProperty("healthBar.width"), getProperty("healthBar.x"), getProperty("healthBar.y"))
	setTextSize("healthTxt", 19)
	setObjectCamera("healthTxt", "hud")
	addLuaText("healthTxt")
	setProperty("scoreTxtBG.y", getProperty("TheScore.y")-10)
	makeLuaSprite("t", "", 0, 0)
	makeGraphic("t", screenWidth, 10, "ffaa00")
	setObjectCamera("t", "hud")
	addLuaSprite("t")
	setProperty("scoreTxt.visible", false)
	setProperty("healthBar.scale.x", 1.4)
	runHaxeCode("game.comboGroup.cameras = [game.camGame]")
	changeCustomScoreText()
end

local successHits = 0
local acc = 0
local sco = 0
local mis = 0
function changeCustomScoreText()
	acc = lerp(acc, rating*100, 0.1)
	sco = lerp(sco, score, 0.1)
	mis = lerp(mis, misses, 0.1)
	local stats = {
		--{name, value},
		{"Score", math.floor(sco)},
		{"Misses", math.floor(mis)},
		{"Accuracy", round(acc, 2).."%"},
	}
	local XD = ""
	for i, v in pairs(stats) do
		if i == #stats then
			XD = XD..v[1]..": "..v[2].." "
		else
			XD = XD..v[1]..": "..v[2].." "..separator.." "
		end
	end
	setTextString("TheScore", XD)
	if getSongPosition() >= 0 then
		percent = lerp(percent, math.max(getSongPosition()/songLength, 0), 0.15)
	else
		percent = lerp(percent, 0, 0.1)
	end
	scaleObject("t", percent, 1)
end

local flip = false
local percent = 50
local timer = 0
function onUpdatePost(e)
	setTextString("healthTxt", "Health: "..math.floor(getHealth()*50).."%")
	changeCustomScoreText()
	if flinch == true then
		setProperty("iconP1.animation.curAnim.curFrame", 1)
		setProperty("boyfriend.alpha", math.cos(timer))
	else
		setProperty("boyfriend.alpha", 1)
	end
	timer = timer + 5
	angle = math.cos(getSongPosition()/500)*20
	setProperty("iconP1.angle", angle)
	setProperty("iconP2.angle", angle)
end

function lerp(a, b, c)
	return a + ((b - a) / (c*100))
end

function string.time(ms, milli)
local s = math.floor(ms / 1000)
local m = math.floor(s/60)
if milli == true then
local display_ms = math.floor(ms / 100) % 10
return string.format("%s:%02d.%s", m, s % 60, display_ms)
else
return string.format("%s:%02d", m, s % 60)
end
end

function noteMissPress()
	flinch = true
	cancelTimer("flinch")
	runTimer("flinch", 0.25)
end

function noteMiss()
	flinch = true
	cancelTimer("flinch")
	runTimer("flinch", 0.25)
end

function onTimerCompleted(tag)
	if tag == "flinch" then
		flinch = false
	end
end

function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end
