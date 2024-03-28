extends Node2D

func showCircle():
	$Circle.show()
	$Sharp.hide()
	$Squircle.hide()

func showSquircle():
	$Circle.hide()
	$Sharp.hide()
	$Squircle.show()

func showSharp():
	$Circle.hide()
	$Sharp.show()
	$Squircle.hide()

func banCircle():
	$Round.show()
	$Square.hide()

func banSquare():
	$Round.hide()
	$Square.show()

func squareMedia():
	$squareMedia.show()

func circleMedia():
	$squareMedia.hide()
