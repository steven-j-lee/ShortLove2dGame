
love.graphics.setDefaultFilter("nearest", "nearest")
  enemy = {}
  enemies_controller = {}
  enemies_controller.enemies = {}
  enemies_controller.image = love.graphics.newImage("enemy.png")
  enemies_controller.image2 = love.graphics.newImage("enemy2.png")
  enemies_controller.image3 = love.graphics.newImage("enemy3.png")
  enemies_controller.image4 = love.graphics.newImage("enemy4.png")
  enemies_controller.waveTime = 0
  enemies_controller.wonWaves = 0
particle_systems = {}
particle_systems.list = {}

function particle_systems:cleanup()
  end

function checkCollisions(enemies, bullets)
  for i,e in pairs (enemies) do
    for _,b in pairs (bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x <= e.x + e.width then
        table.remove(enemies, i)
        player.score = player.score + 1 
        end
      end
    end
  end

function love.load()
  local bgm = love.audio.newSource("bgm.mp3")
  bgm:setLooping(true)
  love.audio.play(bgm)
  game_win = false
  game_over = false
  background_image = love.graphics.newImage("background.png")
  background_image2 = love.graphics.newImage("bg2.jpg")
  player = {}
  player.x = 300
  player.y = 500
  player.speed = 8
  player.score = 0
  player.bullets = {}
  player.cooldown = 10
  player.image = love.graphics.newImage("player.png")
  player.fire_sound = love.audio.newSource("laser.wav")
    player.fire = function()
    if player.cooldown <= 0 then
      
      love.audio.play(player.fire_sound)
    player.cooldown = 15
    bullet = {}
    bullet.x = player.x+50
    bullet.y = player.y
    table.insert(player.bullets, bullet)
  end
end

function enemies_controller: spawnEnemy(x,y)
  enemies ={}
  enemy = {}
  enemy.x = love.math.random(x, 8)
  enemy.y = y
  enemy.width = 106
  enemy.height = 100
  enemy.speed = 10
  enemy.bullets = {}
  enemy.cooldown =    --15
  table.insert(self.enemies, enemy) 
end

function enemies_controller:spawnWave()
    for i=6, 8 do
      enemies_controller:spawnEnemy (i * 80, 0)
    end
  end

function enemy:fire()
   if self.cooldown <= 0 then
    self.cooldown = 5
    bullet = {}
    bullet.x = self.x+50
    bullet.y = self.y
    table.insert(self.bullets, bullet)
    end
  end
function love.update(dt)
if love.keyboard.isDown('r') then
		love.event.quit("restart")
	end
  player.cooldown = player.cooldown - 1

if love.keyboard.isDown("d") then
  player.x = player.x + player.speed
elseif love.keyboard.isDown("a") then
  player.x = player.x - player.speed
end
if love.keyboard.isDown ("s") then
  player.y = player.y + player.speed
elseif love.keyboard.isDown ("w") then
  player.y = player.y - player.speed
end

if love.keyboard.isDown ("j") then
  player.fire()
end

  -- if #enemies_controller.enemies == 0 then
      --game_win = true
    --end
  for _,e in pairs(enemies_controller.enemies) do
    if e.y >= love.graphics.getHeight() then
      game_over = true
    else
    end
   e.y = e.y + 2.7
end

  for i,b in ipairs(player.bullets) do
    if b.y < -10 then
      table.remove(player.bullets, i)
      end
    b.y = b.y - 10
  end

  if enemies_controller.waveTime <= 0 then
    enemies_controller:spawnWave ()
    enemies_controller.waveTime = 0.1
    enemies_controller.wonWaves = enemies_controller.wonWaves + 1
else
enemies_controller.waveTime = enemies_controller.waveTime - dt
end
  checkCollisions(enemies_controller.enemies, player.bullets)
  end
function love.draw()
    love.graphics.draw(background_image)
        love.graphics.newFont(30)
    love.graphics.print("Shoot the villains!!!", 250, 0)
    
    love.graphics.print("Score:" .. player.score, 16, 16)
  love.graphics.scale(1)
  --elseif game_win then
  if game_over then
    love.graphics.print("Game Over",350,300)
    love.graphics.print("Press R to restart", 330, 400)
    love.graphics.print("Your R-score is:" .. 28+player.score/85-30, 325, 200)
    return
          -- love.graphics.print("Victory!")
    end
    
    
  love.graphics.setColor(255,255,255)
  love.graphics.draw(player.image, player.x, player.y)
  love.graphics.setColor (255,255,255)
  for _,e in pairs(enemies_controller.enemies) do
   love.graphics.draw(enemies_controller.image, e.x, e.y, 0, 2)
   end
  love.graphics.setColor(255,255,255)
  for j,b in pairs (player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 10, 10)
  end
end
end
