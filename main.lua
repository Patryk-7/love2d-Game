_G.love = require("love")

function love.load()
	love.graphics.setBackgroundColor(82 / 255, 165 / 255, 146 / 255)
	Music = love.audio.newSource("audioEx.mp3", "stream")

	-- Char Table
	Char = {
		x = 2000,
		y = 4500,
		sprite = love.graphics.newImage("sprites/spritesheet.png"),
		animation = {
			idle = true,
			direction = "right",
			attack = false,
			frame = 1,
			max_rows = 5,
			max_cols = 8,
			speed = 350,
			timer = 1,
		},
	}

	-- Sprite Definations
	SPRITE_WIDTH, SPRITE_HEIGHT = 15872, 9920
	QUAD_WIDTH, QUAD_HEIGHT = 2000, 1800 --2016 2028

	-- Death Animation Loop
	_G.death = {}
	for i = 1, 6 do
		death[i] = love.graphics.newQuad(QUAD_WIDTH * (i - 1), 0, QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
	end

	-- Idle Animation Loop
	_G.idle = {}
	for i = 1, 6 do
		idle[i] =
			love.graphics.newQuad(QUAD_WIDTH * (i - 1), 1950, QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
	end

	-- Running Animation Loop
	_G.run = {}
	for i = 1, Char.animation.max_cols do
		run[i] = love.graphics.newQuad(QUAD_WIDTH * (i - 1), 4020, QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
	end

	-- Attack Animation Loop
	_G.attack = {}
	for i = 1, 7 do
		attack[i] =
			love.graphics.newQuad(QUAD_WIDTH * (i - 1), 5900, QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
	end
end

function love.update(dt)
	-- Keyboard presses
	if love.keyboard.isDown("d") then
		Char.animation.idle = false
		Char.animation.direction = "right"
	elseif love.keyboard.isDown("a") then
		Char.animation.idle = false
		Char.animation.direction = "left"
	elseif love.keyboard.isDown("f") then
		Char.animation.attack = true
		Char.animation.idle = false
		Char.animation.direction = "none"
	else
		Char.animation.idle = true
		Char.animation.attack = false
		Char.animation.direction = "none"
	end

	--[[function love.keypressed(key)
		if key == "escape" then
			love.event.quit()
		elseif key == "f" then
			Char.animation.attack = true
			Char.animation.idle = false
			Char.animation.direction = "none"
		end
	end ]]
	--Char.animation.direction = "none"
	--Char.animation.frame = 1

	-- Idle Animation Timer
	if Char.animation.idle == true then
		Char.animation.timer = Char.animation.timer + dt

		if Char.animation.timer > 1 then
			Char.animation.timer = 0.9

			Char.animation.frame = Char.animation.frame + 1
			if Char.animation.idle == true then
				Char.x = Char.x
			end

			-- Refresh Animation
			if Char.animation.frame > 6 then
				Char.animation.frame = 1
			end
		end
	end

	-- Running Animation Timer
	if not Char.animation.idle then
		Char.animation.timer = Char.animation.timer + dt

		if Char.animation.timer > 1.1 then
			Char.animation.timer = 1

			-- Right and Left movement
			Char.animation.frame = Char.animation.frame + 1
			if Char.animation.direction == "right" then
				Char.x = Char.x + Char.animation.speed
			end
			if Char.animation.direction == "left" then
				Char.x = Char.x - Char.animation.speed
			end
			if Char.animation.direction == "none" then
				Char.x = Char.x
			end

			-- Refresh Animation
			if Char.animation.frame > Char.animation.max_cols then
				Char.animation.frame = 1
			end
			if Char.animation.attack then
				if Char.animation.frame > 7 then
					Char.animation.frame = 1
				end
			end
			--[[if Char.animation.attack == true then
				if Char.animation.frame > 7 then
					Char.animation.frame = 1
				end
			end ]]
		end
	end
end

function love.keypressed(key)
	if key == "space" then
		if Music:isPlaying() then
			Music:pause()
		else
			Music:play()
		end
	end
	if key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	-- FPS Counter
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, love.graphics.getHeight() - 30)

	--love.graphics.setColor(0, 0, 0)
	love.graphics.print("Press space to play/pause music", 10, 10)

	love.graphics.scale(0.1)
	if Char.animation.direction == "right" then
		Char.animation.idle = false
		Char.animation.attack = false
		love.graphics.draw(Char.sprite, run[Char.animation.frame], Char.x, Char.y)
	end
	if Char.animation.direction == "left" then
		Char.animation.idle = false
		Char.animation.attack = false
		love.graphics.draw(Char.sprite, run[Char.animation.frame], Char.x, Char.y, 0, -1, 1, QUAD_WIDTH, 0)
	end
	if Char.animation.idle == true then
		Char.animation.attack = false
		Char.animation.direction = "none"
		love.graphics.draw(Char.sprite, idle[Char.animation.frame], Char.x, Char.y)
	end
	if Char.animation.attack == true then
		Char.animation.idle = false
		Char.animation.direction = "none"
		love.graphics.draw(Char.sprite, attack[Char.animation.frame], Char.x, Char.y)
	end
	--love.graphics.draw(Char.sprite, death[Char.animation.frame], Char.x, Char.y)
	--love.graphics.draw(Char.sprite, attack[Char.animation.frame], Char.x, 7000)
end
