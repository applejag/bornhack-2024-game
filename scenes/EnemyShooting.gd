extends BulletShooting

func fire_with_throttle() -> void:
	EnemyShootingThrottle.instance.queue_fire(fire)
