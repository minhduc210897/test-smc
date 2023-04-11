package main

import (
	"fmt"
	"math/rand"
	"sync"

	"github.com/hajimehoshi/ebiten/v2"
	"github.com/hajimehoshi/ebiten/v2/ebitenutil"
	"github.com/hajimehoshi/ebiten/v2/inpututil"
)

var initializeOnce sync.Once

const (
	screenWidth  = 640
	screenHeight = 480
)

type Game struct {
	birdX   float64
	birdY   float64
	birdVel float64
	pipes   []*Pipe
	score   int
}

type Pipe struct {
	X    float64
	Y    float64
	VelX float64
}

var (
	birdImage       *ebiten.Image
	pipeImage       *ebiten.Image
	backgroundImage *ebiten.Image
)

func NewGame() *Game {
	pipes := []*Pipe{}
	for i := 0; i < 3; i++ {
		pipes = append(pipes, &Pipe{
			X:    float64(screenWidth + i*200),
			Y:    float64(rand.Intn(300) + 100),
			VelX: -2,
		})
	}

	return &Game{
		birdX: 50,
		birdY: screenHeight / 2,
		pipes: pipes,
	}
}

func (g *Game) Update() error {
	initializeOnce.Do(func() {
		var err error
		birdImage, _, err = ebitenutil.NewImageFromFile("bird.png")
		if err != nil {
			panic(err)
		}
		pipeImage, _, err = ebitenutil.NewImageFromFile("pipes.png")
		if err != nil {
			panic(err)
		}
		backgroundImage, _, err = ebitenutil.NewImageFromFile("background.png")
		if err != nil {
			panic(err)
		}
	})
	return nil
}

func (g *Game) Draw(screen *ebiten.Image) {
	screenWidth, screenHeight := screen.Size()

	// Draw the background
	opts := &ebiten.DrawImageOptions{}
	scaleX := float64(screenWidth) / float64(backgroundImage.Bounds().Dx())
	scaleY := float64(screenHeight) / float64(backgroundImage.Bounds().Dy())
	opts.GeoM.Scale(scaleX, scaleY)
	screen.DrawImage(backgroundImage, opts)

	// Draw the bird
	birdOpts := &ebiten.DrawImageOptions{}
	birdOpts.GeoM.Translate(g.birdX, g.birdY)
	screen.DrawImage(birdImage, birdOpts)

	//
	// Draw the pipes
	for _, pipe := range g.pipes {
		pipeOpts := &ebiten.DrawImageOptions{}
		pipeOpts.GeoM.Translate(pipe.X, pipe.Y)
		screen.DrawImage(pipeImage, pipeOpts)
	}

	// Draw the score
	ebitenutil.DebugPrint(screen, fmt.Sprintf("Score: %d", g.score))
}

func (g *Game) Layout(outsideWidth, outsideHeight int) (int, int) {
	const aspectRatio = 4.0 / 3.0
	if float64(outsideWidth)/float64(outsideHeight) > aspectRatio {
		return int(float64(outsideHeight) * aspectRatio), outsideHeight
	} else {
		return outsideWidth, int(float64(outsideWidth) / aspectRatio)
	}
}

func (g *Game) UpdateBird() {
	g.birdVel += 0.25
	g.birdY += g.birdVel

	if inpututil.IsKeyJustPressed(ebiten.KeySpace) {
		g.birdVel = -6.5
	}
}

func (p *Pipe) Update() {
	p.X += p.VelX
}

func main() {
	ebiten.SetWindowSize(screenWidth, screenHeight)
	ebiten.SetWindowTitle("Flappy Bird in Golang")
	ebiten.SetTPS(1000)
	game := NewGame()
	if err := ebiten.RunGame(game); err != nil {
		panic(err)
	}
}
